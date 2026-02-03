import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:new_project/Home%20Page/Model/BannerModel.dart';
import 'package:new_project/main.dart';


class BannerController extends GetxController {
 
  final RxBool isLoading = false.obs;
  final RxList<BannerModel> banners = <BannerModel>[].obs;
  final RxnString error = RxnString();

 
  Future<void> fetchBanners() async {
    try {
      isLoading.value = true;
      error.value = null;

      final url = "$baseUrl/banners";


      final response = await http.get(Uri.parse(url));

     
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        final List<dynamic> list =
            body['data'] as List<dynamic>? ?? [];

        banners.assignAll(
          list.map((e) => BannerModel.fromJson(e)).toList(),
        );

        print("✅ BANNERS COUNT: ${banners.length}");
      } else {
        error.value = "Failed to fetch banners (${response.statusCode})";
        banners.clear();
      }
    } catch (e, stack) {
    
      error.value = e.toString();
      banners.clear();
    } finally {
      isLoading.value = false;
    
    }
  }
}
