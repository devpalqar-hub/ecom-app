import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:new_project/User/Home%20Page/Model/ProdutModel.dart';
import 'package:new_project/User/ProductDetailScreen/Models/ProductDetailModel.dart';
import 'package:new_project/main.dart';
import 'package:new_project/utils.dart';

class Productcontroller extends GetxController {
  final String productId;

  Productcontroller(this.productId);

  ProductDetailModel? product;
  List<ProductModel> releatedProducts = [];
  bool isLoading = true;
  Variations? selectedVariation;
  int? selectedVariationIndex; // ✅ Fix #2: declare missing field
  bool isWishlistLoading = false;
  bool isCartLoading = false;
  Set<String> cartedKeys = {};

  // ── Variation selection state ─────────────────────────────────────────────
  String? selectedSize;
  String? selectedColor;

  // Derived lists
  List<String> get availableSizes {
    if (product?.variations == null) return [];
    return product!.variations!
        .map((v) => v.attributes?.size)           // ✅ Fix #1
        .where((s) => s != null && s.isNotEmpty)
        .cast<String>()
        .toSet()
        .toList();
  }

  List<String> get availableColors {
    if (product?.variations == null) return [];

    var variations = product!.variations!;
    if (selectedSize != null) {
      variations = variations
          .where((v) => v.attributes?.size == selectedSize)  // ✅ Fix #1
          .toList();
    }

    return variations
        .map((v) => v.attributes?.color?.name)               // ✅ Fix #1
        .where((c) => c != null && c.isNotEmpty)
        .cast<String>()
        .toSet()
        .toList();
  }

  // Check what type of variations exist
  bool get hasSizeVariations => availableSizes.isNotEmpty;
  bool get hasColorVariations {
    if (product?.variations == null) return false;
    return product!.variations!
        .any((v) => v.attributes?.color?.name != null);      // ✅ Fix #1
  }
  bool get hasVariations =>
      product?.variations != null && product!.variations!.isNotEmpty;

  // Get color hex for display
  String? getColorHex(String colorName) {
    final variation = product?.variations?.firstWhere(
      (v) => v.attributes?.color?.name == colorName,         // ✅ Fix #1
      orElse: () => Variations(),
    );
    return variation?.attributes?.color?.hex;                // ✅ Fix #1
  }

  // ── Selection methods ─────────────────────────────────────────────────────

  void selectSize(String size) {
    selectedSize = size;

    if (selectedColor != null && !availableColors.contains(selectedColor)) {
      selectedColor = null;
    }

    if (availableColors.length == 1) {
      selectedColor = availableColors.first;
    }

    _updateSelectedVariation();
    update();
  }

  void selectColor(String color) {
    selectedColor = color;

    if (selectedSize == null && hasSizeVariations) {
      final sizesWithColor = product!.variations!
          .where((v) => v.attributes?.color?.name == color)  // ✅ Fix #1
          .map((v) => v.attributes?.size)                    // ✅ Fix #1
          .where((s) => s != null)
          .toSet()
          .toList();

      if (sizesWithColor.length == 1) {
        selectedSize = sizesWithColor.first;
      }
    }

    _updateSelectedVariation();
    update();
  }

  void _updateSelectedVariation() {
    if (product?.variations == null) return;

    selectedVariation = product!.variations!.firstWhere(
      (v) {
        final sizeMatch =
            selectedSize == null || v.attributes?.size == selectedSize;       // ✅ Fix #1
        final colorMatch = selectedColor == null ||
            v.attributes?.color?.name == selectedColor;                       // ✅ Fix #1
        return sizeMatch && colorMatch;
      },
      orElse: () => product!.variations!.first,
    );
  }

  // Check if a specific size/color combo is in cart
  bool isVariationInCart(String? size, String? color) {
    final variation = product?.variations?.firstWhere(
      (v) =>
          v.attributes?.size == size &&                      // ✅ Fix #1
          v.attributes?.color?.name == color,               // ✅ Fix #1
      orElse: () => Variations(),
    );
    return variation?.id != null && cartedKeys.contains(variation!.id);
  }

  // ── Rest of your existing code... ─────────────────────────────────────────

  String get _currentCartKey => selectedVariation?.id ?? productId;
  bool get isCurrentInCart => cartedKeys.contains(_currentCartKey);

