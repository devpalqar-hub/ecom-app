import 'dart:convert';

class FeaturedProductCategoryModel {
  final String id;
  final String name;
  final String subCategoryId;
  final String discountedPrice;
  final String actualPrice;
  final String description;
  final int stockCount;
  final bool isStock;
  final bool isFeatured;
  final List<ProductImage> images;
  final SubCategory subCategory;
  final List<ProductVariation> variations;
  final bool isWishlisted;

  FeaturedProductCategoryModel({
    required this.id,
    required this.name,
    required this.subCategoryId,
    required this.discountedPrice,
    required this.actualPrice,
    required this.description,
    required this.stockCount,
    required this.isStock,
    required this.isFeatured,
    required this.images,
    required this.subCategory,
    required this.variations,
    required this.isWishlisted,
  });

  factory FeaturedProductCategoryModel.fromJson(Map<String, dynamic> json) {
    return FeaturedProductCategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      subCategoryId: json['subCategoryId'] ?? '',
      discountedPrice: json['discountedPrice'] ?? '0',
      actualPrice: json['actualPrice'] ?? '0',
      description: json['description'] ?? '',
      stockCount: json['stockCount'] ?? 0,
      isStock: json['isStock'] ?? true,
      isFeatured: json['isFeatured'] ?? true,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => ProductImage.fromJson(e))
              .toList() ??
          [],
      subCategory: SubCategory.fromJson(json['subCategory'] ?? {}),
      variations: (json['variations'] as List<dynamic>?)
              ?.map((e) => ProductVariation.fromJson(e))
              .toList() ??
          [],
      isWishlisted: json['is_wishlisted'] ?? false,
    );
  }
}

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
      id: json['id'] ?? '',
      productId: json['productId'] ?? '',
      url: json['url'] ?? '',
      altText: json['altText'] ?? '',
      isMain: json['isMain'] ?? false,
      sortOrder: json['sortOrder'] ?? 0,
    );
  }
}

class ProductVariation {
  final String id;
  final String productId;
  final String variationName;
  final String sku;
  final String discountedPrice;
  final String actualPrice;
  final int stockCount;
  final bool isAvailable;

  ProductVariation({
    required this.id,
    required this.productId,
    required this.variationName,
    required this.sku,
    required this.discountedPrice,
    required this.actualPrice,
    required this.stockCount,
    required this.isAvailable,
  });

  factory ProductVariation.fromJson(Map<String, dynamic> json) {
    return ProductVariation(
      id: json['id'] ?? '',
      productId: json['productId'] ?? '',
      variationName: json['variationName'] ?? '',
      sku: json['sku'] ?? '',
      discountedPrice: json['discountedPrice'] ?? '0',
      actualPrice: json['actualPrice'] ?? '0',
      stockCount: json['stockCount'] ?? 0,
      isAvailable: json['isAvailable'] ?? true,
    );
  }
}

class SubCategory {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String categoryId;
  final String image;
  final Category category;

  SubCategory({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.categoryId,
    required this.image,
    required this.category,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      categoryId: json['categoryId'] ?? '',
      image: json['image'] ?? '',
      category: Category.fromJson(json['category'] ?? {}),
    );
  }
}

class Category {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String image;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
