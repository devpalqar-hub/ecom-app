class CategoryModel {
  final String id;
  final String name;
  final String? slug;         
  final String? description;   
  final String? image;         
  final String? createdAt;     
  final String? updatedAt;     
  final List<SubCategoryModel> subCategories;

  CategoryModel({
    required this.id,
    required this.name,
    this.slug,
    this.description,
    this.image,
    this.createdAt,
    this.updatedAt,
    required this.subCategories,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        slug: json['slug']?.toString(),
        description: json['description']?.toString(),
        image: (json['image'] != null && (json['image'] as String).isNotEmpty)
            ? json['image'].toString().trim()
            : null,
        createdAt: json['createdAt']?.toString(),
        updatedAt: json['updatedAt']?.toString(),
        subCategories: json['subCategories'] != null
            ? List<SubCategoryModel>.from(
                (json['subCategories'] as List)
                    .map((x) => SubCategoryModel.fromJson(x)))
            : [],
      );
}

class SubCategoryModel {
  final String id;
  final String name;
  final String? slug;          // nullable
  final String? description;   // nullable
  final String categoryId;
  final String? image;         // nullable
  final String? createdAt;     // nullable
  final String? updatedAt;     // nullable

  SubCategoryModel({
    required this.id,
    required this.name,
    this.slug,
    this.description,
    required this.categoryId,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) =>
      SubCategoryModel(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        slug: json['slug']?.toString(),
        description: json['description']?.toString(),
        categoryId: json['categoryId'] ?? '',
        image: (json['image'] != null && (json['image'] as String).isNotEmpty)
            ? json['image'].toString().trim()
            : null,
        createdAt: json['createdAt']?.toString(),
        updatedAt: json['updatedAt']?.toString(),
      );
}
