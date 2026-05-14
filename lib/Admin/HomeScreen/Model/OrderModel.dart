class OrderModel {
  final String id;
  final String orderNumber;
  String status;
  final String paymentStatus;
  final String paymentMethod;
  final String totalAmount;
  final String shippingCost;
  final String taxAmount;
  final String discountAmount;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CustomerProfile customerProfile;
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
    required this.createdAt,
    required this.updatedAt,
    required this.customerProfile,
    required this.shippingAddress,
    required this.tracking,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json["id"] ?? "",
      orderNumber: json["orderNumber"] ?? "",
      status: json["status"] ?? "",
      paymentStatus: json["paymentStatus"] ?? "",
      paymentMethod: json["paymentMethod"] ?? "",
      totalAmount: json["totalAmount"]?.toString() ?? "0",
      shippingCost: json["shippingCost"]?.toString() ?? "0",
      taxAmount: json["taxAmount"]?.toString() ?? "0",
      discountAmount: json["discountAmount"]?.toString() ?? "0",
      notes: json["notes"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? "") ??
          DateTime.now(),
      customerProfile: CustomerProfile.fromJson(
        json["CustomerProfile"] ?? {},
      ),
      shippingAddress: ShippingAddress.fromJson(
        json["shippingAddress"] ?? {},
      ),
      tracking: Tracking.fromJson(json["tracking"] ?? {}),
      items: (json["items"] as List<dynamic>? ?? [])
          .map((e) => OrderItem.fromJson(e))
          .toList(),
    );
  }

  OrderModel copyWith({
    Tracking? tracking,
    String? status,
  }) {
    return OrderModel(
      id: id,
      orderNumber: orderNumber,
      status: status ?? this.status,
      paymentStatus: paymentStatus,
      paymentMethod: paymentMethod,
      totalAmount: totalAmount,
      shippingCost: shippingCost,
      taxAmount: taxAmount,
      discountAmount: discountAmount,
      notes: notes,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      customerProfile: customerProfile,
      shippingAddress: shippingAddress,
      tracking: tracking ?? this.tracking,
      items: items,
    );
  }
}

class CustomerProfile {
  final String id;
  final String name;
  final String phone;
  final String email;

  CustomerProfile({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
  });

  factory CustomerProfile.fromJson(Map<String, dynamic> json) {
    return CustomerProfile(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      phone: json["phone"] ?? "",
      email: json["user"]?["email"] ?? "",
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
  final String? landmark;
  final String country;
  final String? phone;
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
    this.landmark,
    required this.country,
    this.phone,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      id: json["id"] ?? "",
      customerProfileId: json["customerProfileId"] ?? "",
      name: json["name"] ?? "",
      address: json["address"] ?? "",
      city: json["city"] ?? "",
      state: json["state"] ?? "",
      postalCode: json["postalCode"] ?? "",
      landmark: json["landmark"],
      country: json["country"] ?? "",
      phone: json["phone"],
      isDefault: json["isDefault"] ?? false,
      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? "") ??
          DateTime.now(),
    );
  }
}

class Tracking {
  final String id;
  final String orderId;
  final String carrier;
  final String trackingNumber;
  final String? trackingUrl;
  String status;
  final List<TrackingHistory> statusHistory;
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
      id: json["id"] ?? "",
      orderId: json["orderId"] ?? "",
      carrier: json["carrier"] ?? "",
      trackingNumber: json["trackingNumber"] ?? "",
      trackingUrl: json["trackingUrl"],
      status: json["status"] ?? "",
      statusHistory:
          (json["statusHistory"] as List<dynamic>? ?? [])
              .map((e) => TrackingHistory.fromJson(e))
              .toList(),
      lastUpdatedAt:
          DateTime.tryParse(json["lastUpdatedAt"] ?? "") ??
              DateTime.now(),
    );
  }

  Tracking copyWith({
    String? status,
    DateTime? lastUpdatedAt,
  }) {
    return Tracking(
      id: id,
      orderId: orderId,
      carrier: carrier,
      trackingNumber: trackingNumber,
      trackingUrl: trackingUrl,
      status: status ?? this.status,
      statusHistory: statusHistory,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
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

  factory TrackingHistory.fromJson(Map<String, dynamic> json) {
    return TrackingHistory(
      status: json["status"] ?? "",
      notes: json["notes"] ?? "",
      timestamp:
          DateTime.tryParse(json["timestamp"] ?? "") ??
              DateTime.now(),
    );
  }
}

class OrderItem {
  final String id;
  final int quantity;
  final bool isReturned;
  final dynamic returnStatus;
  final Product product;
  final ProductVariation? productVariation;

  OrderItem({
    required this.id,
    required this.quantity,
    required this.isReturned,
    this.returnStatus,
    required this.product,
    this.productVariation,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json["id"] ?? "",
      quantity: json["quantity"] ?? 0,
      isReturned: json["isReturned"] ?? false,
      returnStatus: json["returnStatus"],
      product: Product.fromJson(json["product"] ?? {}),
      productVariation: json["productVariation"] != null
          ? ProductVariation.fromJson(json["productVariation"])
          : null,
    );
  }
}

class Product {
  final String id;
  final String name;
  final List<ProductImage> images;

  Product({
    required this.id,
    required this.name,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      images: (json["images"] as List<dynamic>? ?? [])
          .map((e) => ProductImage.fromJson(e))
          .toList(),
    );
  }
}

class ProductImage {
  final String id;
  final String url;
  final String altText;
  final bool isMain;

  ProductImage({
    required this.id,
    required this.url,
    required this.altText,
    required this.isMain,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json["id"] ?? "",
      url: json["url"] ?? "",
      altText: json["altText"] ?? "",
      isMain: json["isMain"] ?? false,
    );
  }
}

class ProductVariation {
  final String id;
  final String productId;
  final String variationName;
  final String variationType;
  final VariationAttributes attributes;
  final String sku;
  final String discountedPrice;
  final String actualPrice;
  final int stockCount;
  final bool isAvailable;

  ProductVariation({
    required this.id,
    required this.productId,
    required this.variationName,
    required this.variationType,
    required this.attributes,
    required this.sku,
    required this.discountedPrice,
    required this.actualPrice,
    required this.stockCount,
    required this.isAvailable,
  });

  factory ProductVariation.fromJson(Map<String, dynamic> json) {
    return ProductVariation(
      id: json["id"] ?? "",
      productId: json["productId"] ?? "",
      variationName: json["variationName"] ?? "",
      variationType: json["variationType"] ?? "",
      attributes: VariationAttributes.fromJson(
        json["attributes"] ?? {},
      ),
      sku: json["sku"] ?? "",
      discountedPrice:
          json["discountedPrice"]?.toString() ?? "0",
      actualPrice: json["actualPrice"]?.toString() ?? "0",
      stockCount: json["stockCount"] ?? 0,
      isAvailable: json["isAvailable"] ?? false,
    );
  }
}

class VariationAttributes {
  final String size;
  final VariationColor? color;

  VariationAttributes({
    required this.size,
    this.color,
  });

  factory VariationAttributes.fromJson(Map<String, dynamic> json) {
    return VariationAttributes(
      size: json["size"] ?? "",
      color: json["color"] != null
          ? VariationColor.fromJson(json["color"])
          : null,
    );
  }
}

class VariationColor {
  final String name;
  final String hex;

  VariationColor({
    required this.name,
    required this.hex,
  });

  factory VariationColor.fromJson(Map<String, dynamic> json) {
    return VariationColor(
      name: json["name"] ?? "",
      hex: json["hex"] ?? "",
    );
  }
}