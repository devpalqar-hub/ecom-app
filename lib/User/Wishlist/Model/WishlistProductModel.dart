

class WishlistResponse {
  final bool success;
  final WishlistData data;

  WishlistResponse({
    required this.success,
    required this.data,
  });

  factory WishlistResponse.fromJson(Map<String, dynamic> json) {
    return WishlistResponse(
      success: json['success'] ?? false,
      data: WishlistData.fromJson(json['data'] ?? {}),
    );
  }
}

class WishlistData {
  final List<WishlistProduct> items;
  final WishlistMeta meta;

  WishlistData({
    required this.items,
    required this.meta,
  });

  factory WishlistData.fromJson(Map<String, dynamic> json) {
    return WishlistData(
      items: (json['data'] as List<dynamic>? ?? [])
          .map((e) => WishlistProduct.fromJson(e))
          .toList(),
      meta: WishlistMeta.fromJson(json['meta'] ?? {}),
    );
  }
}
class WishlistProduct {
  final String wishlistId;
  final String customerProfileId;
  final String? productId;
  final String? productVariationId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Product? product;

  WishlistProduct({
    required this.wishlistId,
    required this.customerProfileId,
    this.productId,
    this.productVariationId,
    required this.createdAt,
    required this.updatedAt,
    this.product,
  });

  factory WishlistProduct.fromJson(Map<String, dynamic> json) {
    return WishlistProduct(
      wishlistId: json['id'] ?? '',
      customerProfileId: json['customerProfileId'] ?? '',
      productId: json['productId'],
      productVariationId: json['productVariationId'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      product:
          json['product'] != null ? Product.fromJson(json['product']) : null,
    );
  }


  bool get isProductWishlist => productId != null;
  bool get isVariationWishlist => productVariationId != null;
}

class Product {
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

  Product({
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
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      subCategoryId: json['subCategoryId'] ?? '',
      discountedPrice: json['discountedPrice']?.toString() ?? '0',
      actualPrice: json['actualPrice']?.toString() ?? '0',
      description: json['description'] ?? '',
      stockCount: json['stockCount'] ?? 0,
      isStock: json['isStock'] ?? false,
      isFeatured: json['isFeatured'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      images: (json['images'] as List<dynamic>? ?? [])
          .map((e) => ProductImage.fromJson(e))
          .toList(),
    );
  }


  bool get hasImages => images.isNotEmpty;
  ProductImage? get mainImage =>
      images.isNotEmpty ? images.firstWhere(
        (e) => e.isMain,
        orElse: () => images.first,
      ) : null;
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

class WishlistMeta {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;

  WishlistMeta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrev,
  });

  factory WishlistMeta.fromJson(Map<String, dynamic> json) {
    return WishlistMeta(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      hasNext: json['hasNext'] ?? false,
      hasPrev: json['hasPrev'] ?? false,
    );
  }
}
