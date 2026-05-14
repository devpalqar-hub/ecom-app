// =====================================================
// RETURN ORDER MODEL
// =====================================================

class ReturnOrder {
  final String id;
  final String orderId;
  final String customerProfileId;
  final String? deliveryPartnerId;

  final String status;
  final String returnType;
  final String reason;

  final String refundAmount;
  final String returnFee;
  final String refundMethod;

  final String? returnPaymentMethod;
  final String? adminNotes;

  final DateTime createdAt;
  final DateTime updatedAt;

  final Order order;
  final CustomerProfile customerProfile;
  final List<ReturnItem> returnItems;

  ReturnOrder({
    required this.id,
    required this.orderId,
    required this.customerProfileId,
    this.deliveryPartnerId,
    required this.status,
    required this.returnType,
    required this.reason,
    required this.refundAmount,
    required this.returnFee,
    required this.refundMethod,
    this.returnPaymentMethod,
    this.adminNotes,
    required this.createdAt,
    required this.updatedAt,
    required this.order,
    required this.customerProfile,
    required this.returnItems,
  });

  factory ReturnOrder.fromJson(Map<String, dynamic> json) {
    return ReturnOrder(
      id: json["id"] ?? "",
      orderId: json["orderId"] ?? "",
      customerProfileId: json["customerProfileId"] ?? "",
      deliveryPartnerId: json["deliveryPartnerId"],

      status: json["status"] ?? "",
      returnType: json["returnType"] ?? "",
      reason: json["reason"] ?? "",

      refundAmount: json["refundAmount"]?.toString() ?? "0",
      returnFee: json["returnFee"]?.toString() ?? "0",
      refundMethod: json["refundMethod"] ?? "",

      returnPaymentMethod: json["returnPaymentMethod"],
      adminNotes: json["adminNotes"],

      createdAt:
          DateTime.tryParse(json["createdAt"] ?? "") ??
          DateTime.now(),

      updatedAt:
          DateTime.tryParse(json["updatedAt"] ?? "") ??
          DateTime.now(),

      order: Order.fromJson(json["order"] ?? {}),

      customerProfile:
          CustomerProfile.fromJson(
            json["customerProfile"] ?? {},
          ),

      returnItems:
          (json["returnItems"] as List?)
              ?.map((e) => ReturnItem.fromJson(e))
              .toList() ??
          [],
    );
  }

  // =====================================================
  // COPY WITH
  // =====================================================

  ReturnOrder copyWith({
    String? status,
    String? returnPaymentMethod,
    String? adminNotes,
  }) {
    return ReturnOrder(
      id: id,
      orderId: orderId,
      customerProfileId: customerProfileId,
      deliveryPartnerId: deliveryPartnerId,

      status: status ?? this.status,
      returnType: returnType,
      reason: reason,

      refundAmount: refundAmount,
      returnFee: returnFee,
      refundMethod: refundMethod,

      returnPaymentMethod:
          returnPaymentMethod ??
          this.returnPaymentMethod,

      adminNotes: adminNotes ?? this.adminNotes,

      createdAt: createdAt,
      updatedAt: updatedAt,

      order: order,
      customerProfile: customerProfile,
      returnItems: returnItems,
    );
  }
}

// =====================================================
// ORDER
// =====================================================

class Order {
  final String orderNumber;
  final String totalAmount;
  final ShippingAddress? shippingAddress;

  Order({
    required this.orderNumber,
    required this.totalAmount,
    this.shippingAddress,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderNumber: json["orderNumber"] ?? "",
      totalAmount:
          json["totalAmount"]?.toString() ?? "0",

      shippingAddress:
          json["shippingAddress"] != null
          ? ShippingAddress.fromJson(
              json["shippingAddress"],
            )
          : null,
    );
  }
}

// =====================================================
// SHIPPING ADDRESS
// =====================================================

class ShippingAddress {
  final String id;
  final String name;
  final String address;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final String? phone;

  ShippingAddress({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.phone,
  });

  factory ShippingAddress.fromJson(
    Map<String, dynamic> json,
  ) {
    return ShippingAddress(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      address: json["address"] ?? "",
      city: json["city"] ?? "",
      state: json["state"] ?? "",
      postalCode: json["postalCode"] ?? "",
      country: json["country"] ?? "",
      phone: json["phone"],
    );
  }
}

// =====================================================
// CUSTOMER PROFILE
// =====================================================

class CustomerProfile {
  final String name;
  final String phone;

  CustomerProfile({
    required this.name,
    required this.phone,
  });

