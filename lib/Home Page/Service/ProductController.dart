import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:new_project/CartScreen/Services/CartController.dart';

import 'package:new_project/Home Page/Model/CategoryModel.dart';
import 'package:new_project/Home Page/Model/ProdutModel.dart';
import 'package:new_project/Home Page/Model/FeaturedProduct.dart';
import 'package:new_project/Home Page/Model/ProductDetailModel.dart';

import 'package:new_project/Home Page/Model/FeaturedProductCategoryModel.dart';
import 'package:new_project/main.dart';

class ProductController extends GetxController {
  // ========================= HARD-CODED CATEGORY =========================
  static const String garmentsCategoryId =
      "2c64970b-306a-45fa-a767-0809cea521c4";

  // ========================= STATE =========================
  final categories = <CategoryModel>[].obs;
  final subCategories = <SubCategoryModel>[].obs;
  final products = <ProductModel>[].obs;
  final productDetail = Rxn<ProductDetailModel>();
  final isLoadingProductDetail = false.obs;

  final featuredProducts = <FeaturedProduct>[].obs;
  final featuredByCategory = <FeaturedProductCategoryModel>[].obs;
  final isLoadingFeaturedByCategory = false.obs;
  final featuredProductsMap =
      <String, List<FeaturedProductCategoryModel>>{}.obs;

  final isLoadingCategories = false.obs;
  final isLoadingSubCategories = false.obs;
  final isLoadingProducts = false.obs;
  final isLoadingFeaturedProducts = false.obs;
  final isUpdatingFeatured = false.obs;

  final cartController = Get.put(CartController());

  final selectedSubCategoryId = "".obs;

  final page = 1.obs;
  final hasNext = true.obs;

  bool isProductInCart({
    required String productId,
    String? productVariationId,
  }) {
    final cartItems = cartController.cart.value?.data ?? [];

    return cartItems.any((e) {
      if (productVariationId != null && productVariationId.isNotEmpty) {
        return e.productVariationId == productVariationId;
      }

      return e.productId == productId;
    });
  }

  Future<void> fetchCategories() async {
    try {
      isLoadingCategories.value = true;

      final res = await http.get(
        Uri.parse('$baseUrl/categories?isActive=true'),
      );

      if (res.statusCode == 200) {
        final decoded = json.decode(res.body);
        final List list = decoded['data']['data'];
        categories.assignAll(
          list.map((e) => CategoryModel.fromJson(e)).toList(),
        );
      } else {
        categories.clear();
      }
    } catch (e) {
      debugPrint(' fetchCategories error: $e');
      categories.clear();
    } finally {
      isLoadingCategories.value = false;
    }
  }

  Future<void> fetchSubCategories(String categoryId) async {
    try {
      isLoadingSubCategories.value = true;

      final res = await http.get(
        Uri.parse('$baseUrl/subcategories/category/$categoryId'),
      );

      if (res.statusCode == 200) {
        final data = json.decode(res.body)['data'] as List;
        subCategories.assignAll(
          data.map((e) => SubCategoryModel.fromJson(e)).toList(),
        );
      }
    } finally {
      isLoadingSubCategories.value = false;
    }
  }

  Future<void> fetchProducts({
    String? categoryId,
    String? subCategoryId,
    String? search,
    double? minPrice,
    double? maxPrice,
    int limit = 10,
    bool refresh = false,
  }) async {
    if (refresh) {
      page.value = 1;
      hasNext.value = true;
      products.clear();
    }

    if (!hasNext.value) return;

    try {
      isLoadingProducts.value = true;

      final query = <String, String>{
        'page': page.value.toString(),
        'limit': limit.toString(),
        if (categoryId != null && categoryId.isNotEmpty)
          'categoryId': categoryId,
        if (subCategoryId != null && subCategoryId.isNotEmpty)
          'subCategoryId': subCategoryId,
        if (search != null && search.isNotEmpty) 'search': search,
        if (minPrice != null) 'minPrice': minPrice.toString(),
        if (maxPrice != null) 'maxPrice': maxPrice.toString(),
      };

      final uri = Uri.parse(
        '$baseUrl/products',
      ).replace(queryParameters: query);
      final res = await http.get(uri);

      if (res.statusCode == 200) {
        final body = json.decode(res.body)['data'];
        final list = body['data'] as List;
        products.addAll(list.map((e) => ProductModel.fromJson(e)).toList());

        hasNext.value = body['meta']?['hasNext'] ?? false;
        page.value++;
      } else {
        debugPrint(' fetchProducts failed: ${res.statusCode}');
      }
    } catch (e) {
      debugPrint(' fetchProducts error: $e');
    } finally {
      isLoadingProducts.value = false;
    }
  }

