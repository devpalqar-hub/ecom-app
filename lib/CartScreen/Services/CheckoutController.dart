import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:new_project/CartScreen/Model/AddressModel.dart';
import 'package:new_project/main.dart';

enum PaymentMethod {
  cashOnDelivery('cash_on_delivery', 'Cash on Delivery', Icons.money);

  final String apiValue;
  final String displayName;
  final IconData icon;

  const PaymentMethod(this.apiValue, this.displayName, this.icon);
}

class CheckoutController extends GetxController {
  final RxList<AddressModel> addresses = <AddressModel>[].obs;
  final Rx<AddressModel?> selectedAddress = Rx<AddressModel?>(null);

  final RxBool isLoading = false.obs;
  final RxnString error = RxnString();

  // Delivery charges map: postalCode -> delivery charge
  final RxMap<String, double> deliveryCharges = <String, double>{}.obs;

  // Payment method selection
  final Rx<PaymentMethod> selectedPaymentMethod =
      PaymentMethod.cashOnDelivery.obs;

  // Get delivery charge for selected address
  double get currentDeliveryCharge {
    if (selectedAddress.value == null) return 0.0;
    return deliveryCharges[selectedAddress.value!.postalCode] ?? 0.0;
  }

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
        headers: {"Authorization": "Bearer $accessToken"},
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

  Future<Map<String, dynamic>?> checkDelivery(String postalCode) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/orders/check/delivery?postalCode=$postalCode"),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
      );

      debugPrint("Check Delivery Response: ${response.body} => $postalCode}h");
      debugPrint("Status Code: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body);
        final deliveryData = body['data']['data'];
        final deliveryCharge =
            double.tryParse(deliveryData['deliveryCharge'].toString()) ?? 0.0;

        // Store delivery charge for this postal code
        deliveryCharges[postalCode] = deliveryCharge;

        return {
          'success': true,
          'message': body['data']['message'],
          'deliveryCharge': deliveryCharge,
        };
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        return {
          'success': false,
          'message': 'Delivery not available at this location',
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to check delivery availability',
        };
      }
    } catch (e) {
      debugPrint("Error checking delivery: $e");
      return {
        'success': false,
        'message': 'Error checking delivery availability',
      };
    }
  }

  Future<bool> addAddress({
    required String name,
    required String address,
    required String city,
    required String state,
    required String postalCode,
    required String country,
    required String phone,
    String landmark = '',
    bool isDefault = false,
  }) async {
    try {
      isLoading.value = true;
      error.value = null;

      Map<String, dynamic> data = {
        "name": name,
        "address": address,
        "city": city,
        "state": state,
        "postalCode": postalCode,
        "country": country,
        "phone": phone,
        "isDefault": isDefault,
      };

      // Add landmark only if it's not empty
      if (landmark.isNotEmpty) {
        data["landmark"] = landmark;
      }

      final response = await http.post(
        Uri.parse("$baseUrl/addresses"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode(data),
      );

      debugPrint("Add Address Response: ${response.body}");
      debugPrint("Status Code: ${response.statusCode}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Address added successfully");
        await fetchAddresses();
        return true;
      } else {
        final res = jsonDecode(response.body);
        error.value = res['message']?.toString() ?? "Failed to add address";
        Fluttertoast.showToast(msg: error.value!);
        return false;
      }
    } catch (e) {
      error.value = e.toString();
      debugPrint("ERROR => $e");
      Fluttertoast.showToast(msg: "Error adding address");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addAddressOld(Map<String, dynamic> data) async {
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
        headers: {"Authorization": "Bearer $accessToken"},
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
    required double payableAmount,
    String? couponName,
    String? fatoorahPaymentId,
    bool useCart = true,
    String? productId,
    String? variationId,
    int quantity = 1,
  }) async {
    try {
      final paymentMethodValue = selectedPaymentMethod.value.apiValue;

      final body = {
        "useCart": true,
        "ShippingAddressId": shippingAddressId,
        "paymentMethod": paymentMethodValue,
        "couponName": couponName ?? "",
        if (fatoorahPaymentId != null) "fatoorahPaymentId": fatoorahPaymentId,
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
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to create order');
      }
    } catch (e) {
      debugPrint("ERROR creating order: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> processCheckout({
    required double payableAmount,
    String? couponName,
  }) async {
    try {
      if (selectedAddress.value == null) {
        Fluttertoast.showToast(msg: "Please select a delivery address");
        return null;
      }

      isLoading.value = true;

      // Create order with Cash on Delivery
      final orderResponse = await createOrder(
        shippingAddressId: selectedAddress.value!.id,
        payableAmount: payableAmount,
        couponName: couponName,
        useCart: true,
      );

      isLoading.value = false;

      Fluttertoast.showToast(msg: "Order placed successfully!");

      return orderResponse;
    } catch (e) {
      isLoading.value = false;
      debugPrint("Checkout error: $e");
      Fluttertoast.showToast(
        msg: "Failed to place order: ${e.toString()}",
        backgroundColor: Colors.red,
      );
      return null;
    }
  }
}
