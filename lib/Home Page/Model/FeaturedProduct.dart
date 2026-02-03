class FeaturedProductsResponse {
  final bool success;
  final FeaturedProductsData data;

  FeaturedProductsResponse({
    required this.success,
    required this.data,
  });

  factory FeaturedProductsResponse.fromJson(Map<String, dynamic> json) {
    return FeaturedProductsResponse(
      success: json['success'] ?? false,
      data: FeaturedProductsData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data.toJson(),
      };
}

class FeaturedProductsData {
  final List<FeaturedProduct> data;
  final Meta meta;

  FeaturedProductsData({
    required this.data,
    required this.meta,
  });

  factory FeaturedProductsData.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List<dynamic>? ?? [])
        .map((e) => FeaturedProduct.fromJson(e as Map<String, dynamic>))
        .toList();

    return FeaturedProductsData(
      data: list,
      meta: Meta.fromJson(json['meta'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data.map((e) => e.toJson()).toList(),
        'meta': meta.toJson(),
      };
}

class FeaturedProduct {
  final String id;
  final String name;
  final String subCategoryId;
  final String discountedPrice;
  final String actualPrice;
  final String description;
  final int stockCount;
  final bool isStock;
  final bool isFeatured;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ProductImage> images;
  final SubCategory subCategory;
  final List<dynamic> variations;
  final bool isWishlisted;

  FeaturedProduct({
    required this.id,
    required this.name,
    required this.subCategoryId,
    required this.discountedPrice,
    required this.actualPrice,
    required this.description,
    required this.stockCount,
    required this.isStock,
    required this.isFeatured,
    required this.createdAt,
    required this.updatedAt,
    required this.images,
    required this.subCategory,
    required this.variations,
    required this.isWishlisted,
  });

  factory FeaturedProduct.fromJson(Map<String, dynamic> json) {
    final imagesRaw = (json['images'] as List<dynamic>? ?? [])
        .map((e) => ProductImage.fromJson(e as Map<String, dynamic>))
        .toList();

    return FeaturedProduct(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      subCategoryId: json['subCategoryId'] ?? '',
      discountedPrice: json['discountedPrice'] ?? '0',
      actualPrice: json['actualPrice'] ?? '0',
      description: json['description'] ?? '',
      stockCount: json['stockCount'] ?? 0,
      isStock: json['isStock'] ?? false,
      isFeatured: json['isFeatured'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ??
          DateTime.now(),
      images: imagesRaw,
      subCategory: SubCategory.fromJson(json['subCategory'] ?? {}),
      variations: json['variations'] ?? [],
      isWishlisted: json['is_wishlisted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'subCategoryId': subCategoryId,
        'discountedPrice': discountedPrice,
        'actualPrice': actualPrice,
        'description': description,
        'stockCount': stockCount,
        'isStock': isStock,
        'isFeatured': isFeatured,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'images': images.map((e) => e.toJson()).toList(),
        'subCategory': subCategory.toJson(),
        'variations': variations,
        'is_wishlisted': isWishlisted,
      };
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

  Map<String, dynamic> toJson() => {
        'id': id,
        'productId': productId,
        'url': url,
        'altText': altText,
        'isMain': isMain,
        'sortOrder': sortOrder,
      };
}

class SubCategory {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String categoryId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Category category;

  SubCategory({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      categoryId: json['categoryId'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      category: Category.fromJson(json['category'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'slug': slug,
        'description': description,
        'categoryId': categoryId,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'category': category.toJson(),
      };
}

class Category {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String? image;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      image: json['image'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'slug': slug,
        'description': description,
        'image': image,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

class Meta {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;

  Meta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrev,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 0,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      hasNext: json['hasNext'] ?? false,
      hasPrev: json['hasPrev'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'page': page,
        'limit': limit,
        'total': total,
        'totalPages': totalPages,
        'hasNext': hasNext,
        'hasPrev': hasPrev,
      };
}
