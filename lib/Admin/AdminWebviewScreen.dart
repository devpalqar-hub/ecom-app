import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_project/LoginScreen/LoginScreen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class AdminWebViewScreen extends StatefulWidget {
  final String accessToken;

  const AdminWebViewScreen({super.key, required this.accessToken});

  @override
  State<AdminWebViewScreen> createState() => _AdminWebViewScreenState();
}

class _AdminWebViewScreenState extends State<AdminWebViewScreen> {
  late final WebViewController _controller;

  bool _isLoading = true;
  bool _hasError = false;
  bool _logoutHandled = false;

  int _progress = 0;

  String _errorMessage = "";

  /// ================= BASE URL =================

  static const String baseUrl = "https://admin.raheeb.qa";

  String get initialUrl => "$baseUrl/mobile/${widget.accessToken}";

  /// ================= INIT =================

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  /// ================= WEBVIEW INIT =================

  void _initializeWebView() {
    late final PlatformWebViewControllerCreationParams params;

    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    _controller = WebViewController.fromPlatformCreationParams(params);

    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..enableZoom(false)
      ..setNavigationDelegate(_navigationDelegate)
      ..addJavaScriptChannel("FlutterBridge", onMessageReceived: _onJsMessage)
      ..loadRequest(Uri.parse(initialUrl));

    /// ================= ANDROID CONFIG =================

    if (_controller.platform is AndroidWebViewController) {
      final androidController =
          _controller.platform as AndroidWebViewController;

      AndroidWebViewController.enableDebugging(false);

      androidController
        ..setMediaPlaybackRequiresUserGesture(false)
        ..setOverScrollMode(WebViewOverScrollMode.never)
        ..setOnShowFileSelector(_androidFilePicker)
        ..setGeolocationPermissionsPromptCallbacks(
          onShowPrompt: (request) async {
            final status = await Permission.location.request();

            return GeolocationPermissionsResponse(
              allow: status.isGranted,
              retain: false,
            );
          },
        );
    }
  }

  /// ================= NAVIGATION =================

  NavigationDelegate get _navigationDelegate => NavigationDelegate(
    onProgress: (progress) {
      if (!mounted) return;

      setState(() {
        _progress = progress;
      });
    },

    onPageStarted: (url) {
      log("PAGE STARTED: $url");

      if (!mounted) return;

      setState(() {
        _isLoading = true;
        _hasError = false;
      });
    },

    onPageFinished: (url) async {
      log("PAGE FINISHED: $url");

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      await _injectWebFixes();

      if (_isLoginUrl(url)) {
        _handleLogout();
      }
    },

    onNavigationRequest: (request) async {
      final url = request.url;

      log("NAVIGATION: $url");

      /// Logout detection
      if (_isLoginUrl(url)) {
        _handleLogout();

        return NavigationDecision.prevent;
      }

      /// Internal URLs
      if (url.startsWith(baseUrl)) {
        return NavigationDecision.navigate;
      }

      /// External apps / links
      await _openExternal(url);

      return NavigationDecision.prevent;
    },

    onWebResourceError: (error) {
      if (error.isForMainFrame ?? true) {
        log("WEBVIEW ERROR: ${error.description}");

        if (!mounted) return;

        setState(() {
          _hasError = true;
          _isLoading = false;
          _errorMessage = error.description;
        });
      }
    },
  );

  /// ================= JS CHANNEL =================

  void _onJsMessage(JavaScriptMessage message) {
    final data = message.message;

    log("JS MESSAGE: $data");

    if (data == "LOGOUT") {
      _handleLogout();
      return;
    }

    if (_isLoginUrl(data)) {
      _handleLogout();
    }
  }

  /// ================= WEB FIXES =================

  Future<void> _injectWebFixes() async {
    try {
      await _controller.runJavaScript('''
        (function() {

          var meta = document.querySelector(
            'meta[name="viewport"]'
          );

          if (!meta) {
            meta = document.createElement('meta');
            meta.name = 'viewport';
            document.head.appendChild(meta);
          }

          meta.content =
            'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';

          var style = document.createElement('style');

          style.innerHTML = `
            html, body {
              width: 100% !important;
              max-width: 100% !important;
              overflow-x: hidden !important;
              overflow-y: auto !important;
              margin: 0 !important;
              padding: 0 !important;
            }

            * {
              box-sizing: border-box !important;
              max-width: 100% !important;
            }
          `;

          document.head.appendChild(style);

          function notifyFlutter() {
            var url = window.location.href;

            FlutterBridge.postMessage(url);

            if (url.includes('/login')) {
              FlutterBridge.postMessage('LOGOUT');
            }
          }

          notifyFlutter();

          var pushState = history.pushState;

          history.pushState = function() {
            pushState.apply(history, arguments);
            notifyFlutter();
          };

          var replaceState = history.replaceState;

          history.replaceState = function() {
            replaceState.apply(history, arguments);
            notifyFlutter();
          };

          window.addEventListener(
            'popstate',
            notifyFlutter
          );

        })();
      ''');
    } catch (e) {
      log("JS Injection Error: $e");
    }
  }

  /// ================= FILE PICKER =================

  Future<List<String>> _androidFilePicker(FileSelectorParams params) async {
    try {
      final result = await FilePicker.platform.pickFiles(allowMultiple: false);

      if (result == null || result.files.isEmpty) {
        return [];
      }

      final path = result.files.single.path;

      if (path == null) return [];

      return [path];
    } catch (e) {
      log("FILE PICK ERROR: $e");
      return [];
    }
  }

  /// ================= LOGOUT =================

  Future<void> _handleLogout() async {
    if (_logoutHandled) return;

    _logoutHandled = true;

    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.clear();

      Get.offAll(() => LoginScreen());
    } catch (e) {
      log("LOGOUT ERROR: $e");
    }
  }

  /// ================= LOGIN URL =================

  bool _isLoginUrl(String url) {
    try {
      final uri = Uri.parse(url);

      return uri.path.contains("/login");
    } catch (_) {
      return false;
    }
  }

  /// ================= OPEN EXTERNAL =================

  Future<void> _openExternal(String url) async {
    try {
      final uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      log("EXTERNAL URL ERROR: $e");
    }
  }

  /// ================= REFRESH =================

  Future<void> _refresh() async {
    try {
      await _controller.reload();
    } catch (e) {
      log("REFRESH ERROR: $e");
    }
  }

  /// ================= BACK =================

  Future<bool> _onBackPressed() async {
    try {
      if (await _controller.canGoBack()) {
        await _controller.goBack();
        return false;
      }
    } catch (e) {
      log("BACK ERROR: $e");
    }

    return true;
  }

  /// ================= UI =================

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,

        body: SafeArea(
          child: Stack(
            children: [
              /// ================= WEBVIEW =================
              RefreshIndicator(
                onRefresh: _refresh,
                child: WebViewWidget(controller: _controller),
              ),

              /// ================= LOADER =================
              if (_isLoading)
                LinearProgressIndicator(value: _progress / 100, minHeight: 3),

              /// ================= ERROR =================
              if (_hasError)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.wifi_off,
                          size: 70,
                          color: Colors.grey,
                        ),

                        const SizedBox(height: 16),

                        Text(
                          "Something went wrong",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          _errorMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),

                        const SizedBox(height: 24),

                        ElevatedButton(
                          onPressed: _refresh,
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
