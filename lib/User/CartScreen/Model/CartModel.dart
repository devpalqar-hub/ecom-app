class CartItemModel {
  String? id;
  String? productId;
  String? productVariationId;
  int? quantity;
  String? createdAt;
  String? updatedAt;
  String? customerProfileId;
  Product? product;
  ProductVariation? productVariation;

  CartItemModel({
    this.id,
    this.productId,
    this.productVariationId,
    this.quantity,
    this.createdAt,
    this.updatedAt,
    this.customerProfileId,
    this.product,
    this.productVariation,
  });

  CartItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['productId'];
    productVariationId = json['productVariationId'];
    quantity = json['quantity'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    customerProfileId = json['customerProfileId'];
    product = json['product'] != null ? Product.fromJson(json['product']) : null;
    productVariation = json['productVariation'] != null
        ? ProductVariation.fromJson(json['productVariation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['productId'] = productId;
    data['productVariationId'] = productVariationId;
    data['quantity'] = quantity;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['customerProfileId'] = customerProfileId;
    if (product != null) data['product'] = product!.toJson();
    if (productVariation != null) data['productVariation'] = productVariation!.toJson();
    return data;
  }

  double getEffectivePrice() {
    double price = 0;
    double discountPrice = 0;
    if (productVariation != null) {
      price = double.parse(productVariation!.actualPrice ?? "0");
      discountPrice = double.parse(productVariation!.discountedPrice ?? "0");
    } else {
      price = double.parse(product!.actualPrice ?? "0");
      discountPrice = double.parse(product!.discountedPrice ?? "0");
    }
    return (discountPrice != 0) ? discountPrice : price;
  }

  double getStrikeThoughtPrice() {
    double price = 0;
    double discountPrice = 0;
    if (productVariation != null) {
      price = double.parse(productVariation!.actualPrice ?? "0");
      discountPrice = double.parse(productVariation!.discountedPrice ?? "0");
    } else {
      price = double.parse(product!.actualPrice ?? "0");
      discountPrice = double.parse(product!.discountedPrice ?? "0");
    }
    return (discountPrice != 0) ? price : 0;
  }

  String getProductName() {
    String name = product!.name ?? "";
    if (productVariation != null) {
      name = "$name (${productVariation!.variationName})";
    }
    return name;
  }

  bool isOutOfStock() {
    if (productVariation != null) {
      return (productVariation!.stockCount ?? 0) <= 0;
    } else {
      return (product!.stockCount ?? 0) <= 0;
    }
  }

  int getStockCount() {
    if (productVariation != null) {
      return productVariation!.stockCount ?? 0;
    } else {
      return product!.stockCount ?? 0;
    }
  }
}

// ── Product ───────────────────────────────────────────────────────────────────

class Product {
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

  Product({
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
  });

  Product.fromJson(Map<String, dynamic> json) {
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
      json['images'].forEach((v) => images!.add(Images.fromJson(v)));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['subCategoryId'] = subCategoryId;
    data['discountedPrice'] = discountedPrice;
    data['actualPrice'] = actualPrice;
    data['description'] = description;
    data['stockCount'] = stockCount;
    data['isStock'] = isStock;
    data['isFeatured'] = isFeatured;
    data['isActive'] = isActive;
    data['variationTitle'] = variationTitle;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (images != null) data['images'] = images!.map((v) => v.toJson()).toList();
    return data;
  }
}

// ── Images ────────────────────────────────────────────────────────────────────

class Images {
  String? id;
  String? productId;
  String? url;
  String? altText;
  bool? isMain;
  int? sortOrder;

  Images({this.id, this.productId, this.url, this.altText, this.isMain, this.sortOrder});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['productId'];
    url = json['url'];
    altText = json['altText'];
    isMain = json['isMain'];
    sortOrder = json['sortOrder'];
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

// ── ProductVariation ──────────────────────────────────────────────────────────

class ProductVariation {
  String? id;
  String? productId;
  String? variationName;
  String? variationType;        // ✅ added
  VariationAttributes? attributes; // ✅ added
  String? sku;
  String? discountedPrice;
  String? actualPrice;
  int? stockCount;
  bool? isAvailable;
  String? createdAt;
  String? updatedAt;
  Product? product;

  ProductVariation({
    this.id,
    this.productId,
    this.variationName,
    this.variationType,
    this.attributes,
    this.sku,
    this.discountedPrice,
    this.actualPrice,
    this.stockCount,
    this.isAvailable,
    this.createdAt,
    this.updatedAt,
    this.product,
  });

  ProductVariation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['productId'];
    variationName = json['variationName'];
    variationType = json['variationType'];
    attributes = json['attributes'] != null
        ? VariationAttributes.fromJson(json['attributes'])
        : null;
    sku = json['sku'];
    discountedPrice = json['discountedPrice'];
    actualPrice = json['actualPrice'];
    stockCount = json['stockCount'];
    isAvailable = json['isAvailable'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    product = json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['productId'] = productId;
    data['variationName'] = variationName;
    data['variationType'] = variationType;
    if (attributes != null) data['attributes'] = attributes!.toJson();
    data['sku'] = sku;
    data['discountedPrice'] = discountedPrice;
    data['actualPrice'] = actualPrice;
    data['stockCount'] = stockCount;
    data['isAvailable'] = isAvailable;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (product != null) data['product'] = product!.toJson();
    return data;
  }
}

// ── VariationAttributes ───────────────────────────────────────────────────────

class VariationAttributes {
  String? size;               // nullable — some variations are color-only
  VariationColor? color;

  VariationAttributes({this.size, this.color});

  VariationAttributes.fromJson(Map<String, dynamic> json) {
    size = json['size'];
    color = json['color'] != null ? VariationColor.fromJson(json['color']) : null;
  }

  Map<String, dynamic> toJson() => {
    'size': size,
    if (color != null) 'color': color!.toJson(),
  };
}

// ── VariationColor ────────────────────────────────────────────────────────────

class VariationColor {
  String? hex;
  String? name;

  VariationColor({this.hex, this.name});

  VariationColor.fromJson(Map<String, dynamic> json) {
    hex = json['hex'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() => {
    'hex': hex,
    'name': name,
  };
}