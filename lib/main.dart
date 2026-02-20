import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_project/Home%20Page/DashBoard.dart';
import 'package:new_project/LoginScreen/LoginScreen.dart';
import 'package:new_project/LoginScreen/Service/AuthenticationController.dart';
import 'package:new_project/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? accessToken;
String baseUrl = (false)
    ? "https://api.raheeb.qa/v1"
    : "https://api.ecom.palqar.cloud/v1";
String? login;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Register OTP Controller

  final prefs = await SharedPreferences.getInstance();
  accessToken = prefs.getString('access_token');
  login = prefs.getString('LOGIN');

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request permission for iOS
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: true,
    criticalAlert: true,
    provisional: true,
    sound: true,
  );

  print('Notification permission status: ${settings.authorizationStatus}');

  Widget initialScreen;

  if (accessToken != null && !_isTokenExpired(accessToken!) && login == "IN") {
    initialScreen = DashBoard();
  } else {
    initialScreen = LoginScreen();
  }
  runApp(Raheeb(initialHome: initialScreen));
}

bool _isTokenExpired(String token) {
  try {
    final parts = token.split('.');
    if (parts.length != 3) return false;

    final payload = utf8.decode(
      base64Url.decode(base64Url.normalize(parts[1])),
    );
    final payloadMap = json.decode(payload);

    final exp = payloadMap['exp'];
    if (exp == null) return false;

    final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    return DateTime.now().isAfter(expiryDate);
  } catch (e) {
    return false;
  }
}

class Raheeb extends StatelessWidget {
  final Widget initialHome;
  const Raheeb({super.key, required this.initialHome});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(400, 850),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) =>
          GetMaterialApp(debugShowCheckedModeBanner: false, home: initialHome),
    );
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('Handling a background message: ${message.messageId}');
    print('Message data: ${message.data}');
  }
}
