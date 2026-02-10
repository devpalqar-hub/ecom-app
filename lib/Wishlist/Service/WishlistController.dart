import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:new_project/LoginScreen/Service/AuthenticationController.dart';
import 'package:new_project/Wishlist/Model/WishlistProductModel.dart';
import 'package:new_project/main.dart';

class WishlistController extends GetxController {
  final wishlistItems = <WishlistProduct>[].obs;
  final isLoading = false.obs;
  final error = RxnString();

  
  final searchQuery = ''.obs;
  final sortOption = ''.obs; 
  final minPrice = 0.0.obs;
  final maxPrice = double.infinity.obs;

  void setSearchQuery(String value) => searchQuery.value = value;
  void setSortOption(String value) => sortOption.value = value;
  void setMinPrice(double value) => minPrice.value = value;
  void setMaxPrice(double value) => maxPrice.value = value;

  bool isProductWishlisted(String productId) {
    return wishlistItems.any(
      (item) => item.product?.id == productId,
    );
  }
Future<void> addToWishlist({
  String? productId,
  String? productVariationId,
}) async {
  try {
    isLoading.value = true;
    error.value = null;

    final url = Uri.parse("$baseUrl/wishlist");

    
    final Map<String, dynamic> body = {};

    if (productVariationId != null && productVariationId.isNotEmpty) {
      body["productVariationId"] = productVariationId;
    } else if (productId != null && productId.isNotEmpty) {
      body["productId"] = productId;
    } else {
      throw Exception("Product ID or Product Variation ID is required");
    }

    

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(body),
    );

    

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body);
      if (decoded['success'] == true) {
        await fetchWishlist();
        Get.snackbar("Success", "Added to wishlist");
      } else {
        error.value = decoded['message'] ?? "Failed to add to wishlist";
      }
    } else {
      error.value = "Server error ${response.statusCode}";
    }
  } catch (e) {
   
    error.value = e.toString();
  } finally {
    isLoading.value = false;
  }
}
Future<void> fetchWishlist({
  int page = 1,
  int limit = 10,
}) async {
  try {
    isLoading.value = true;
    error.value = null;

    final url = Uri.parse("$baseUrl/wishlist?page=$page&limit=$limit");
   

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

   
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded['success'] == true) {
  
        final List list = decoded['data']['data'] ?? [];
        wishlistItems.value = list
            .map((e) => WishlistProduct.fromJson(e))
            .where((e) => e.product != null)
            .toList();
       
      } else {
        error.value = "Failed to fetch wishlist";
      }
    } else {
      error.value = "Server error ${response.statusCode}";
    }
  } catch (e) {

    error.value = e.toString();
  } finally {
    isLoading.value = false;
  }
}


  Future<void> removeFromWishlist(
      String wishlistItemId, {
        bool showMessage = true,
      }) async {
    try {
      isLoading.value = true;
      error.value = null;

      final url =
          Uri.parse("$baseUrl/wishlist?id=$wishlistItemId");

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded['success'] == true) {
          wishlistItems.removeWhere(
            (item) => item.wishlistId == wishlistItemId,
          );
          if (showMessage) {
            Get.snackbar(
              "Success",
              "Removed from wishlist",
              snackPosition: SnackPosition.BOTTOM,
            );
          }

        } else {
          error.value = "Failed to remove item";
        }
      } else {
        error.value = "Server error ${response.statusCode}";
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  
  List<WishlistProduct> get filteredWishlist {
    final list = wishlistItems.where((item) {
      final product = item.product;
      if (product == null) return false;

      final price =
          double.tryParse(product.discountedPrice) ?? 0;

      return product.name
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()) &&
          price >= minPrice.value &&
          price <= maxPrice.value;
    }).toList();

    if (sortOption.value == "asc") {
      list.sort((a, b) =>
          (double.tryParse(a.product!.discountedPrice) ?? 0)
              .compareTo(
                  double.tryParse(b.product!.discountedPrice) ??
                      0));
    }

    if (sortOption.value == "desc") {
      list.sort((a, b) =>
          (double.tryParse(b.product!.discountedPrice) ?? 0)
              .compareTo(
                  double.tryParse(a.product!.discountedPrice) ??
                      0));
    }

    return list;
  }
}
