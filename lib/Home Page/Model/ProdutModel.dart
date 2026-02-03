/* =========================================================
   SAFE PARSING HELPERS
========================================================= */

import 'package:new_project/Home%20Page/Model/FeaturedProduct.dart';

double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  return double.tryParse(value.toString()) ?? 0.0;
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  return int.tryParse(value.toString()) ?? 0;
}

/* =========================================================
   PRODUCT MODEL
========================================================= */

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double discountedPrice;
  final double actualPrice;
  final bool isStock;
  final int stockCount;
  final List<ProductImage> images;
  final SubCategory subCategory;
  final List<Variation> variations;
  final bool isWishlisted;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.discountedPrice,
    required this.actualPrice,
    required this.isStock,
    required this.stockCount,
    required this.images,
    required this.subCategory,
    required this.variations,
    required this.isWishlisted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      discountedPrice: _toDouble(json['discountedPrice']),
      actualPrice: _toDouble(json['actualPrice']),
      isStock: json['isStock'] ?? false,
      stockCount: _toInt(json['stockCount']),
      images: (json['images'] as List?)
              ?.map((e) => ProductImage.fromJson(e))
              .toList() ??
          [],
      subCategory: SubCategory.fromJson(json['subCategory']),
      variations: (json['variations'] as List?)
              ?.map((e) => Variation.fromJson(e))
              .toList() ??
          [],
      isWishlisted: json['is_wishlisted'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

/* =========================================================
   PRODUCT IMAGE
========================================================= */

class ProductImage {
  final String id;
  final String productId;
  final String url;
  final String altText;
  final bool isMain;
  final int sortOrder;

  ProductImage({
    required this.id,
    required this.productId,
    required this.url,
    required this.altText,
    required this.isMain,
    required this.sortOrder,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'].toString(),
      productId: json['productId'].toString(),
      url: json['url'] ?? '',
      altText: json['altText'] ?? '',
      isMain: json['isMain'] ?? false,
      sortOrder: _toInt(json['sortOrder']),
    );
  }
}

/* =========================================================
   VARIATION
========================================================= */

class Variation {
  final String id;
  final String productId;
  final String variationName;
  final String sku;
  final double price;
  final int stockCount;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;

  Variation({
    required this.id,
    required this.productId,
    required this.variationName,
    required this.sku,
    required this.price,
    required this.stockCount,
    required this.isAvailable,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Variation.fromJson(Map<String, dynamic> json) {
    return Variation(
      id: json['id'].toString(),
      productId: json['productId'].toString(),
      variationName: json['variationName'] ?? '',
      sku: json['sku'] ?? '',
      price: _toDouble(json['price']),
      stockCount: _toInt(json['stockCount']),
      isAvailable: json['isAvailable'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

/* =========================================================
   SUB CATEGORY
========================================================= */

