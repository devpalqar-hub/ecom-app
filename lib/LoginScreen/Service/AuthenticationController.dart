import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:new_project/Home%20Page/DashBoard.dart';
import 'package:new_project/Home%20Page/HomePage.dart';
import 'package:new_project/LoginScreen/CompletePorfileBottomSheet.dart';
import 'package:new_project/LoginScreen/OtpVerificationScreen.dart';
import 'package:new_project/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authenticationcontroller extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
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
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = json.decode(response.body);

      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString("access_token", data["data"]["access_token"]);
      accessToken = data["data"]["access_token"];
      if (data["data"]["isNew"]) {
        isNew = true;
        Get.bottomSheet(CompleteProfileBottomSheet());
      } else {
        Get.offAll(() => DashBoard(), transition: Transition.rightToLeft);
      }
    }
  }
}
