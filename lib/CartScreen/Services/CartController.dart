import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:new_project/CartScreen/Model/CartModel.dart';
import 'package:new_project/main.dart';

class CartController extends GetxController {
  final isLoading = false.obs;
  final cart = Rxn<CartModel>();
  final error = RxnString();

  final couponLoading = false.obs;
  final appliedCoupon = RxnString();
  final discountAmount = 0.0.obs;
  final finalAmount = 0.0.obs;

  Future<void> fetchCart() async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse("$baseUrl/cart"),
        headers: {"Authorization": "Bearer $accessToken"},
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        cart.value = CartModel.fromJson(body);
      } else {
        cart.value = CartModel.empty();
      }
    } catch (e) {
      cart.value = CartModel.empty();
    } finally {
      isLoading.value = false;
    }
  }

  double getTotalPrice() {
    final items = cart.value?.data ?? const <CartItem>[];
    return items.fold<double>(0, (sum, item) => sum + item.lineTotal);
  }

  double getPayableTotal() {
    return (getTotalPrice() - discountAmount.value).clamp(0.0, double.infinity);
  }

  Future<void> applyCoupon(String couponName) async {
    try {
      couponLoading.value = true;

      final payload = {
        "couponName": couponName,
        "orderAmount": getTotalPrice().round(),
      };

      final response = await http.post(
        Uri.parse("$baseUrl/coupons/apply/coupon"),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 201 && body['success'] == true) {
        appliedCoupon.value = couponName;
        discountAmount.value = (body['data']['discount'] ?? 0).toDouble();
        finalAmount.value = (body['data']['finalAmount'] ?? getTotalPrice())
            .toDouble();
      } else {
        clearCoupon();
        Get.snackbar("Coupon Error", body['message'] ?? "Invalid coupon");
      }
    } catch (_) {
      clearCoupon();
      Get.snackbar("Error", "Failed to apply coupon");
    } finally {
      couponLoading.value = false;
    }
  }

  void clearCoupon() {
    appliedCoupon.value = null;
    discountAmount.value = 0.0;
    finalAmount.value = 0.0;
  }

  Future<void> addToCart({
    required String productId,
    required int quantity,
    String? productVariationId,
  }) async {
    try {
      clearCoupon();
      isLoading.value = true;

      final payload = {
        "productId": productId,
        "quantity": quantity,
        if (productVariationId != null)
          "productVariationId": productVariationId,
      };

      final response = await http.post(
        Uri.parse("$baseUrl/cart/add"),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 201) {
        await fetchCart();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeFromCart(String cartItemId, int quantity) async {
    clearCoupon();

    final index = cart.value?.data.indexWhere((i) => i.id == cartItemId);
    if (index == null || index == -1) return;

    final removedItem = cart.value!.data[index];

    cart.value!.data.removeAt(index);
    cart.refresh();

    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/cart/delete-cart/$cartItemId"),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"quantity": quantity}),
      );
      print(response.body);
      if (response.statusCode != 200) {
        cart.value!.data.insert(index, removedItem);
        cart.refresh();
      }
    } catch (_) {
      cart.value!.data.insert(index, removedItem);
      cart.refresh();
    }
  }

  Future<void> addToIncrement(String cartKey, int delta) async {
    final items = cart.value?.data;
    if (items == null) return;

    final index = items.indexWhere((i) => i.cartKey == cartKey);
    if (index == -1) return;

    final item = items[index];
    final oldQty = item.quantity;
    final newQty = oldQty + delta;

    if (newQty <= 0) {
      await removeFromCart(item.id, item.quantity);
      return;
    }

    clearCoupon();

    items[index] = item.copyWith(quantity: newQty);
    cart.refresh();

    try {
      final payload = {
        "quantity": newQty,
        if (item.productVariationId != null &&
            item.productVariationId!.isNotEmpty)
          "productVariationId": item.productVariationId
        else
          "productId": item.productId,
      };

      final response = await http.patch(
        Uri.parse("$baseUrl/cart/update-cart"),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode != 200) {
        items[index] = item.copyWith(quantity: oldQty);
        cart.refresh();
      }
    } catch (_) {
      items[index] = item.copyWith(quantity: oldQty);
      cart.refresh();
    }
  }
}
