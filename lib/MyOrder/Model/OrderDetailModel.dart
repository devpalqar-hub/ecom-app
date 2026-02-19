class OrderDetailModel {
  final String id;
  final String orderNumber;
  final String status;
  final String paymentStatus;
  final String paymentMethod;
  final String totalAmount;
  final String shippingCost;
  final String taxAmount;
  final String discountAmount;
  final String notes;
  final String razorpayId;
  final String customerProfileId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ShippingAddress? shippingAddress;
  final Tracking? tracking;
  final List<OrderItem> items;

  OrderDetailModel({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.totalAmount,
    required this.shippingCost,
    required this.taxAmount,
    required this.discountAmount,
    required this.notes,
    required this.razorpayId,
    required this.customerProfileId,
    required this.createdAt,
    required this.updatedAt,
    required this.shippingAddress,
    required this.tracking,
    required this.items,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};

    return OrderDetailModel(
      id: json['id']?.toString() ?? '',
      orderNumber: json['orderNumber']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      paymentStatus: json['paymentStatus']?.toString() ?? '',
      paymentMethod: json['paymentMethod']?.toString() ?? '',
      totalAmount: json['totalAmount']?.toString() ?? '0',
      shippingCost: json['shippingCost']?.toString() ?? '0',
      taxAmount: json['taxAmount']?.toString() ?? '0',
      discountAmount: json['discountAmount']?.toString() ?? '0',
      notes: json['notes']?.toString() ?? '',
      razorpayId: json['razorpay_id']?.toString() ?? '',
      customerProfileId: json['customerProfileId']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      shippingAddress: json['shippingAddress'] != null
          ? ShippingAddress.fromJson(json['shippingAddress'])
          : null,
      tracking: json['tracking'] != null
          ? Tracking.fromJson(json['tracking'])
          : null,
      items: (json['items'] as List? ?? [])
          .map((e) => OrderItem.fromJson(e))
          .toList(),
    );
  }
}

class OrderItem {
  final String id;
  final int quantity;
  final Review? review;
  final bool isReturn;
  final Product product;

  OrderItem({
    required this.id,
    required this.quantity,
    this.review,
    required this.isReturn,
    required this.product,
  });

  factory OrderItem.fromJson(Map<String, dynamic>? json) {
    json ??= {};

    return OrderItem(
      id: json['id']?.toString() ?? '',
      quantity: json['quantity'] ?? 0,
      isReturn: json["isReturned"] ?? false,
      review: json['Review'] != null ? Review.fromJson(json['Review']) : null,
      product: Product.fromJson(json['product']),
    );
  }
}

class Review {
  final String id;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final String productId;
  final String customerProfileId;
  final String orderItemId;

  Review({
    required this.id,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.productId,
    required this.customerProfileId,
    required this.orderItemId,
  });

  factory Review.fromJson(Map<String, dynamic>? json) {
    json ??= {};

    return Review(
      id: json['id']?.toString() ?? '',
      rating: json['rating'] ?? 0,
      comment: json['comment']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      productId: json['productId']?.toString() ?? '',
      customerProfileId: json['customerProfileId']?.toString() ?? '',
      orderItemId: json['orderItemId']?.toString() ?? '',
    );
  }
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
  final List<Review> reviews;

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
    required this.reviews,
  });

  factory Product.fromJson(Map<String, dynamic>? json) {
    json ??= {};

    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      subCategoryId: json['subCategoryId']?.toString() ?? '',
      discountedPrice: json['discountedPrice']?.toString() ?? '0',
      actualPrice: json['actualPrice']?.toString() ?? '0',
      description: json['description']?.toString() ?? '',
      stockCount: json['stockCount'] ?? 0,
      isStock: json['isStock'] ?? false,
      isFeatured: json['isFeatured'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      images: (json['images'] as List? ?? [])
          .map((e) => ProductImage.fromJson(e))
          .toList(),
      reviews: (json['reviews'] as List? ?? [])
          .map((e) => Review.fromJson(e))
          .toList(),
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

  factory ProductImage.fromJson(Map<String, dynamic>? json) {
    json ??= {};

    return ProductImage(
      id: json['id']?.toString() ?? '',
      productId: json['productId']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      altText: json['altText']?.toString() ?? '',
      isMain: json['isMain'] ?? false,
      sortOrder: json['sortOrder'] ?? 0,
    );
  }
}

class ShippingAddress {
  final String id;
  final String customerProfileId;
  final String name;
  final String address;
  final String city;
  final String state;
  final String postalCode;
  final String landmark;
  final String country;
  final String phone;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  ShippingAddress({
    required this.id,
    required this.customerProfileId,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.landmark,
    required this.country,
    required this.phone,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic>? json) {
    json ??= {};

    return ShippingAddress(
      id: json['id']?.toString() ?? '',
      customerProfileId: json['customerProfileId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      postalCode: json['postalCode']?.toString() ?? '',
      landmark: json['landmark']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      isDefault: json['isDefault'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}

class Tracking {
  final String id;
  final String orderId;
  final String carrier;
  final String trackingNumber;
  final String trackingUrl;
  final String status;
  final List<TrackingHistory> statusHistory;
  final DateTime lastUpdatedAt;

  Tracking({
    required this.id,
    required this.orderId,
    required this.carrier,
    required this.trackingNumber,
    required this.trackingUrl,
    required this.status,
    required this.statusHistory,
    required this.lastUpdatedAt,
  });

  factory Tracking.fromJson(Map<String, dynamic>? json) {
    json ??= {};

    return Tracking(
      id: json['id']?.toString() ?? '',
      orderId: json['orderId']?.toString() ?? '',
      carrier: json['carrier']?.toString() ?? '',
      trackingNumber: json['trackingNumber']?.toString() ?? '',
      trackingUrl: json['trackingUrl']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      statusHistory: (json['statusHistory'] as List? ?? [])
          .map((e) => TrackingHistory.fromJson(e))
          .toList(),
      lastUpdatedAt:
          DateTime.tryParse(json['lastUpdatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}

class TrackingHistory {
  final String status;
  final String notes;
  final DateTime timestamp;

  TrackingHistory({
    required this.status,
    required this.notes,
    required this.timestamp,
  });

  factory TrackingHistory.fromJson(Map<String, dynamic>? json) {
    json ??= {};

    return TrackingHistory(
      status: json['status']?.toString() ?? '',
      notes: json['notes']?.toString() ?? '',
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
    );
  }
}
