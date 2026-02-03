import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_project/Home%20Page/DashBoard.dart';
import 'package:new_project/LoginScreen/LoginScreen.dart';
import 'package:new_project/LoginScreen/Service/AuthenticationController.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? accessToken;
String baseUrl = "https://api.ecom.palqar.cloud/v1";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Register OTP Controller

  final prefs = await SharedPreferences.getInstance();
  accessToken = prefs.getString('access_token');

  Widget initialScreen;

  if (accessToken != null && !_isTokenExpired(accessToken!)) {
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
