import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:new_project/Home%20Page/DashBoard.dart';
import 'package:new_project/LoginScreen/CompletePorfileBottomSheet.dart';
import 'package:new_project/LoginScreen/OtpVerificationScreen.dart';
import 'package:new_project/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Authenticationcontroller extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool isLoading = false;
  bool isNew = false;

  sendOtp() async {
    if (emailController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter the email ID");
      return;
    }
    if (!emailController.text.isEmail) {
      Fluttertoast.showToast(msg: "Please enter a valid email id");
      return true;
    }
    isLoading = true;
    update();
    var response = await post(
      Uri.parse(baseUrl + "/auth/otp/send"),
      body: {"email": emailController.text.trim()},
    );
    isLoading = false;
    update();

    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.to(() => OtpVerificationScreen(), transition: Transition.rightToLeft);
    }
  }

  void VerfyOtp() async {
    if (otpController.text.length != 6) {
      Fluttertoast.showToast(msg: "Please enter valid otp");
      return;
    }

    isLoading = true;
    update();
    final response = await post(
      Uri.parse(baseUrl + "/auth/otp/verify"),
      body: {"email": emailController.text, "otp": otpController.text},
    );
    isLoading = false;
    update();
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = json.decode(response.body);

      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString("access_token", data["data"]["access_token"]);
      accessToken = data["data"]["access_token"];

      // Request notification permission and send FCM token
      await _requestNotificationPermissionAndSendToken();

      if (data["data"]["isNew"]) {
        isNew = true;
        Get.bottomSheet(
          CompleteProfileBottomSheet(),
          isDismissible: false,
          enableDrag: false,
        );
      } else {
        Get.offAll(() => DashBoard(), transition: Transition.rightToLeft);
      }
    } else {
      var data = json.decode(response.body);
      var message = (data["message"] ?? "Something went wrong")
          .toString()
          .replaceAll("Invalid OTP", "Please enter a valid otp ");
      Fluttertoast.showToast(msg: message);
    }
  }

  // Request notification permission and send FCM token
  Future<void> _requestNotificationPermissionAndSendToken() async {
    try {
      // Request notification permission
      final FirebaseMessaging messaging = FirebaseMessaging.instance;

      // Request permission for iOS
      NotificationSettings settings = await messaging.requestPermission(
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
        String? fcmToken = await messaging.getToken();

        if (fcmToken != null) {
          print('FCM Token: $fcmToken');

          // Send FCM token to backend
          await _sendFCMTokenToBackend(fcmToken);
        } else {
          print('Failed to get FCM token');
        }
      } else {
        print('Notification permission denied');
      }
    } catch (e) {
      print('Error requesting notification permission: $e');
    }
  }

  // Send FCM token to backend
  Future<void> _sendFCMTokenToBackend(String fcmToken) async {
    try {
      final response = await post(
        Uri.parse(baseUrl + "/users/fcm-token/users/"),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
        body: json.encode({"token": fcmToken}),
      );

      print('FCM Token Response Status: ${response.statusCode}');
      print('FCM Token Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('FCM token sent successfully');
        // Save token locally to avoid sending again
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString("fcm_token", fcmToken);
      } else {
        print('Failed to send FCM token to backend');
      }
    } catch (e) {
      print('Error sending FCM token to backend: $e');
    }
  }

  void completeProfile() async {
    if (nameController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter your name");
      return;
    }
    if (phoneController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter your phone number");
      return;
    }

    isLoading = true;
    update();

    final response = await post(
      Uri.parse(baseUrl + "/auth/otp/complete"),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
      body: json.encode({
        "name": nameController.text.trim(),
        "phone": phoneController.text.trim(),
      }),
    );

    isLoading = false;
    update();

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.offAll(() => DashBoard(), transition: Transition.rightToLeft);
    } else {
      Fluttertoast.showToast(
        msg: "Failed to complete profile. Please try again.",
      );
    }
  }
}
