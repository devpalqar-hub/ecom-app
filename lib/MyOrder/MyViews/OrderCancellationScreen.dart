import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_project/MyOrder/Model/OrderDetailModel.dart';
import 'package:new_project/MyOrder/MyOrderScreen.dart';
import 'package:new_project/MyOrder/Service/OrderController.dart';
class OrderCancellationScreen extends StatelessWidget {
  final OrderDetailModel order;
  final OrderController controller = Get.find<OrderController>();

  OrderCancellationScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, __) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: const BackButton(color: Colors.black),
          title: const Text(
            "Cancel Order",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _orderCard(),
              SizedBox(height: 20.h),
              _cancelButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _orderCard() {
    final firstItem = order.items.isNotEmpty ? order.items.first : null;
    final status = order.status.isNotEmpty ? order.status : 'pending';

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                order.orderNumber,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _statusColor(status).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  status.capitalizeFirst ?? status,
                  style: TextStyle(
                    color: _statusColor(status),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),

          
          Text(
            _formatDate(order.createdAt),
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 14.h),


          if (firstItem != null)
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: _productImage(firstItem),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        firstItem.product.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "Qty: ${firstItem.quantity}",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "QAR${firstItem.product.discountedPrice}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),

          SizedBox(height: 12.h),

          Text(
            "Total Amount",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            "QAR${order.totalAmount}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _productImage(firstItem) {
    if (firstItem.product.images.isEmpty ||
        firstItem.product.images.first.url.isEmpty) {
      return _imagePlaceholder();
    }
    return Image.network(
      firstItem.product.images.first.url,
      width: 50.w,
      height: 50.w,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _imagePlaceholder(),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 50.w,
      height: 50.w,
      color: Colors.grey.shade200,
      child: const Icon(
        Icons.image_not_supported,
        color: Colors.grey,
      ),
    );
  }

Widget _cancelButton() {
  return Obx(
    () => SizedBox(
      width: double.infinity,
      height: 46.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffC47C47),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
        ),
        onPressed: controller.isLoading.value
            ? null
            : () async {
                final currentStatus =
                    controller.selectedOrder.value?.status.toLowerCase() ??
                        order.status.toLowerCase();

                if (currentStatus == 'cancelled') {
        
                  Get.snackbar(
                    "Cannot Cancel",
                    "Order is already cancelled",
                    backgroundColor: Colors.red.shade100,
                    colorText: Colors.red.shade800,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  return;
                }

                if (currentStatus == 'delivered') {
  
                  Get.snackbar(
                    "Cannot Cancel",
                    "Delivered orders cannot be cancelled",
                    backgroundColor: Colors.red.shade100,
                    colorText: Colors.red.shade800,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  return;
                }

                
                final success = await controller.cancelOrder(order.id);

                if (success &&
                    controller.selectedOrder.value?.status.toLowerCase() ==
                        'cancelled') {
                  _showCancelledDialog(); 
                } else {
                  Get.snackbar(
                    "Failed",
                    "Order could not be cancelled",
                    backgroundColor: Colors.red.shade100,
                    colorText: Colors.red.shade800,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
        child: controller.isLoading.value
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                "Cancel Order",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),
              ),
      ),
    ),
  );
}

  void _showCancelledDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: SizedBox(
          width: 280.w,
          height: 280.w,
          child: Stack(
            children: [
     
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 70.w,
                      height: 70.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red.shade100,
                      ),
                      child: Icon(
                        Icons.check,
                        color: Colors.red,
                        size: 40.w,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      "Order Cancelled Successfully",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
   
              Positioned(
                top: 8.w,
                right: 8.w,
                child: GestureDetector(
                  onTap: () {
                    Get.back(); 
                    Get.to(() => MyOrderScreen());
                  },
                  child: Container(
                    width: 30.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

 
  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return Colors.orange;
      case "shipped":
        return Colors.blue;
      case "delivered":
        return Colors.green;
      case "cancelled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }
}
