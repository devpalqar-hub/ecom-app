import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:new_project/Home%20Page/Model/CategoryModel.dart';
import 'package:new_project/Home%20Page/Model/ProductDetailModel.dart';
import 'package:new_project/Home%20Page/Model/ProdutModel.dart';
import 'package:new_project/main.dart';

class Searchproductcontroller extends GetxController {
  List<Category> categories = [];
  List<SubCategoryModel> subCategories = [];
  List<ProductModel> products = [];
  TextEditingController searchText = TextEditingController();
  bool isloading = false;
  String maxPrice = "";
  String minPrice = "";
  int page = 1;

  Category? selectedCategory = null;
  SubCategoryModel? selectedSubCategoryId = null;

  loadInit({String categoryID = ""}) {
    if (categoryID != "") {
      for (var data in categories)
        if (categoryID == data.id) {
          selectedCategory = data;
          subCategories = [];
          fetchSubCategories(categoryID);
        }
    } else {
      selectedCategory = null;
    }
    page = 1;
    maxPrice = "";
    minPrice = "";
    selectedSubCategoryId = null;
    products = [];

    fetchProducts();
  }

  fetchProducts() async {
    String parms = "";
    products = [];

    isloading = true;
    update();
    if (!searchText.text.isEmpty) {
      parms = parms + "&search=${searchText.text}";
    }

    if (selectedCategory != null) {
      parms = parms + "&categoryId=${selectedCategory!.id}";
    }

    if (selectedSubCategoryId != null) {
      parms = parms + "&subCategoryId=${selectedSubCategoryId!.id}";
    }

    if (maxPrice != "" && maxPrice != "0") {
      parms = parms + "&maxPrice=${maxPrice}";
    }

    if (minPrice != "" && minPrice != "0") {
      parms = parms + "&minPrice=${minPrice}";
    }
    print("$baseUrl/products?limit=30&page=${page}$parms");
    final response = await get(
      Uri.parse('$baseUrl/products?&limit=30&page=${page}$parms'),
    );
    isloading = false;
    update();
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      for (var data in body["data"]["data"])
        products.add(ProductModel.fromJson(data));
    }
    update();
  }

  Future<void> fetchCategories() async {
    final res = await get(Uri.parse('$baseUrl/categories'));
    categories.clear();
    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);
      final List list = decoded['data']['data'];
      for (var data in decoded["data"]["data"])
        categories.add(Category.fromJson(data));
    }
    update();
  }

  Future<void> fetchSubCategories(String categoryId) async {
    final res = await get(
      Uri.parse('$baseUrl/subcategories/category/$categoryId'),
    );

    if (res.statusCode == 200) {
      final data = json.decode(res.body)['data'] as List;
      subCategories.assignAll(
        data.map((e) => SubCategoryModel.fromJson(e)).toList(),
      );
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchCategories();
  }
}
