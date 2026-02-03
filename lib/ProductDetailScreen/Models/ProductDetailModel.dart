import '../../Home Page/Model/FeaturedProductCategoryModel.dart';

class ProductDetailModel {
  String? id;
  String? name;
  String? subCategoryId;
  String? discountedPrice;
  String? actualPrice;
  String? description;
  int? stockCount;
  bool? isStock;
  bool? isFeatured;
  bool? isActive;
  String? variationTitle;
  String? createdAt;
  String? updatedAt;
  List<Images>? images;
  SubCategory? subCategory;
  List<Variations>? variations;
  List<Reviews>? reviews;
  bool? isWishlisted;
  bool? isInCart;
  ReviewStats? reviewStats;

  ProductDetailModel({
    this.id,
    this.name,
    this.subCategoryId,
    this.discountedPrice,
    this.actualPrice,
    this.description,
    this.stockCount,
    this.isStock,
    this.isFeatured,
    this.isActive,
    this.variationTitle,
    this.createdAt,
    this.updatedAt,
    this.images,
    this.subCategory,
    this.variations,
    this.reviews,
    this.isWishlisted,
    this.isInCart,
    this.reviewStats,
  });

  ProductDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    subCategoryId = json['subCategoryId'];
    discountedPrice = json['discountedPrice'];
    actualPrice = json['actualPrice'];
    description = json['description'];
    stockCount = json['stockCount'];
    isStock = json['isStock'];
    isFeatured = json['isFeatured'];
    isActive = json['isActive'];
    variationTitle = json['variationTitle'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
    subCategory = json['subCategory'] != null
        ? new SubCategory.fromJson(json['subCategory'])
        : null;
    if (json['variations'] != null) {
      variations = <Variations>[];
      json['variations'].forEach((v) {
        variations!.add(new Variations.fromJson(v));
      });
    }
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(new Reviews.fromJson(v));
      });
    }
    isWishlisted = json['is_wishlisted'];
    isInCart = json['is_in_cart'];
    reviewStats = json['reviewStats'] != null
        ? new ReviewStats.fromJson(json['reviewStats'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['subCategoryId'] = this.subCategoryId;
    data['discountedPrice'] = this.discountedPrice;
    data['actualPrice'] = this.actualPrice;
    data['description'] = this.description;
    data['stockCount'] = this.stockCount;
    data['isStock'] = this.isStock;
    data['isFeatured'] = this.isFeatured;
    data['isActive'] = this.isActive;
    data['variationTitle'] = this.variationTitle;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }

    if (this.variations != null) {
      data['variations'] = this.variations!.map((v) => v.toJson()).toList();
    }
    if (this.reviews != null) {
      data['reviews'] = this.reviews!.map((v) => v.toJson()).toList();
    }
    data['is_wishlisted'] = this.isWishlisted;
    data['is_in_cart'] = this.isInCart;
    if (this.reviewStats != null) {
      data['reviewStats'] = this.reviewStats!.toJson();
    }
    return data;
  }
}

class Images {
  String? id;
  String? productId;
  String? url;
  String? altText;
  bool? isMain;
  int? sortOrder;

  Images({
    this.id,
    this.productId,
    this.url,
    this.altText,
    this.isMain,
    this.sortOrder,
  });

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['productId'];
    url = json['url'];
    altText = json['altText'];
    isMain = json['isMain'];
    sortOrder = json['sortOrder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productId'] = this.productId;
    data['url'] = this.url;
    data['altText'] = this.altText;
    data['isMain'] = this.isMain;
    data['sortOrder'] = this.sortOrder;
    return data;
  }
}

class Variations {
  String? id;
  String? productId;
  String? variationName;
  String? sku;
  String? discountedPrice;
  String? actualPrice;
  int? stockCount;
  bool? isAvailable;
  String? createdAt;
  String? updatedAt;

  Variations({
    this.id,
    this.productId,
    this.variationName,
    this.sku,
    this.discountedPrice,
    this.actualPrice,
    this.stockCount,
    this.isAvailable,
    this.createdAt,
    this.updatedAt,
  });

  Variations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['productId'];
    variationName = json['variationName'];
    sku = json['sku'];
    discountedPrice = json['discountedPrice'];
    actualPrice = json['actualPrice'];
    stockCount = json['stockCount'];
    isAvailable = json['isAvailable'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productId'] = this.productId;
    data['variationName'] = this.variationName;
    data['sku'] = this.sku;
    data['discountedPrice'] = this.discountedPrice;
    data['actualPrice'] = this.actualPrice;
    data['stockCount'] = this.stockCount;
    data['isAvailable'] = this.isAvailable;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Reviews {
  String? id;
  int? rating;
  String? comment;
  String? createdAt;
  String? productId;
  String? customerProfileId;
  String? orderItemId;
  List<Null>? images;
  CustomerProfile? customerProfile;

  Reviews({
    this.id,
    this.rating,
    this.comment,
    this.createdAt,
    this.productId,
    this.customerProfileId,
    this.orderItemId,
    this.images,
    this.customerProfile,
  });

  Reviews.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rating = json['rating'];
    comment = json['comment'];
    createdAt = json['createdAt'];
    productId = json['productId'];
    customerProfileId = json['customerProfileId'];
    orderItemId = json['orderItemId'];

    customerProfile = json['customerProfile'] != null
        ? new CustomerProfile.fromJson(json['customerProfile'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rating'] = this.rating;
    data['comment'] = this.comment;
    data['createdAt'] = this.createdAt;
    data['productId'] = this.productId;
    data['customerProfileId'] = this.customerProfileId;
    data['orderItemId'] = this.orderItemId;

    if (this.customerProfile != null) {
      data['customerProfile'] = this.customerProfile!.toJson();
    }
    return data;
  }
}

class CustomerProfile {
  String? name;
  String? profilePicture;

  CustomerProfile({this.name, this.profilePicture});

  CustomerProfile.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    profilePicture = json['profilePicture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['profilePicture'] = this.profilePicture;
    return data;
  }
}

class ReviewStats {
  int? totalReviews;
  int? averageRating;
  RatingDistribution? ratingDistribution;

  ReviewStats({this.totalReviews, this.averageRating, this.ratingDistribution});

  ReviewStats.fromJson(Map<String, dynamic> json) {
    totalReviews = json['totalReviews'];
    averageRating = json['averageRating'];
    ratingDistribution = json['ratingDistribution'] != null
        ? new RatingDistribution.fromJson(json['ratingDistribution'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalReviews'] = this.totalReviews;
    data['averageRating'] = this.averageRating;
    if (this.ratingDistribution != null) {
      data['ratingDistribution'] = this.ratingDistribution!.toJson();
    }
    return data;
  }
}

class RatingDistribution {
  int? i1;
  int? i2;
  int? i3;
  int? i4;
  int? i5;

  RatingDistribution({this.i1, this.i2, this.i3, this.i4, this.i5});

  RatingDistribution.fromJson(Map<String, dynamic> json) {
    i1 = json['1'];
    i2 = json['2'];
    i3 = json['3'];
    i4 = json['4'];
    i5 = json['5'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1'] = this.i1;
    data['2'] = this.i2;
    data['3'] = this.i3;
    data['4'] = this.i4;
    data['5'] = this.i5;
    return data;
  }
}
