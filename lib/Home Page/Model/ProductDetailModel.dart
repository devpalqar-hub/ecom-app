// ================= SAFE PARSING HELPERS =================
double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  return double.tryParse(value.toString()) ?? 0.0;
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  return int.tryParse(value.toString()) ?? 0;
}

// ================= PRODUCT DETAIL MODEL =================
class ProductDetailModel {
  final String id;
  final String name;
  final String subCategoryId;
  final double discountedPrice;
  final double actualPrice;
  final String description;
  final int stockCount;
  final bool isStock;
  final bool isFeatured;
  final DateTime createdAt;
  final DateTime updatedAt;

  final List<ProductImage> images;
  final SubCategory subCategory;
  final List<Variation> variations;

  /// Reviews
  final List<ProductReview> reviews;
  final ReviewStats reviewStats;

  final bool isWishlisted;
  final bool isInCart;

  ProductDetailModel({
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
    required this.reviews,
    required this.reviewStats,
    required this.isWishlisted,
    required this.isInCart,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      id: json['id'],
      name: json['name'] ?? "",
      subCategoryId: json['subCategoryId'] ?? "",
      discountedPrice: _toDouble(json['discountedPrice']),
      actualPrice: _toDouble(json['actualPrice']),
      description: json['description'] ?? "",
      stockCount: json['stockCount'] ?? 0,
      isStock: json['isStock'] ?? false,
      isFeatured: json['isFeatured'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      images: (json['images'] as List<dynamic>? ?? [])
          .map((e) => ProductImage.fromJson(e))
          .toList(),
      subCategory: SubCategory.fromJson(json['subCategory']),
      variations: (json['variations'] as List<dynamic>? ?? [])
          .map((e) => Variation.fromJson(e))
          .toList(),
      reviews: (json['reviews'] as List<dynamic>? ?? [])
          .map((e) => ProductReview.fromJson(e))
          .toList(),
      reviewStats: json['reviewStats'] != null
          ? ReviewStats.fromJson(json['reviewStats'])
          : ReviewStats.empty(),
      isWishlisted: json['is_wishlisted'] ?? false,
      isInCart: json['is_in_cart'] ?? false,
    );
  }
}

// ================= PRODUCT IMAGE =================
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
      id: json['id'],
      productId: json['productId'],
      url: json['url'] ?? "",
      altText: json['altText'] ?? "",
      isMain: json['isMain'] ?? false,
      sortOrder: json['sortOrder'] ?? 0,
    );
  }
}

// ================= SUB CATEGORY =================
class SubCategory {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String categoryId;
  final String? image;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Category category;

  SubCategory({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.categoryId,
    this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'],
      name: json['name'] ?? "",
      slug: json['slug'] ?? "",
      description: json['description'] ?? "",
      categoryId: json['categoryId'] ?? "",
      image: json['image'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      category: Category.fromJson(json['category']),
    );
  }
}

// ================= CATEGORY =================
class Category {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String? image;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'] ?? "",
      slug: json['slug'] ?? "",
      description: json['description'] ?? "",
      image: json['image'],
    );
  }
}

// ================= VARIATION =================
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
      id: json['id'],
      productId: json['productId'],
      variationName: json['variationName'] ?? "",
      sku: json['sku'] ?? "",
      price: _toDouble(json['price']),
      stockCount: json['stockCount'] ?? 0,
      isAvailable: json['isAvailable'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class ProductReview {
  final String id;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final String productId;
  final String orderItemId;
  final CustomerProfile customerProfile;

  ProductReview({
    required this.id,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.productId,
    required this.orderItemId,
    required this.customerProfile,
  });

  factory ProductReview.fromJson(Map<String, dynamic> json) {
    return ProductReview(
      id: json['id'],
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? "",
      createdAt: DateTime.parse(json['createdAt']),
      productId: json['productId'] ?? "",
      orderItemId: json['orderItemId'] ?? "",
      customerProfile:
          CustomerProfile.fromJson(json['customerProfile'] ?? {}),
    );
  }
}


class CustomerProfile {
  final String? name;
  final String? profilePicture;

  CustomerProfile({this.name, this.profilePicture});

  factory CustomerProfile.fromJson(Map<String, dynamic> json) {
    return CustomerProfile(
      name: json['name'],
      profilePicture: json['profilePicture'],
    );
  }
}

// ================= REVIEW STATS =================
class ReviewStats {
  final int totalReviews;
  final double averageRating;
  final Map<int, int> ratingDistribution;

  ReviewStats({
    required this.totalReviews,
    required this.averageRating,
    required this.ratingDistribution,
  });

  factory ReviewStats.fromJson(Map<String, dynamic> json) {
    return ReviewStats(
      totalReviews: json['totalReviews'] ?? 0,
      averageRating:
          double.tryParse(json['averageRating']?.toString() ?? '0') ?? 0.0,
      ratingDistribution:
          (json['ratingDistribution'] as Map<String, dynamic>? ?? {})
              .map((k, v) => MapEntry(int.parse(k), v)),
    );
  }

  factory ReviewStats.empty() {
    return ReviewStats(
      totalReviews: 0,
      averageRating: 0.0,
      ratingDistribution: {},
    );
  }
}
