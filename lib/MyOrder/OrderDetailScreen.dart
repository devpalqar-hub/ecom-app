// ================= ORDER DETAIL SCREEN =================
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_project/MyOrder/Model/OrderDetailModel.dart';
import 'package:new_project/MyOrder/MyViews/OrderCancellationScreen.dart';
import 'package:new_project/MyOrder/Service/OrderController.dart';

class OrderDetailScreen extends StatefulWidget {
  final OrderDetailModel order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final OrderController controller = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, __) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: Get.back,
          ),
          title: const Text("Order Details",
              style: TextStyle(color: Colors.black)),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _orderSummaryCard(order),
              SizedBox(height: 20.h),
              _trackingUpdates(order),
              SizedBox(height: 20.h),
              _deliveryAddress(order),
              SizedBox(height: 20.h),
              _orderItems(order),
            ],
          ),
        ),
      ),
    );
  }

// order summary
  Widget _orderSummaryCard(OrderDetailModel order) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(order.orderNumber,
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp)),
              const Spacer(),
              Chip(
                label: Text(order.status.capitalizeFirst!,
                    style: const TextStyle(color: Color(0xff1447E6))),
                backgroundColor: Colors.blue.shade50,
                side: const BorderSide(color: Color(0xffBEDBFF)),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text("${order.items.length} items",
              style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            height: 46.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffC47C47),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
              ),
              onPressed: () =>
                  Get.to(() => OrderCancellationScreen(order: order)),
              child: const Text(
                "Cancel Order",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // order items
  Widget _orderItems(OrderDetailModel order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Order Items",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
        SizedBox(height: 12.h),

        ...order.items.map((item) {
          final imageUrl = item.product.images.isNotEmpty
              ? item.product.images.first.url
              : null;

          final bool alreadyReviewed =
              item.product.reviews.isNotEmpty ||
              controller.reviewedProducts.containsKey(item.product.id);

          return Container(
            margin: EdgeInsets.only(bottom: 14.h),
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: imageUrl != null
                          ? Image.network(imageUrl,
                              width: 60.w, height: 60.w, fit: BoxFit.cover)
                          : _imagePlaceholder(),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp)),
                          SizedBox(height: 4.h),
                          Text("Qty: ${item.quantity}",
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 12.sp)),
                        ],
                      ),
                    ),
                    Text("₹${item.product.discountedPrice}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14.sp)),
                  ],
                ),

//review
                if (order.status.toLowerCase() == "delivered" &&
                    !alreadyReviewed)
                  GestureDetector(
                    onTap: () => _openReviewBottomSheet(
                      order: order,
                      productId: item.product.id,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Center(
                        child: Text(
                          "Write a review",
                          style: TextStyle(
                            color: const Color(0xffC47C47),
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // review bottom sheet
  void _openReviewBottomSheet({
    required OrderDetailModel order,
    required String productId,
  }) {
    final RxInt rating = 0.obs;
    final TextEditingController commentController = TextEditingController();

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Rate & Review",
                style:
                    TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 12.h),
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (i) => IconButton(
                      icon: Icon(
                        i < rating.value ? Icons.star : Icons.star_border,
                        color: const Color(0xffC47C47),
                      ),
                      onPressed: () => rating.value = i + 1,
                    ),
                  ),
                )),
            TextField(
              controller: commentController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Write your review",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              height: 42.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffC47C47),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r)),
                ),
                onPressed: () async {
                  if (rating.value == 0) return;

                  await controller.submitReview(
                    productId: productId,
                    orderId: order.id,
                    rating: rating.value,
                    comment: commentController.text.trim(),
                  );

                  controller.reviewedProducts[productId] = rating.value;
                  setState(() {});
                  Get.back();
                },
                child: const Text("Submit Review",
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _imagePlaceholder() => Container(
        width: 60.w,
        height: 60.w,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(Icons.photo, color: Colors.grey.shade400),
      );


  // delivery adress
  Widget _deliveryAddress(OrderDetailModel order) {
    final a = order.shippingAddress;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Delivery Address",
            style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              const CircleAvatar(child: Icon(Icons.location_on)),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                 if (a != null) ...[
  Text(
    a.name,
    style: const TextStyle(fontWeight: FontWeight.bold),
  ),
  Text(
    "${a.address}, ${a.city}, ${a.state} - ${a.postalCode}",
    style: const TextStyle(color: Colors.grey),
  ),
]

                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // trackkinf
  Widget _trackingUpdates(OrderDetailModel order) {
  final tracking = order.tracking;

  if (tracking == null) {
    return const Text(
      "No tracking updates available",
      style: TextStyle(color: Colors.grey),
    );
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Tracking Updates",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 12.h),


      if (tracking.statusHistory.isNotEmpty)
        ...tracking.statusHistory.map((status) {
          final bool active = status.status == tracking.status;

          return _timelineItem(
            title: _getStatusTitle(status.status),
            subtitle: status.notes,
            time: _formatDateTime(status.timestamp),
            location: "-",
            active: active,
          );
        }).toList()

  
      else
        _timelineItem(
          title: _getStatusTitle(tracking.status),
          subtitle: "Order is currently ${tracking.status}",
          time: _formatDateTime(tracking.lastUpdatedAt),
          location: "-",
          active: true,
        ),
    ],
  );
}


  Widget _timelineItem({
    required String title,
    required String subtitle,
    required String time,
    required String location,
    required bool active,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            active ? Icons.check_circle : Icons.inventory_2,
            color: active ? Colors.green : Colors.orange,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 2.h),
                Text(subtitle,
                    style:
                        TextStyle(color: active ? Colors.green : Colors.orange)),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Text(time,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(width: 10),
                    const Icon(Icons.location_on, size: 14, color: Colors.grey),
                    Text(location,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  String _getStatusTitle(String status) {
    switch (status) {
      case "order_placed":
        return "Order Placed";
      case "order_packed":
        return "Order Packed";
      case "in_transit":
        return "In Transit";
      case "out_for_delivery":
        return "Out for Delivery";
      case "delivered":
        return "Delivered";
      case "cancelled":
        return "Cancelled";
      default:
        return status.replaceAll("_", " ").capitalizeFirst ?? status;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return "${dateTime.day.toString().padLeft(2, '0')} "
        "${_monthString(dateTime.month)}, "
        "${dateTime.year} - "
        "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  String _monthString(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[month - 1];
  }
}
