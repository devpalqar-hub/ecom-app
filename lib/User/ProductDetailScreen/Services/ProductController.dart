import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:new_project/User/Home%20Page/Model/ProdutModel.dart';
import 'package:new_project/User/ProductDetailScreen/Models/ProductDetailModel.dart';
import 'package:new_project/User/Wishlist/Model/WishlistProductModel.dart';
import 'package:new_project/User/Wishlist/Service/WishlistController.dart';
import 'package:new_project/main.dart';
import 'package:new_project/utils.dart';

class Productcontroller extends GetxController {
  final String productId;

  Productcontroller(this.productId);

  ProductDetailModel? product;
  List<ProductModel> releatedProducts = [];
  bool isLoading = true;
  Variations? selectedVariation;
  int? selectedVariationIndex;
  bool isWishlistLoading = false;
  bool isCartLoading = false;
  Set<String> cartedKeys = {};
  Set<String> wishlistedKeys = {};

  // ── Variation selection state ─────────────────────────────────────────────
  String? selectedSize;
  String? selectedColor;

  final WishlistController wishlistController = Get.put(WishlistController());

  final Map<String, String> wishlistIdMap = {};

  String? getSizeImage(String size) {
    final variation = product?.variations?.firstWhereOrNull(
      (v) => v.attributes?.size == size,
    );

    return (variation?.images != null && variation!.images!.isNotEmpty)
        ? variation.images!.first
        : product?.images?.first.url;
  }

  bool isVariationInWishlist(String? size, String? color) {
    final variation = product?.variations?.firstWhere(
      (v) => v.attributes?.size == size && v.attributes?.color?.name == color,
      orElse: () => Variations(),
    );

    return variation?.id != null && wishlistedKeys.contains(variation!.id);
  }

  String? getColorImage(String color) {
    final variation = product?.variations?.firstWhereOrNull(
      (v) => v.attributes?.color?.name == color,
    );

    return (variation?.images != null && variation!.images!.isNotEmpty)
        ? variation.images!.first
        : product?.images?.first.url;
  }

  bool get isVariationSelected {
    if (!hasVariations) return true;

    if (hasSizeVariations && (selectedSize == null || selectedSize!.isEmpty)) {
      return false;
    }

    if (hasColorVariations &&
        (selectedColor == null || selectedColor!.isEmpty)) {
      return false;
    }

    return true;
  }

  List<String> get availableSizes {
    final vars = product?.variations ?? [];

    final sizes = vars
        .map((v) => v.attributes?.size)
        .whereType<String>()
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();

    // Sort ascending
    sizes.sort((a, b) {
      // Try numeric sort first (for sizes like 28, 30, 32)
      final aNum = int.tryParse(a);
      final bNum = int.tryParse(b);

      if (aNum != null && bNum != null) {
        return aNum.compareTo(bNum);
      }

      // Standard clothing size order
      const sizeOrder = [
        "XXS",
        "XS",
        "S",
        "M",
        "L",
        "XL",
        "XXL",
        "3XL",
        "4XL",
        "5XL",
        "6XL",
      ];

      final aIndex = sizeOrder.indexOf(a.toUpperCase());
      final bIndex = sizeOrder.indexOf(b.toUpperCase());

      if (aIndex != -1 && bIndex != -1) {
        return aIndex.compareTo(bIndex);
      }

      // Fallback alphabetical
      return a.compareTo(b);
    });

    return sizes;
  }

  List<String> get availableColors {
    final vars = product?.variations ?? [];

    final filtered = selectedSize != null
        ? vars.where((v) => v.attributes?.size == selectedSize).toList()
        : vars;

    return filtered
        .map((v) => v.attributes?.color?.name)
        .whereType<String>()
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();
  }

  // Check what type of variations exist
  bool get hasSizeVariations => availableSizes.isNotEmpty;
  bool get hasColorVariations {
    if (product?.variations == null) return false;
    return product!.variations!.any((v) => v.attributes?.color?.name != null);
  }