  Future<void> fetchProductDetail(String productId) async {
    try {
      isLoadingProductDetail.value = true;

      final res = await http.get(Uri.parse('$baseUrl/products/$productId'));
      if (res.statusCode == 200) {
        final decoded = json.decode(res.body)['data'];
        productDetail.value = ProductDetailModel.fromJson(decoded);
      } else {
        debugPrint(' fetchProductDetail failed: ${res.statusCode}');
        productDetail.value = null;
      }
    } catch (e) {
      debugPrint(' fetchProductDetail error: $e');
      productDetail.value = null;
    } finally {
      isLoadingProductDetail.value = false;
    }
  }

  Future<void> fetchFeaturedProducts() async {
    try {
      isLoadingFeaturedProducts.value = true;

      final res = await http.get(Uri.parse('$baseUrl/products/featured'));

      if (res.statusCode == 200) {
        final decoded = json.decode(res.body);
        final dataList = decoded['data']['data'] as List<dynamic>? ?? [];
        featuredProducts.assignAll(
          dataList
              .map((e) => FeaturedProduct.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
      }
    } catch (e, stack) {
    } finally {
      isLoadingFeaturedProducts.value = false;
    }
  }

  Future<void> fetchFeaturedByCategory({required String categoryId}) async {
    try {
      isLoadingFeaturedByCategory.value = true;

      final uri = Uri.parse(
        '$baseUrl/products/featured',
      ).replace(queryParameters: {'categoryId': categoryId});

      final res = await http.get(uri);

      debugPrint('FEATURED BY CATEGORY STATUS: ${res.statusCode}');
      debugPrint('FEATURED BY CATEGORY RAW: ${res.body}');

      if (res.statusCode == 200) {
        final body = json.decode(res.body)['data'];
        final list = (body['data'] as List<dynamic>?) ?? [];

        featuredByCategory.assignAll(
          list
              .map(
                (e) => FeaturedProductCategoryModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
      } else {
        featuredByCategory.clear();
      }
    } catch (e) {
      featuredByCategory.clear();
    } finally {
      isLoadingFeaturedByCategory.value = false;
    }
  }

  void selectSubCategory({
    required String categoryId,
    required String subCategoryId,
  }) {
    selectedSubCategoryId.value = subCategoryId;

    fetchProducts(
      categoryId: categoryId,
      subCategoryId: subCategoryId,
      refresh: true,
    );
  }

  List<ProductModel> productsByCategoryName(String categoryName) {
    return products.where((p) {
      return p.subCategory?.category?.name == categoryName;
    }).toList();
  }

  List<ProductModel> productsBySubCategoryName(String subCategoryName) {
    return products.where((p) {
      return p.subCategory?.name == subCategoryName;
    }).toList();
  }

  Future<List<ProductModel>> fetchRelatedProducts(
    ProductDetailModel product,
  ) async {
    try {
      final query = <String, String>{};

      if (product.subCategory.id.isNotEmpty) {
        query['subCategoryId'] = product.subCategory.id;
      } else {
        query['categoryId'] = product.subCategory.categoryId;
      }

      final uri = Uri.parse(
        '$baseUrl/products',
      ).replace(queryParameters: query);
      final res = await http.get(uri);

      if (res.statusCode == 200) {
        final body = json.decode(res.body)['data'];
        final list = body['data'] as List;
        final productsList = list.map((e) => ProductModel.fromJson(e)).toList();

        return productsList.where((p) => p.id != product.id).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