  Future<void> fetchProduct() async {
    isLoading = true;
    update();

    try {
      var response = await get(
        Uri.parse("$baseUrl/products/$productId"),
        headers: {"Authorization": "Bearer $accessToken"},
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        product = ProductDetailModel.fromJson(data["data"]);

        if (hasVariations) {
          if (hasSizeVariations) {
            selectedSize = availableSizes.first;
          }
          if (hasColorVariations) {
            selectedColor =
                availableColors.isNotEmpty ? availableColors.first : null;
          }
          _updateSelectedVariation();
        }

        await _syncCartState();
        fetchRelatedProduct(product!.subCategory!.categoryId!);
      }
    } catch (e) {
      print("Error fetching product: $e");
    }

    isLoading = false;
    update();
  }

  Future<void> _syncCartState() async {
    try {
      var response = await get(
        Uri.parse("$baseUrl/cart"),
        headers: {"Authorization": "Bearer $accessToken"},
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final items = body["data"]?["items"] as List<dynamic>? ?? [];

        cartedKeys = items
            .where((item) => item["productId"] == productId)
            .map<String>((item) {
              final varId = item["productVariationId"];
              return (varId != null && varId.toString().isNotEmpty)
                  ? varId.toString()
                  : item["productId"].toString();
            })
            .toSet();
      }
    } catch (e) {
      print("Error syncing cart state: $e");
    }
    update();
  }

  Future<void> fetchRelatedProduct(String categoryID) async {
    releatedProducts = [];
    update();
    try {
      var response = await get(
        Uri.parse("$baseUrl/products?categoryId=$categoryID&limit=8&page=1"),
        headers: {"Authorization": "Bearer $accessToken"},
      );

      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        releatedProducts = [];
        update();
        for (var data in body["data"]["data"]) {
          releatedProducts.add(ProductModel.fromJson(data));
        }
        update();
      }
    } catch (e) {
      print("Error fetching related products: $e");
    }

    isLoading = false;
    update();
  }

  // ── Variation selection ───────────────────────────────────────────────────

  void selectVariation(int index) {
    if (product!.variations != null && index < product!.variations!.length) {
      selectedVariationIndex = index;             // ✅ Fix #2: now declared above
      selectedVariation = product!.variations![index];
      update();
    }
  }

  // ── Price helpers ─────────────────────────────────────────────────────────

  String getCurrentPrice() {
    if (selectedVariation != null) {
      return selectedVariation!.discountedPrice ?? "0";
    }
    return product?.discountedPrice ?? "0";
  }

  String? getCurrentActualPrice() {
    if (selectedVariation != null) {
      if (selectedVariation!.discountedPrice != selectedVariation!.actualPrice) {
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

  bool checkStock() {
    if (selectedVariation != null) {
      return (selectedVariation!.stockCount ?? 0) > 0;
    }
    return product!.isStock ?? true;
  }

  // ── Wishlist ──────────────────────────────────────────────────────────────

  Future<void> toggleWishlist() async {
    if (isWishlistLoading) return;
    if (login != "IN") {
      showLoginDialog();
      return;
    }
    if (product?.isWishlisted ?? false) {
      await removeFromWishlist();
    } else {
      await addToWishlist();
    }
  }

  Future<void> addToWishlist() async {
    isWishlistLoading = true;
    update();

    Map<String, dynamic> body = {"productId": productId};
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

  // ── Cart ──────────────────────────────────────────────────────────────────

  Future<void> toggleCart() async {
    if (isCartLoading) return;
    if (login != "IN") {
      showLoginDialog();
      return;
    }

    if (!checkStock()) {
      Fluttertoast.showToast(msg: "Product is out of stock");
      return;
    }

    if (isCurrentInCart) {
      await removeFromCart();
    } else {
      await addToCart();
    }
  }

  Future<void> addToCart() async {
    isCartLoading = true;
    update();

    Map<String, dynamic> body = {"productId": productId, "quantity": 1};
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        cartedKeys.add(_currentCartKey);
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
    isCartLoading = true;
    update();

    try {
      final queryParam = selectedVariation != null
          ? "productVariationId=${selectedVariation!.id}"
          : "productId=$productId";

      var response = await delete(
        Uri.parse("$baseUrl/cart/delete-cart?$queryParam"),
        headers: {"Authorization": "Bearer $accessToken"},
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        cartedKeys.remove(_currentCartKey);
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
    fetchProduct();
  }
}