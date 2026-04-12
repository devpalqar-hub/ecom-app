class CartModel {
  final bool success;
  final List<CartItem> data;

  CartModel({required this.success, required this.data});

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final dataMap = json['data'];
    final items = dataMap != null && dataMap['items'] != null
        ? (dataMap['items'] as List<dynamic>)
            .map((e) => CartItem.fromJson(e))
            .whereType<CartItem>() 
            .toList()
        : <CartItem>[];
    return CartModel(
      success: json['success'] ?? false,
      data: items,
    );
  }

  factory CartModel.empty() => CartModel(success: false, data: []);
}

class CartItem {
  final String id;
  final String? productId;
  final String? productVariationId;
  final int quantity;
  final Product product;

  CartItem({
    required this.id,
    this.productId,
    this.productVariationId,
    required this.quantity,
    required this.product,
  });

 
  factory CartItem.fromJson(Map<String, dynamic> json) {
    final variation = json['productVariation'];

    
    Map<String, dynamic> productJson;
    if (json['product'] != null) {
      productJson = json['product'] as Map<String, dynamic>;
    } else if (variation != null && variation['product'] != null) {
      productJson = variation['product'] as Map<String, dynamic>;
    } else {
      
      productJson = {
        'id': '', 
        'name': '',
        'categoryName': '',
        'discountedPrice': 0,
        'actualPrice': 0,
        'description': '',
        'stockCount': 0,
        'isStock': false,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
        'images': [],
      };
    }

    return CartItem(
      id: json['id'] ?? '',
      productId: json['productId'],
      productVariationId: json['productVariationId'],
      quantity: json['quantity'] ?? 1,
      product: Product.fromJson(productJson), 
    );
  }

  
  String get cartKey => productVariationId ?? productId ?? id;

  int get qty => quantity;
  double get unitPrice => product.effectivePrice;
  double get lineTotal => unitPrice * qty;

  bool get isValid => product.id.isNotEmpty;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      id: id,
      productId: productId,
      productVariationId: productVariationId,
      quantity: quantity ?? this.quantity,
      product: product,
    );
  }
}


class Product {
  final String id;
  final String name;
  final String categoryName;
  final double discountedPrice;
  final double actualPrice;
  final String description;
  final int stockCount;
  final bool isStock;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ProductImage> images;

  Product({
    required this.id,
    required this.name,
    required this.categoryName,
    required this.discountedPrice,
    required this.actualPrice,
    required this.description,
    required this.stockCount,
    required this.isStock,
    required this.createdAt,
    required this.updatedAt,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      categoryName: json['categoryName'] ?? '',
      discountedPrice:
          double.tryParse(json['discountedPrice']?.toString() ?? '0') ?? 0,
      actualPrice:
          double.tryParse(json['actualPrice']?.toString() ?? '0') ?? 0,
      description: json['description'] ?? '',
      stockCount: json['stockCount'] ?? 0,
      isStock: json['isStock'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt']) ?? DateTime.now()
          : DateTime.now(),
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => ProductImage.fromJson(e))
              .toList() ??
          [],
    );
  }

  /// Use discounted price if available, otherwise fallback to actual price
  double get effectivePrice => discountedPrice > 0 ? discountedPrice : actualPrice;
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
