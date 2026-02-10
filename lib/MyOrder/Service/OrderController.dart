import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:new_project/LoginScreen/Service/AuthenticationController.dart';
import 'package:new_project/MyOrder/Model/OrderDetailModel.dart';
import 'package:new_project/MyOrder/Model/OrderModel.dart';
import 'package:new_project/main.dart';

class OrderController extends GetxController {
  var orders = <OrderModel>[].obs;
  var isLoading = false.obs;
  var error = RxnString();
  var selectedOrder = Rxn<OrderDetailModel>();

  int page = 1;
  final int limit = 10;
  final RxMap<String, int> reviewedProducts = <String, int>{}.obs;

  @override
  void onInit() {
    fetchOrders();
    super.onInit();
  }

  void setReviewedProduct(String productId, int rating) {
    reviewedProducts[productId] = rating;
  }

  Future<void> fetchOrders({String? status}) async {
    try {
      isLoading.value = true;
      error.value = null;

      String url = '$baseUrl/orders?page=$page&limit=$limit';
      if (status != null && status.isNotEmpty) {
        url += '&status=$status';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        final List data = decoded['data']['data'];

        orders.assignAll(data.map((e) => OrderModel.fromJson(e)).toList());

        if (data.isNotEmpty) {
          debugPrint('First Order JSON: ${data.first}');
        }
      } else {
        error.value = response.body;
        debugPrint('Error Response: ${response.body}');
      }
    } catch (e) {
      error.value = e.toString();
      debugPrint('Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getOrderById(String orderId) async {
    try {
      isLoading.value = true;
      error.value = null;

      final response = await http.get(
        Uri.parse('$baseUrl/orders/$orderId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        selectedOrder.value = OrderDetailModel.fromJson(decoded['data']);

        reviewedProducts.clear();
        for (var item in selectedOrder.value!.items) {
          if (item.review != null) {
            reviewedProducts[item.product.id] = item.review!.rating;
          }
        }
        reviewedProducts.refresh();
      } else {
        error.value = response.body;
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> cancelOrder(String orderId) async {
    try {
      isLoading.value = true;
      error.value = null;

      final url = '$baseUrl/orders/$orderId/cancel';

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final Map<String, dynamic> payload = {
        "reason": "User requested cancellation",
      };
      print("Payload being sent: ${jsonEncode(payload)}");

      final response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(payload),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final orderJson = decoded['data']?['order'];
        if (orderJson == null) throw Exception('Order data missing');

        final updatedOrder = OrderDetailModel.fromJson(orderJson);

        selectedOrder.value = updatedOrder;

        final index = orders.indexWhere((o) => o.id == orderId);
        if (index != -1) {
          orders[index] = OrderModel.fromJson(orderJson);
          orders.refresh();
        }

        return true;
      } else {
        print("Failed to cancel order with status: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Exception during cancelOrder: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitReview({
    required String productId,
    required String orderId,
    required int rating,
    String? comment,
  }) async {
    try {
      isLoading.value = true;
      error.value = null;

      final url = '$baseUrl/reviews';

      final body = jsonEncode({
        "productId": productId,
        "orderId": orderId,
        "rating": rating,
        "comment": comment?.trim() ?? "",
      });

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: body,
      );

      print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        reviewedProducts[productId] = rating;
        reviewedProducts.refresh();

        Get.snackbar(
          'Thank you!',
          'Review submitted successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        error.value = response.body;
        Get.snackbar(
          'Error',
          'Failed to submit review',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'Something went wrong',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