  factory CustomerProfile.fromJson(
    Map<String, dynamic> json,
  ) {
    return CustomerProfile(
      name: json["name"] ?? "",
      phone: json["phone"] ?? "",
    );
  }
}

// =====================================================
// RETURN ITEM
// =====================================================

class ReturnItem {
  final String id;
  final String returnId;
  final String orderItemId;

  final int quantity;
  final String reason;

  final OrderItem orderItem;

  ReturnItem({
    required this.id,
    required this.returnId,
    required this.orderItemId,
    required this.quantity,
    required this.reason,
    required this.orderItem,
  });

  factory ReturnItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return ReturnItem(
      id: json["id"] ?? "",
      returnId: json["returnId"] ?? "",
      orderItemId: json["orderItemId"] ?? "",

      quantity: json["quantity"] ?? 0,
      reason: json["reason"] ?? "",

      orderItem:
          OrderItem.fromJson(json["orderItem"] ?? {}),
    );
  }
}

// =====================================================
// ORDER ITEM
// =====================================================

class OrderItem {
  final String id;
  final String orderId;
  final String productId;

  final String? productVariationId;

  final int quantity;

  final bool isReturned;

  final String returnStatus;

  final String discountedPrice;
  final String actualPrice;

  final Product product;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    this.productVariationId,
    required this.quantity,
    required this.isReturned,
    required this.returnStatus,
    required this.discountedPrice,
    required this.actualPrice,
    required this.product,
  });

  factory OrderItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return OrderItem(
      id: json["id"] ?? "",
      orderId: json["orderId"] ?? "",
      productId: json["productId"] ?? "",

      productVariationId:
          json["productVariationId"],

      quantity: json["quantity"] ?? 0,

      isReturned: json["isReturned"] ?? false,

      returnStatus: json["returnStatus"] ?? "",

      discountedPrice:
          json["discountedPrice"]?.toString() ??
          "0",

      actualPrice:
          json["actualPrice"]?.toString() ?? "0",

      product:
          Product.fromJson(json["product"] ?? {}),
    );
  }
}

// =====================================================
// PRODUCT
// =====================================================

class Product {
  final String name;

  final List<ProductImage> images;

  final List<ProductVariation> variations;

  Product({
    required this.name,
    required this.images,
    required this.variations,
  });

  factory Product.fromJson(
    Map<String, dynamic> json,
  ) {
    return Product(
      name: json["name"] ?? "",

      images:
          (json["images"] as List?)
              ?.map(
                (e) => ProductImage.fromJson(e),
              )
              .toList() ??
          [],

      variations:
          (json["variations"] as List?)
              ?.map(
                (e) => ProductVariation.fromJson(e),
              )
              .toList() ??
          [],
    );
  }
}

// =====================================================
// PRODUCT IMAGE
// =====================================================

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

  factory ProductImage.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProductImage(
      id: json["id"] ?? "",
      productId: json["productId"] ?? "",

      url: json["url"] ?? "",
      altText: json["altText"] ?? "",

      isMain: json["isMain"] ?? false,

      sortOrder: json["sortOrder"] ?? 0,
    );
  }
}

// =====================================================
// PRODUCT VARIATION
// =====================================================

class ProductVariation {
  final String id;

  final String variationName;
  final String variationType;

  final String sku;

  final VariationAttributes attributes;

  ProductVariation({
    required this.id,
    required this.variationName,
    required this.variationType,
    required this.sku,
    required this.attributes,
  });

  factory ProductVariation.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProductVariation(
      id: json["id"] ?? "",

      variationName:
          json["variationName"] ?? "",

      variationType:
          json["variationType"] ?? "",

      sku: json["sku"] ?? "",

      attributes:
          VariationAttributes.fromJson(
            json["attributes"] ?? {},
          ),
    );
  }
}

// =====================================================
// VARIATION ATTRIBUTES
// =====================================================

class VariationAttributes {
  final String? size;

  final VariationColor? color;

  VariationAttributes({
    this.size,
    this.color,
  });

  factory VariationAttributes.fromJson(
    Map<String, dynamic> json,
  ) {
    return VariationAttributes(
      size: json["size"],

      color:
          json["color"] != null
          ? VariationColor.fromJson(
              json["color"],
            )
          : null,
    );
  }
}

// =====================================================
// VARIATION COLOR
// =====================================================

class VariationColor {
  final String name;
  final String hex;

  VariationColor({
    required this.name,
    required this.hex,
  });

  factory VariationColor.fromJson(
    Map<String, dynamic> json,
  ) {
    return VariationColor(
      name: json["name"] ?? "",
      hex: json["hex"] ?? "",
    );
  }
}