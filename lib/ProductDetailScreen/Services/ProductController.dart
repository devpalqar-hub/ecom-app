import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:new_project/Home%20Page/Model/ProdutModel.dart';
import 'package:new_project/ProductDetailScreen/Models/ProductDetailModel.dart';
import 'package:new_project/main.dart';
import 'package:new_project/utils.dart';

class Productcontroller extends GetxController {
  final String productId;

  Productcontroller(this.productId); // ✅ FIXED

  ProductDetailModel? product;
  List<ProductModel> releatedProducts = [];
  bool isLoading = true;
  Variations? selectedVariation;
  int selectedVariationIndex = 0;
  bool isWishlistLoading = false;
  bool isCartLoading = false;

  Future<void> fetchProduct() async {
    isLoading = true;
    update();

    var response = await get(
      Uri.parse("$baseUrl/products/$productId"),
      headers: {"Authorization": "Bearer $accessToken"},
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      product = ProductDetailModel.fromJson(data["data"]);

      // Set first variation as default if variations exist
      if (product!.variations != null && product!.variations!.isNotEmpty) {
        selectedVariation = product!.variations!.first;
        selectedVariationIndex = 0;
      }

      fetchRelatedProduct(product!.subCategory!.categoryId!);
    }

    isLoading = false;
    update();
  }

  Future<void> fetchRelatedProduct(String categoryID) async {
    releatedProducts.clear();
    var response = await get(
      Uri.parse("$baseUrl/products?categoryId=${categoryID}&limit=8&page=1 "),
      headers: {"Authorization": "Bearer $accessToken"},
    );

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      for (var data in body["data"]["data"])
        releatedProducts.add(ProductModel.fromJson(data));
      update();
    }
    isLoading = false;
    update();
  }

  void selectVariation(int index) {
    if (product!.variations != null && index < product!.variations!.length) {
      selectedVariationIndex = index;
      selectedVariation = product!.variations![index];
      update();
    }
  }

  String getCurrentPrice() {
    if (selectedVariation != null) {
      return selectedVariation!.discountedPrice ?? "0";
    }
    return product?.discountedPrice ?? "0";
  }

  String? getCurrentActualPrice() {
    if (selectedVariation != null) {
      if (selectedVariation!.discountedPrice !=
          selectedVariation!.actualPrice) {
        return selectedVariation!.actualPrice;
      }
      return null;
    }
    if (product?.discountedPrice != product?.actualPrice &&
        product?.actualPrice != null) {
      return product!.actualPrice;
    }
    return null;
  }

  Future<void> toggleWishlist() async {
    if (isWishlistLoading) return;

    if (login != "IN") {
      showLoginDialog();
      return;
    }

    bool currentStatus = product?.isWishlisted ?? false;

    if (currentStatus) {
      await removeFromWishlist();
    } else {
      await addToWishlist();
    }
  }

  bool checkStock() {
    if (selectedVariation != null) {
      print(selectedVariation!.stockCount);
      return (selectedVariation!.stockCount ?? 0) > 0;
    } else {
      return product!.isStock ?? true;
    }
  }

  Future<void> addToWishlist() async {
    isWishlistLoading = true;
    update();

    Map<String, dynamic> body = {"productId": productId};

    // Add variation ID if product has variations
    if (selectedVariation != null) {
      body["productVariationId"] = selectedVariation!.id;
    }

    try {
      var response = await post(
        Uri.parse("$baseUrl/wishlist"),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
        body: json.encode(body),
      );

      print("Wishlist add response: ${response.body}");
      print("Status code: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        product!.isWishlisted = true;
        Fluttertoast.showToast(msg: "Added to wishlist");
      } else {
        Fluttertoast.showToast(msg: "Failed to add to wishlist");
      }
    } catch (e) {
      print("Error adding to wishlist: $e");
      Fluttertoast.showToast(msg: "Error adding to wishlist");
    }

    isWishlistLoading = false;
    update();
  }

  Future<void> removeFromWishlist() async {
    isWishlistLoading = true;
    update();

    try {
      var response = await delete(
        Uri.parse("$baseUrl/wishlist?productId=$productId"),
        headers: {"Authorization": "Bearer $accessToken"},
      );

      print("Wishlist remove response: ${response.body}");
      print("Status code: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 204) {
        product!.isWishlisted = false;
      } else {
        Fluttertoast.showToast(msg: "Failed to remove from wishlist");
      }
    } catch (e) {
      print("Error removing from wishlist: $e");
      Fluttertoast.showToast(msg: "Error removing from wishlist");
    }

    isWishlistLoading = false;
    update();
  }

  Future<void> addToCart() async {
    if (isCartLoading) return;

    isCartLoading = true;
    update();

    Map<String, dynamic> body = {"productId": productId, "quantity": 1};

    // Add variation ID if product has variations
    if (selectedVariation != null) {
      body["productVariationId"] = selectedVariation!.id;
    }

    try {
      var response = await post(
        Uri.parse("$baseUrl/cart/add"),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
        body: json.encode(body),
      );

      print("Cart add response: ${response.body}");
      print("Status code: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        product!.isInCart = true;
        Fluttertoast.showToast(msg: "Added to cart");
      } else {
        Fluttertoast.showToast(msg: "Failed to add to cart");
      }
    } catch (e) {
      print("Error adding to cart: $e");
      Fluttertoast.showToast(msg: "Error adding to cart");
    }

    isCartLoading = false;
    update();
  }

  Future<void> removeFromCart() async {
    if (isCartLoading) return;

    isCartLoading = true;
    update();

    try {
      var response = await delete(
        Uri.parse("$baseUrl/cart/delete-cart?id=$productId"),
        headers: {"Authorization": "Bearer $accessToken"},
      );

      print("Cart remove response: ${response.body}");
      print("Status code: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 204) {
        product!.isInCart = false;
        Fluttertoast.showToast(msg: "Removed from cart");
      } else {
        Fluttertoast.showToast(msg: "Failed to remove from cart");
      }
    } catch (e) {
      print("Error removing from cart: $e");
      Fluttertoast.showToast(msg: "Error removing from cart");
    }

    isCartLoading = false;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    fetchProduct(); // ✅ call here
  }
}
