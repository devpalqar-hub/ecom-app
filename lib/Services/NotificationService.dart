import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:new_project/main.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Initialize notification service
  static Future<void> initialize() async {
    // Request permission for iOS
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('Notification permission status: ${settings.authorizationStatus}');

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      // Get FCM token
      String? token = await _messaging.getToken();
      print('FCM Token: $token');

      if (token != null) {
        await _saveFCMToken(token);
      }

      // Listen for token refresh
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        print('FCM Token refreshed: $newToken');
        _saveFCMToken(newToken);
      });

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

      // Handle notification clicks
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationClick);

      // Check if app was opened from a notification
      RemoteMessage? initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationClick(initialMessage);
      }
    }
  }

  // Save FCM token to backend
  static Future<void> _saveFCMToken(String token) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');

      if (accessToken != null && accessToken.isNotEmpty) {
        final response = await http.post(
          Uri.parse('$baseUrl/users/fcm-token/users/'),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
          body: json.encode({'token': token}),
        );

        print('FCM Token Save Response: ${response.statusCode}');
        if (response.statusCode == 200 || response.statusCode == 201) {
          prefs.setString('fcm_token', token);
          print('FCM token saved successfully');
        }
      }
    } catch (e) {
      print('Error saving FCM token: $e');
    }
  }

  // Handle foreground messages
  static void _handleForegroundMessage(RemoteMessage message) {
    print('Foreground message received: ${message.notification?.title}');

    // Show in-app notification
    if (message.notification != null) {
      Get.snackbar(
        message.notification!.title ?? 'Notification',
        message.notification!.body ?? '',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Color(0xFFAE933F),
        colorText: Colors.white,
        duration: Duration(seconds: 4),
        margin: EdgeInsets.all(16),
        borderRadius: 12,
        icon: Icon(Icons.notifications, color: Colors.white),
        shouldIconPulse: true,
      );
    }
  }

  // Handle notification clicks
  static void _handleNotificationClick(RemoteMessage message) {
    print('Notification clicked: ${message.data}');

    // Navigate based on notification data
    if (message.data.containsKey('type')) {
      String type = message.data['type'];

      switch (type) {
        case 'order':
          if (message.data.containsKey('orderId')) {
            Get.toNamed(
              '/order-detail',
              arguments: {'orderId': message.data['orderId']},
            );
          }
          break;
        case 'product':
          if (message.data.containsKey('productId')) {
            Get.toNamed(
              '/product-detail',
              arguments: {'productId': message.data['productId']},
            );
          }
          break;
        default:
          // Navigate to home or show notification list
          break;
      }
    }
  }
}

// Top-level function for background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Background message received: ${message.notification?.title}');
}
