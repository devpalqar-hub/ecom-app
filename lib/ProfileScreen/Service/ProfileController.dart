import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:new_project/LoginScreen/Service/AuthenticationController.dart';
import 'package:new_project/ProfileScreen/Model/ProfileModel.dart';

import 'package:new_project/main.dart';
class UserProfileController extends GetxController {
  final isLoading = false.obs;
  final profile = Rxn<ProfileResponse>();
  final error = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      error.value = null;

      final response = await http.get(
        Uri.parse("$baseUrl/auth/customer/profile"),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {
        profile.value =
            ProfileResponse.fromJson(jsonDecode(response.body));
      } else {
        error.value = "Failed (${response.statusCode})";
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  String get userName =>
      profile.value?.data.customerProfile?.name ?? "Guest User";
}
