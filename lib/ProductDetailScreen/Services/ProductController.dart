import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:new_project/Home%20Page/Model/ProdutModel.dart';
import 'package:new_project/ProductDetailScreen/Models./ProductDetailModel.dart';
import 'package:new_project/main.dart';

class Productcontroller extends GetxController {
  final String productId;

  Productcontroller(this.productId); // ✅ FIXED

  ProductDetailModel? product;
  List<ProductModel> releatedProducts = [];
  bool isLoading = true;

  Future<void> fetchProduct() async {
    isLoading = true;
    update();

    var response = await get(
      Uri.parse("$baseUrl/products/$productId"),
      headers: {"Authorization": "Bearer $accessToken"},
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      product = ProductDetailModel.fromJson(data["data"]);
      fetchRelatedProduct(product!.subCategory!.categoryId!);
    }

    isLoading = false;
    update();
  }

  Future<void> fetchRelatedProduct(String categoryID) async {
    releatedProducts.clear();
    var response = await get(
      Uri.parse("$baseUrl/products?categoryId=${categoryID}&limit=8&page=1 "),
      headers: {"Authorization": "Bearer $accessToken"},
    );

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      for (var data in body["data"]["data"])
        releatedProducts.add(ProductModel.fromJson(data));
      update();
    }
    isLoading = false;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    fetchProduct(); // ✅ call here
  }
}