  bool get hasVariations =>
      product?.variations != null && product!.variations!.isNotEmpty;

  // Get color hex for display
  String? getColorHex(String colorName) {
    final variation = product?.variations?.firstWhere(
      (v) => v.attributes?.color?.name == colorName,
      orElse: () => Variations(),
    );
    return variation?.attributes?.color?.hex;
  }

  // ── Selection methods ─────────────────────────────────────────────────────

  void selectSize(String size) {
    // Toggle unselect
    if (selectedSize == size) {
      selectedSize = null;
      selectedVariation = null;
      update();
      return;
    }

    selectedSize = size;

    // Remove invalid color
    if (selectedColor != null && !availableColors.contains(selectedColor)) {
      selectedColor = null;
    }

    // Auto-select color if only one option exists
    if (hasColorVariations && availableColors.length == 1) {
      selectedColor = availableColors.first;
    }

    _updateSelectedVariation();
    update();
  }

  void selectColor(String color) {
    // Toggle unselect
    if (selectedColor == color) {
      selectedColor = null;
      selectedVariation = null;
      update();
      return;
    }

    selectedColor = color;

    _updateSelectedVariation();
    update();
  }

  void _updateSelectedVariation() {
    if (product?.variations == null) return;

    // Nothing selected
    if (selectedSize == null && selectedColor == null) {
      selectedVariation = null;
      return;
    }

    selectedVariation = product!.variations!.firstWhereOrNull((v) {
      final sizeMatch =
          selectedSize == null || v.attributes?.size == selectedSize;

      final colorMatch =
          selectedColor == null || v.attributes?.color?.name == selectedColor;

      return sizeMatch && colorMatch;
    });

    update();
  }

  bool isVariationInCart(String? size, String? color) {
    final variation = product?.variations?.firstWhere(
      (v) => v.attributes?.size == size && v.attributes?.color?.name == color,
      orElse: () => Variations(),
    );
    return variation?.id != null && cartedKeys.contains(variation!.id);
  }

  bool isProductOrVariationInCart({String? productId, String? variationId}) {
    if (variationId != null && cartedKeys.contains(variationId)) {
      return true;
    }
    if (productId != null && cartedKeys.contains(productId)) {
      return true;
    }
    return false;
  }

  bool get isAnyVariationInCart {
    if (selectedSize != null || selectedColor != null) {
      return false;
    }

    if (cartedKeys.contains(productId)) {
      return true;
    }

    for (final variation in product?.variations ?? []) {
      if (variation.id != null && cartedKeys.contains(variation.id)) {
        return true;
      }
    }

    return false;
  }

  String get _currentCartKey => selectedVariation?.id ?? productId;

  bool get isCurrentInCart =>
      cartedKeys.contains(_currentCartKey) || isAnyVariationInCart;

  String get _currentWishlistKey => selectedVariation?.id ?? productId;

  bool get isCurrentWishlisted {
    final result =
        wishlistedKeys.contains(_currentWishlistKey) ||
        isSelectedVariationWishlisted;
    return result;
  }

  bool get isSelectedVariationWishlisted {
    if (selectedVariation?.id != null &&
        wishlistedKeys.contains(selectedVariation!.id!)) {
      return true;
    }
    if (wishlistedKeys.contains(productId)) {
      return true;
    }

    return false;
  }

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

        await _syncCartState();
        await _syncWishlistState();

