import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:new_project/Admin/HomeScreen/Service/DeliveryController.dart';
import 'package:new_project/main.dart';
import 'package:new_project/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/ReturnOrderModel.dart';

class ReturnOrderController extends GetxController {
  bool isLoading = false;
  List<ReturnOrder> returnOrders = [];
  List<ReturnOrder> filteredReturnOrders = [];

  @override
  void onInit() {
    fetchReturns();
    super.onInit();
  }

  Future<void> fetchReturns({
    String? orderId,
    int page = 1,
    int limit = 20,
  }) async {

    isLoading = true;
    update();

    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");

   
    if (token == null || token.isEmpty) {
     
      showAppNotification(
        "Session expired. Please login again",
        type: AppNotificationType.error,
      );
      return;
    }

    
    String url =
        "$baseUrl/returns/delivery-partner/my-returns?page=$page&limit=$limit&status=pending";

    if (orderId != null && orderId.isNotEmpty) {
      url = "$url?orderId=$orderId";
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    final data = jsonDecode(response.body);

    
    if (response.statusCode == 200 && data["success"] == true) {
      final List<dynamic> list = data['data']?['data'] ?? [];



      returnOrders.addAll(
        list.map((e) {
        
          return ReturnOrder.fromJson(e);
        }).toList(),
      );

     
      filteredReturnOrders = List.from(returnOrders);

     
    } else {
    
      showAppNotification(
        data["message"] ?? "Failed to fetch return orders",
        type: AppNotificationType.error,
      );
    }
   
    isLoading = false;
    update();
   
  }
}
