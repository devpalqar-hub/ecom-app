// ================= ORDER DETAIL SCREEN =================
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:new_project/MyOrder/Model/OrderDetailModel.dart';
import 'package:new_project/MyOrder/ReturnOrderScreen.dart';
import 'package:new_project/MyOrder/Service/OrderController.dart';
import 'package:new_project/ProductDetailScreen/ProductDetailScreen.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderID;
  OrderDetailScreen({super.key, required this.orderID});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final OrderController controller = Get.put(OrderController());
  final RxBool isTimelineExpanded = false.obs;

  // Derive the lists once so we don't recompute in every build.

  @override
  void initState() {
    super.initState();
    //_splitItems(widget.order);
    controller.selectedOrder = null;
    controller.getOrderById(widget.orderID);
  }

  bool showReturn(List<OrderItem> items) {
    return items.where((it) => it.isReturn).length != items.length;
  }

  @override
  Widget build(BuildContext context) {
    // final order  = controller.se//= widget.order;

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, __) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: Get.back,
          ),
          title: Text(
            "Order Details",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        // ── Return button in bottom bar ──
        bottomNavigationBar: SafeArea(
          child: GetBuilder<OrderController>(
            builder: (ctx) =>
                (ctx.selectedOrder != null &&
                    showReturn(ctx.selectedOrder!.items!))
                ? _buildReturnBottomBar(ctx.selectedOrder!)
                : Container(height: 0, width: 0),
          ),
        ),
        body: SafeArea(
          child: GetBuilder<OrderController>(
            builder: (ctx) {
              return (ctx.selectedOrder == null)
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: EdgeInsets.all(16.w),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _orderSummaryCard(ctx.selectedOrder!),
                          SizedBox(height: 20.h),
                          _trackingUpdates(ctx.selectedOrder!),
                          SizedBox(height: 20.h),
                          _deliveryAddress(ctx.selectedOrder!),
                          SizedBox(height: 20.h),

                          // ── Active / Delivered items ──
                          if (ctx.selectedOrder!.items
                              .where((it) => !it.isReturn)
                              .isNotEmpty)
                            _orderItems(ctx.selectedOrder!, [
                              for (var data in ctx.selectedOrder!.items)
                                if (!data.isReturn) data,
                            ], isReturned: false),

                          // ── Returned items section ──
                          if (ctx.selectedOrder!.items
                              .where((it) => it.isReturn)
                              .isNotEmpty) ...[
                            SizedBox(height: 20.h),
                            _orderItems(ctx.selectedOrder!, [
                              for (var data in ctx.selectedOrder!.items)
                                if (data.isReturn) data,
                            ], isReturned: true),
                          ],

                          SizedBox(height: 20.h),
                          _pricingSummary(ctx.selectedOrder!),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }

  // ── Bottom return bar ──
  Widget _buildReturnBottomBar(OrderDetailModel order) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 30.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50.h,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFAE933F),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),
          icon: Icon(
            Icons.assignment_return_outlined,
            color: Colors.white,
            size: 20.sp,
          ),
          onPressed: () => Get.to(
            () => ReturnOrderScreen(order: order),
            transition: Transition.rightToLeft,
          ),
          label: Text(
            "Return Order",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // ── Order Summary Card ──
  Widget _orderSummaryCard(OrderDetailModel order) {
    // Override display status when fully returned
    int count = order.items.where((it) => it.isReturn).length;

    final displayStatus = count == order.items.length
        ? 'returned'
        : order.status;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order ID",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 11.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      order.orderNumber,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: _getStatusColor(displayStatus),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Text(
                  displayStatus.capitalizeFirst!,
                  style: TextStyle(
                    color: _getStatusTextColor(displayStatus),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Divider(color: Colors.grey.shade200),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 16.sp,
                color: Colors.grey.shade600,
              ),
              SizedBox(width: 8.w),
              Text(
                "${order.items.length} item${order.items.length > 1 ? 's' : ''}",
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                "QAR ${order.totalAmount}",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                  color: Color(0xFFAE933F),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green.shade50;
      case 'returned':
        return Colors.purple.shade50;
      case 'shipped':
      case 'out_for_delivery':
        return Colors.blue.shade50;
      case 'processing':
      case 'confirmed':
        return Colors.orange.shade50;
      case 'cancelled':
        return Colors.red.shade50;
      default:
        return Colors.grey.shade100;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green.shade700;
      case 'returned':
        return Colors.purple.shade700;
      case 'shipped':
      case 'out_for_delivery':
        return Colors.blue.shade700;
      case 'processing':
      case 'confirmed':
        return Colors.orange.shade700;
      case 'cancelled':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  // ── Order Items list (used for both active and returned sections) ──
  Widget _orderItems(
    OrderDetailModel order,
    List<OrderItem> items, {
    required bool isReturned,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            Text(
              isReturned ? "Returned Items" : "Order Items",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16.sp,
                color: Colors.black87,
              ),
            ),
            SizedBox(width: 8.w),
            if (isReturned)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  "${items.length}",
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.purple.shade700,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 12.h),

        ...items.map((item) {
          final imageUrl = item.product.images.isNotEmpty
              ? item.product.images.first.url
              : null;

          return GestureDetector(
            onTap: () =>
                Get.to(() => ProductDetailScreen(productId: item.product.id)),
            child: Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                // Slightly tinted background for returned items
                color: isReturned
                    ? Colors.purple.shade50.withOpacity(0.4)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isReturned
                      ? Colors.purple.shade100
                      : Colors.grey.shade200,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // product image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: imageUrl != null
                            ? Image.network(
                                imageUrl,
                                width: 55.w,
                                height: 55.w,
                                fit: BoxFit.cover,
                              )
                            : _imagePlaceholder(),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "Qty: ${item.quantity}",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "QAR ${item.product.discountedPrice}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp,
                            ),
                          ),
                          // "Returned" badge on item level
                          if (isReturned) ...[
                            SizedBox(height: 4.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.purple.shade100,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                "Returned",
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.purple.shade700,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),

                  // Review CTA — only for delivered, non-returned items with no review yet
                  if (order.status.toLowerCase() == 'delivered' &&
                      item.review == null)
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
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // ── Review Bottom Sheet ──
  void _openReviewBottomSheet({
    required OrderDetailModel order,
    required String productId,
  }) {
    final RxInt rating = 0.obs;
    final TextEditingController commentController = TextEditingController();

    Get.bottomSheet(
      isScrollControlled: true,
      SafeArea(
        child: Container(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 24.h,
            // Avoid keyboard overlap
            bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Rate & Review",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16.h),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (i) => IconButton(
                      iconSize: 32.sp,
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      icon: Icon(
                        i < rating.value ? Icons.star : Icons.star_border,
                        color: const Color(0xFFAE933F),
                      ),
                      onPressed: () => rating.value = i + 1,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: commentController,
                maxLines: 4,
                style: TextStyle(fontSize: 13.sp),
                decoration: InputDecoration(
                  hintText: "Write your review here...",
                  hintStyle: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey.shade400,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: const BorderSide(color: Color(0xFFAE933F)),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 12.h,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                height: 46.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFAE933F),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  onPressed: () async {
                    if (rating.value == 0) {
                      Get.snackbar(
                        'Rating Required',
                        'Please select a rating before submitting',
                        backgroundColor: Colors.red.shade50,
                        colorText: Colors.red.shade800,
                      );
                      return;
                    }
                    // submitReview now calls Get.back() internally on success
                    await controller.submitReview(
                      productId: productId,
                      orderId: order.id,
                      rating: rating.value,
                      comment: commentController.text.trim(),
                    );
                  },
                  child: Text(
                    "Submit Review",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imagePlaceholder() => Container(
    width: 55.w,
    height: 55.w,
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(8.r),
    ),
    child: Icon(Icons.photo, color: Colors.grey.shade400, size: 24.sp),
  );

  // ── Delivery Address ──
  Widget _deliveryAddress(OrderDetailModel order) {
    final a = order.shippingAddress;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Delivery Address",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4E6),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.location_on,
                  color: const Color(0xFFAE933F),
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (a != null) ...[
                      Text(
                        a.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15.sp,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        "${a.address}, ${a.city}, ${a.state} - ${a.postalCode}",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 13.sp,
                          height: 1.4,
                        ),
                      ),
                      if (a.phone.isNotEmpty) ...[
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Icon(
                              Icons.phone_outlined,
                              size: 14.sp,
                              color: Colors.grey.shade600,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              a.phone,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 13.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Tracking ──
  Widget _trackingUpdates(OrderDetailModel order) {
    final tracking = order.tracking;

    if (tracking == null) {
      return Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            Icon(Icons.info_outline, size: 40.sp, color: Colors.grey.shade400),
            SizedBox(height: 12.h),
            Text(
              "No tracking updates available",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14.sp),
            ),
          ],
        ),
      );
    }

    final statusHistory = tracking.statusHistory.isNotEmpty
        ? tracking.statusHistory
        : [
            TrackingHistory(
              status: tracking.status,
              timestamp: tracking.lastUpdatedAt,
              notes: "Order is currently ${tracking.status}",
            ),
          ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Order Timeline",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w700,
                fontSize: 16.sp,
              ),
            ),
            if (statusHistory.length > 2)
              Obx(
                () => TextButton.icon(
                  onPressed: () => isTimelineExpanded.toggle(),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  icon: Icon(
                    isTimelineExpanded.value
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 18.sp,
                    color: const Color(0xFFAE933F),
                  ),
                  label: Text(
                    isTimelineExpanded.value ? 'Show Less' : 'Show All',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFAE933F),
                    ),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Obx(() {
            final displayCount = isTimelineExpanded.value
                ? statusHistory.length
                : (statusHistory.length > 2 ? 2 : statusHistory.length);

            return Column(
              children: List.generate(displayCount, (index) {
                final status = statusHistory[index];
                final isLast = index == displayCount - 1;
                final isActive = status.status == tracking.status;

                return _timelineItem(
                  title: _getStatusTitle(status.status),
                  subtitle: status.notes,
                  time: _formatDateTime(status.timestamp),
                  isActive: isActive,
                  isLast: isLast,
                  isCompleted:
                      index <=
                      statusHistory.indexWhere(
                        (s) => s.status == tracking.status,
                      ),
                );
              }),
            );
          }),
        ),
      ],
    );
  }

  Widget _timelineItem({
    required String title,
    required String subtitle,
    required String time,
    required bool isActive,
    required bool isLast,
    required bool isCompleted,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? const Color(0xFFAE933F)
                      : Colors.grey.shade200,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isCompleted
                        ? const Color(0xFFAE933F)
                        : Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: isCompleted
                    ? Icon(Icons.check, color: Colors.white, size: 16.sp)
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: EdgeInsets.symmetric(vertical: 4.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: isCompleted
                            ? [
                                const Color(0xFFAE933F),
                                const Color(0xFFAE933F).withOpacity(0.3),
                              ]
                            : [Colors.grey.shade300, Colors.grey.shade200],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                      fontSize: isActive ? 13.sp : 12.sp,
                      color: isCompleted
                          ? Colors.black87
                          : Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12.sp,
                        color: Colors.grey.shade500,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        time,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
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
      "Dec",
    ];
    return months[month - 1];
  }

  // ── Pricing Summary ──
  Widget _pricingSummary(OrderDetailModel order) {
    final double subtotal = order.items.fold(
      0.0,
      (sum, item) =>
          sum +
          (double.tryParse(item.product.discountedPrice) ?? 0.0) *
              item.quantity,
    );
    final double discount = double.tryParse(order.discountAmount) ?? 0.0;
    final double shippingCost = double.tryParse(order.shippingCost) ?? 0.0;
    final double tax = double.tryParse(order.taxAmount) ?? 0.0;
    final double total = double.tryParse(order.totalAmount) ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Price Summary",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _priceRow(label: "Subtotal", value: subtotal, isSubtotal: true),
              if (discount > 0) ...[
                SizedBox(height: 10.h),
                _priceRow(label: "Discount", value: discount, isDiscount: true),
              ],
              if (shippingCost > 0) ...[
                SizedBox(height: 10.h),
                _priceRow(label: "Delivery Charge", value: shippingCost),
              ],
              if (tax > 0) ...[
                SizedBox(height: 10.h),
                _priceRow(label: "Tax", value: tax),
              ],
              SizedBox(height: 12.h),
              Divider(color: Colors.grey.shade300, thickness: 1),
              SizedBox(height: 12.h),
              _priceRow(label: "Total Amount", value: total, isTotal: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _priceRow({
    required String label,
    required double value,
    bool isSubtotal = false,
    bool isDiscount = false,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 14.sp : 12.sp,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isTotal ? Colors.black87 : Colors.grey.shade700,
          ),
        ),
        Text(
          "${isDiscount ? '-' : ''}QAR ${value.toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: isTotal ? 16.sp : 13.sp,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
            color: isTotal
                ? const Color(0xFFAE933F)
                : isDiscount
                ? Colors.green.shade700
                : Colors.black87,
          ),
        ),
      ],
    );
  }
}