        fetchRelatedProduct(product!.subCategory!.categoryId!);
      }
    } catch (e) {}

    isLoading = false;
    update();
  }

  Future<void> _syncCartState() async {
    try {
      final url = "$baseUrl/cart";

      var response = await get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        final items = body["data"]?["items"] as List<dynamic>? ?? [];

        cartedKeys = items
            .where((item) => item["productId"] == productId)
            .map<String>((item) {
              final varId = item["productVariationId"];
              final key = (varId != null && varId.toString().isNotEmpty)
                  ? varId.toString()
                  : item["productId"].toString();
              return key;
            })
            .toSet();
      } else {}
    } catch (e, stack) {}

    // if(isProductOrVariationInCart(
    //   productId: productId,
    //   variationId: selectedVariation?.id,
    // )){

    //   isCurrentInCart = true;

    // }

    update();
  }

  Future<void> _syncWishlistState() async {
    try {
      final response = await get(
        Uri.parse("$baseUrl/wishlist"),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final wishlistResponse = WishlistResponse.fromJson(body);

        final items = wishlistResponse.data.items;

        wishlistedKeys.clear();
        wishlistIdMap.clear();

        for (final item in items) {
          if (item.productId == productId) {
            final key =
                item.productVariationId != null &&
                    item.productVariationId!.isNotEmpty
                ? item.productVariationId!
                : item.productId!;

            wishlistedKeys.add(key);

            // Store wishlistId for later delete call
            if (item.wishlistId != null) {
              wishlistIdMap[key] = item.wishlistId!;
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Wishlist Sync Error: $e");
    }

    update();
  }

  Future<void> fetchRelatedProduct(String categoryID) async {
    try {
      releatedProducts.clear();
      update();

      final response = await get(
        Uri.parse("$baseUrl/products?categoryId=$categoryID&limit=8&page=1"),
        headers: {"Authorization": "Bearer $accessToken"},
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        releatedProducts = (body["data"]["data"] as List)
            .map((e) => ProductModel.fromJson(e))
            .where((product) => product.id != productId)
            .toList();

        update();
      }
    } catch (e) {}
  }

  void selectVariation(int index) {
    if (product!.variations != null && index < product!.variations!.length) {
      selectedVariationIndex = index;
      selectedVariation = product!.variations![index];
      update();
    }
  }

  // ── Price helpers ────────

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

  bool checkStock() {
    if (selectedVariation != null) {
      return (selectedVariation!.stockCount ?? 0) > 0;
    }

    return product?.isStock ?? true;
  }

  // ── Wishlist ───────

  Future<void> toggleWishlist() async {
    if (isWishlistLoading) return;

    if (login != "IN") {
      showLoginDialog();
      return;
    }

    if (hasVariations && selectedVariation == null) {
      Fluttertoast.showToast(msg: "Please select variation");
      return;
    }

    if (isCurrentWishlisted) {
      await removeFromWishlist();
    } else {
      await addToWishlist();
    }
  }

  // --- add to wishlist -----

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
        await _syncWishlistState();
        wishlistedKeys.add(_currentWishlistKey);
        Fluttertoast.showToast(msg: "Added to wishlist");
      } else {
        Fluttertoast.showToast(msg: "Failed to add to wishlist");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error adding to wishlist");
    }

    isWishlistLoading = false;
    update();
  }

  /// --remove from wishlist ----
  Future<void> removeFromWishlist() async {
    isWishlistLoading = true;
    update();

    final currentKey = selectedVariation?.id ?? productId;
    final wishlistId = wishlistIdMap[currentKey];

    if (wishlistId == null) {
      debugPrint("Wishlist ID not found for key: $currentKey");

      Fluttertoast.showToast(msg: "Wishlist item not found");

      isWishlistLoading = false;
      update();
      return;
    }
    final url = "$baseUrl/wishlist?id=$wishlistId";
    try {
      final response = await delete(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $accessToken"},
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        wishlistedKeys.remove(currentKey);
        wishlistIdMap.remove(currentKey);
        await _syncWishlistState();
        await wishlistController.fetchWishlist();
        Fluttertoast.showToast(msg: "Removed from wishlist");
      } else {
        Fluttertoast.showToast(msg: "Failed to remove from wishlist");
      }
    } catch (e, stackTrace) {
      Fluttertoast.showToast(msg: "Error removing from wishlist");
    }

    isWishlistLoading = false;
    update();
  }

  //----add to cart---
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
      Fluttertoast.showToast(msg: "Error adding to cart");
    }

    isCartLoading = false;
    update();
  }

  //----remove from cart---
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
