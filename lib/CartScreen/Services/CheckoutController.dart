import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:new_project/CartScreen/Model/AddressModel.dart';
import 'package:new_project/CartScreen/Model/CoupenModel.dart';
import 'package:new_project/main.dart';

class CheckoutController extends GetxController {

  final RxList<AddressModel> addresses = <AddressModel>[].obs;
  final Rx<AddressModel?> selectedAddress = Rx<AddressModel?>(null);

  final RxBool isLoading = false.obs;
  final RxnString error = RxnString();

  AddressModel? get defaultAddress {
    try {
      return addresses.firstWhere((e) => e.isDefault);
    } catch (_) {
      return null;
    }
  }

  Future<void> fetchAddresses() async {
    try {
      isLoading.value = true;
      error.value = null;

      final response = await http.get(
        Uri.parse("$baseUrl/addresses"),
        headers: {
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final list = (body['data'] as List)
            .map((e) => AddressModel.fromJson(e))
            .toList();

        addresses.assignAll(list);

        if (selectedAddress.value == null && defaultAddress != null) {
          selectedAddress.value = defaultAddress;
        }
      } else {
        error.value = "Failed to fetch addresses";
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addAddress(Map<String, dynamic> data) async {
  try {
    isLoading.value = true;
    error.value = null;

   
    data.remove('customerProfileId');

   
    

    final response = await http.post(
      Uri.parse("$baseUrl/addresses"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(data),
    );

   

    if (response.statusCode == 201 || response.statusCode == 200) {
      await fetchAddresses();
      return true;
    } else {
      final res = jsonDecode(response.body);
      error.value = res['message']?.toString() ?? "Failed to add address";
      return false;
    }
  } catch (e) {
    error.value = e.toString();
    debugPrint("ERROR => $e");
    return false;
  } finally {
    isLoading.value = false;
  }
}


  Future<bool> updateAddress(String id, Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      error.value = null;

     

      final response = await http.put(
        Uri.parse("$baseUrl/addresses/$id"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        await fetchAddresses();
        return true;
      } else {
        error.value = response.body;
        return false;
      }
    } catch (e) {
      error.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setDefaultAddress(String id) async {
    try {
      isLoading.value = true;

      final response = await http.patch(
        Uri.parse("$baseUrl/addresses/set-default/$id"),
        headers: {
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        await fetchAddresses();
      }
    } finally {
      isLoading.value = false;
    }
  }

 
 Future<Map<String, dynamic>> createOrder({
  required String shippingAddressId,
  String? couponName, 
  bool useCart = true,
  String? productId,
  String? variationId,
  int quantity = 1,
  String currency = "inr",
  String paymentMethod = "cash_on_delivery",
}) async {
  
  final body = {
    "useCart": useCart,
    "ShippingAddressId": shippingAddressId,
    "currency": currency,
    "paymentMethod": paymentMethod,
    "couponName": couponName ?? "",

    if (!useCart) ...{
      "productId": productId,
      if (variationId != null) "variationId": variationId,
      "quantity": quantity,
    }
  };

  
  debugPrint("========== CREATE ORDER PAYLOAD ==========");
  debugPrint(jsonEncode(body));
  debugPrint("=========================================");

  final response = await http.post(
    Uri.parse("$baseUrl/payments/create-order"),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken",
    },
    body: jsonEncode(body),
  );

  debugPrint("STATUS CODE: ${response.statusCode}");
  debugPrint("RESPONSE BODY: ${response.body}");

  if (response.statusCode == 200 || response.statusCode == 201) {
    return jsonDecode(response.body);
  } else {
    throw Exception(response.body);
  }
}
}