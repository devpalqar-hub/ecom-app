import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_project/MyOrder/MyViews/OrderCard.dart';
import 'package:new_project/MyOrder/OrderDetailScreen.dart';
import 'package:new_project/MyOrder/Service/OrderController.dart';

class MyOrderScreen extends StatelessWidget {
  MyOrderScreen({super.key});

  final OrderController controller = Get.put(OrderController());

 
  final RxString selectedStatus = 'all'.obs;

  
  final List<String> uiStatuses = [
  'All',
  'Confirmed',
  'Processing',
  'Shipped',
  'Delivered',
  'Cancelled',
];

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, child) => Scaffold(
       
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'My Orders',
            style:   TextStyle(
              color: Colors.black,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              fontFamily: "Inter"
            ),
          ),
        ),
        body: SafeArea(
              
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
             
                SizedBox(
                  height: 50.h,
                  child: Obx(
                    () => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Row(
                        children: uiStatuses.map((status) {
                          final backendStatus = status.toLowerCase();
                          return Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: GestureDetector(
                              onTap: () {
                                selectedStatus.value = backendStatus;
                                controller.fetchOrders(
                                    status: backendStatus == 'all'
                                        ? null
                                        : backendStatus);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 14.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  color: selectedStatus.value == backendStatus
                                      ? Color(0xffC17D4A)
                                      : Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.sp,
                                    color: selectedStatus.value == backendStatus
                                        ? Colors.white
                                        : Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
            
                const SizedBox(height: 8),
            
               
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
            
                    if (controller.error.value != null) {
                      return Center(
                          child: Text(controller.error.value!,
                              style: const TextStyle(color: Colors.red)));
                    }
            
                   if (controller.orders.isEmpty) {
              return _emptyOrdersView();
            }
            
            
                    return ListView.builder(
                      itemCount: controller.orders.length,
                      itemBuilder: (context, index) {
                        final order = controller.orders[index];
                        final firstItem = order.items.first;
            
                        return OrderCard(
                          orderId: order.orderNumber,
                          date: _formatDate(order.createdAt),
                          productName: firstItem.product.name,
                          productImage: firstItem.product.images.isNotEmpty
                              ? firstItem.product.images.first.url
                              : '', 
                          quantity: firstItem.quantity,
                          price: double.parse(order.totalAmount),
                          status: order.status.capitalizeFirst!,
                          estimatedDelivery:
                              order.status.toLowerCase() == 'pending'
                                  ? ''
                                  : 'Within 5 days',
                          showTrackButton: order.status.toLowerCase() == 'pending' ||
                              order.status.toLowerCase() == 'shipped',
                         onTap: () async {
              await controller.getOrderById(order.id); 
              if (controller.selectedOrder.value != null) {
                Get.to(() => OrderDetailScreen(order: controller.selectedOrder.value!));
              } else {
                Get.snackbar("Error", "Order details not found",
                    snackPosition: SnackPosition.BOTTOM);
              }
            },
            
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

Widget _emptyOrdersView() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.receipt_long_outlined,
          size: 90.sp,
          color: Colors.grey.shade400,
        ),
        SizedBox(height: 16.h),
        Text(
          'No orders yet',
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'You haven’t placed any orders yet',
          style: GoogleFonts.poppins(
            fontSize: 13.sp,
            color: Colors.grey.shade500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
}