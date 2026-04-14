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
    product = json['product'] != null
        ? new Product.fromJson(json['product'])
        : null;
    productVariation = json['productVariation'] != null
        ? new ProductVariation.fromJson(json['productVariation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productId'] = this.productId;
    data['productVariationId'] = this.productVariationId;
    data['quantity'] = this.quantity;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['customerProfileId'] = this.customerProfileId;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    if (this.productVariation != null) {
      data['productVariation'] = this.productVariation!.toJson();
    }
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

    if (productVariation != null)
      name = name + "(${productVariation!.variationName})";
    return name;
  }

  bool isOutOfStock() {
    if (productVariation != null) {
      return (productVariation!.stockCount!) <= 0;
    } else {
      return (product!.stockCount!) <= 0;
    }
  }

  int getStockCount() {
    if (productVariation != null) {
      return (productVariation!.stockCount!);
    } else {
      return (product!.stockCount!);
    }
  }
}

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
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
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

class ProductVariation {
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
  Product? product;

  ProductVariation({
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
    this.product,
  });

  ProductVariation.fromJson(Map<String, dynamic> json) {
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
    product = json['product'] != null
        ? new Product.fromJson(json['product'])
        : null;
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
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}
