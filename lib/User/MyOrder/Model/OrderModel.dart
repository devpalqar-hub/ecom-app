
class OrderModel {
  final String id;
  final String orderNumber;
  final String status;
  final String paymentStatus;
  final String paymentMethod;
  final String totalAmount;
  final String shippingCost;
  final String taxAmount;
  final String discountAmount;
  final String? notes;
  final String? razorpayId;
  final String customerProfileId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ShippingAddress shippingAddress;
  final Tracking tracking;
  final List<OrderItem> items;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.totalAmount,
    required this.shippingCost,
    required this.taxAmount,
    required this.discountAmount,
    this.notes,
    this.razorpayId,
    required this.customerProfileId,
    required this.createdAt,
    required this.updatedAt,
    required this.shippingAddress,
    required this.tracking,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      orderNumber: json['orderNumber'] ?? '',
      status: json['status'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      paymentMethod: json['paymentMethod'] ?? '',
      totalAmount: json['totalAmount'] ?? '0',
      shippingCost: json['shippingCost'] ?? '0',
      taxAmount: json['taxAmount'] ?? '0',
      discountAmount: json['discountAmount'] ?? '0',
      notes: json['notes'],
      razorpayId: json['razorpay_id'],
      customerProfileId: json['customerProfileId'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      shippingAddress:
          ShippingAddress.fromJson(json['shippingAddress'] ?? {}),
      tracking: Tracking.fromJson(json['tracking'] ?? {}),
      items: (json['items'] as List?)
              ?.map((e) => OrderItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}


class OrderItem {
  final String id;
  final int quantity;
  final Product product;

  OrderItem({
    required this.id,
    required this.quantity,
    required this.product,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? '',
      quantity: json['quantity'] ?? 0,
      product: Product.fromJson(json['product'] ?? {}),
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
      discountedPrice: json['discountedPrice'] ?? '0',
      actualPrice: json['actualPrice'] ?? '0',
      description: json['description'] ?? '',
      stockCount: json['stockCount'] ?? 0,
      isStock: json['isStock'] ?? false,
      isFeatured: json['isFeatured'] ?? false,
      createdAt: DateTime.parse(
          json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          json['updatedAt'] ?? DateTime.now().toIso8601String()),
      images: (json['images'] as List?)
              ?.map((e) => ProductImage.fromJson(e))
              .toList() ??
          [],
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

class ShippingAddress {
  final String id;
  final String customerProfileId;
  final String name;
  final String address;
  final String city;
  final String state;
  final String postalCode;
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
    required this.country,
    required this.phone,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      id: json['id'] ?? '',
      customerProfileId: json['customerProfileId'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      postalCode: json['postalCode'] ?? '',
      country: json['country'] ?? '',
      phone: json['phone'] ?? '',
      isDefault: json['isDefault'] ?? false,
      createdAt: DateTime.parse(
          json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class Tracking {
  final String id;
  final String orderId;
  final String carrier;
  final String trackingNumber;
  final String? trackingUrl;
  final String status;
  final List<TrackingStatusHistory> statusHistory;
  final DateTime lastUpdatedAt;

  Tracking({
    required this.id,
    required this.orderId,
    required this.carrier,
    required this.trackingNumber,
    this.trackingUrl,
    required this.status,
    required this.statusHistory,
    required this.lastUpdatedAt,
  });

  factory Tracking.fromJson(Map<String, dynamic> json) {
    return Tracking(
      id: json['id'] ?? '',
      orderId: json['orderId'] ?? '',
      carrier: json['carrier'] ?? '',
      trackingNumber: json['trackingNumber'] ?? '',
      trackingUrl: json['trackingUrl'],
      status: json['status'] ?? '',
      statusHistory: (json['statusHistory'] as List?)
              ?.map((e) => TrackingStatusHistory.fromJson(e))
              .toList() ??
          [],
      lastUpdatedAt: DateTime.parse(
          json['lastUpdatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}


class TrackingStatusHistory {
  final String notes;
  final String status;
  final DateTime timestamp;

  TrackingStatusHistory({
    required this.notes,
    required this.status,
    required this.timestamp,
  });

  factory TrackingStatusHistory.fromJson(Map<String, dynamic> json) {
    return TrackingStatusHistory(
      notes: json['notes'] ?? '',
      status: json['status'] ?? '',
      timestamp: DateTime.parse(
          json['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }
}
