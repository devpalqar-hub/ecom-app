import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:new_project/User/CartScreen/Model/CartModel.dart';
import 'package:new_project/main.dart';

class CartController extends GetxController {
  final isLoading = false.obs;
  // final cart = Rxn<CartModel>();
  final error = RxnString();
  RxList<CartItemModel> cartItem = <CartItemModel>[].obs;
  final couponLoading = false.obs;
  final appliedCoupon = RxnString();
  final discountAmount = 0.0.obs;
  final finalAmount = 0.0.obs;

  Future<void> fetchCart() async {
    try {
      isLoading.value = true;
      cartItem.clear();

      final response = await http.get(
        Uri.parse("$baseUrl/cart"),
        headers: {"Authorization": "Bearer $accessToken"},
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        for (var data in body["data"]["items"]) {
          cartItem.add(CartItemModel.fromJson(data));
        }
        cartItem.refresh();
      } else {}
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  double getTotalPrice() {
    double subTotal = 0;
    for (var item in cartItem) {
      subTotal = subTotal + item.getEffectivePrice() * (item.quantity ?? 1);
    }
    return subTotal;
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
        Fluttertoast.showToast(
          msg: body['message']?.toString() ?? 'Invalid coupon code',
        );
      }
    } catch (_) {
      clearCoupon();
      Fluttertoast.showToast(msg: 'Failed to apply coupon. Please try again.');
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

    final index = cartItem.indexWhere((i) => i.id == cartItemId);
    if (index == -1) return;

    final removedItem = cartItem[index];
    cartItem.removeAt(index);
    cartItem.refresh();

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
        cartItem.insert(index, removedItem);
        cartItem.refresh();
      }
    } catch (_) {
      cartItem.insert(index, removedItem);
      cartItem.refresh();
    }
  }

  Future<void> addToIncrement(String cartItemId, int delta) async {
    final items = cartItem;

    final index = items.indexWhere((i) => i.id == cartItemId);
    if (index == -1) return;

    final item = items[index];
    final oldQty = item.quantity ?? 1;
    final newQty = oldQty + delta;

    if (newQty <= 0) {
      if (item.id != null) {
        await removeFromCart(item.id!, oldQty);
      }
      return;
    }

    final stockCount = item.getStockCount();
    if (newQty > stockCount) {
      Fluttertoast.showToast(
        msg: "Only $stockCount item(s) available in stock",
      );
      return;
    }

    clearCoupon();

    items[index].quantity = newQty;
    cartItem.refresh();

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
        items[index].quantity = oldQty;
        cartItem.refresh();
        Fluttertoast.showToast(msg: "Failed to update cart");
      }
    } catch (_) {
      items[index].quantity = oldQty;
      cartItem.refresh();
      Fluttertoast.showToast(msg: "Failed to update cart");
    }
  }
}
