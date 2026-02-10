import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:new_project/MyOrder/Model/OrderDetailModel.dart';
import 'package:new_project/MyOrder/OrderDetailScreen.dart';

class OrderCard extends StatelessWidget {
  final VoidCallback? onTap;
  final String orderId;
  final String date;
  final String productName;
  final String? productImage;
  final int quantity;
  final double price;
  final String status;
  final String estimatedDelivery;
  final bool showTrackButton;
  final OrderDetailModel? order;

  const OrderCard({
    Key? key,
    required this.orderId,
    required this.date,
    required this.productName,
    this.productImage,
    required this.quantity,
    required this.price,
    required this.status,
    this.estimatedDelivery = '',
    this.showTrackButton = false,
    this.onTap,
    this.order,
  }) : super(key: key);

  Color getStatusColor() {
    if (status.toLowerCase() == 'shipped' ||
        status.toLowerCase() == 'delivered') {
      return Colors.green.shade100;
    }
    return Colors.grey.shade200;
  }

  Color _getStatusBackgroundColor() {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green.shade50;
      case 'shipped':
        return Colors.blue.shade50;
      case 'processing':
        return Colors.orange.shade50;
      case 'confirmed':
        return Colors.purple.shade50;
      case 'cancelled':
        return Colors.red.shade50;
      default:
        return Colors.grey.shade100;
    }
  }

  Color _getStatusTextColor() {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green.shade700;
      case 'shipped':
        return Colors.blue.shade700;
      case 'processing':
        return Colors.orange.shade700;
      case 'confirmed':
        return Colors.purple.shade700;
      case 'cancelled':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.w),
        margin: EdgeInsets.only(bottom: 12.h, left: 6.w, right: 6.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade200, width: 1),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        orderId,
                        style: GoogleFonts.poppins(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 11.sp,
                            color: Colors.grey.shade500,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            date,
                            style: GoogleFonts.poppins(
                              fontSize: 11.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusBackgroundColor(),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Text(
                    status,
                    style: GoogleFonts.poppins(
                      fontSize: 10.sp,
                      color: _getStatusTextColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            Divider(height: 1, color: Colors.grey.shade200),
            SizedBox(height: 12.h),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: (productImage != null && productImage!.isNotEmpty)
                      ? Image.network(
                          productImage!,
                          width: 60.w,
                          height: 60.w,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholderImage(),
                        )
                      : _placeholderImage(),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: Text(
                          'Qty: $quantity',
                          style: GoogleFonts.poppins(
                            fontSize: 10.sp,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  'QAR $price',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFAE933F),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            if (status.toLowerCase() == 'delivered')
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16.sp,
                      color: Colors.green.shade700,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'Delivered successfully',
                      style: GoogleFonts.poppins(
                        fontSize: 11.sp,
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

            if (status.toLowerCase() == 'delivered') SizedBox(height: 12.h),

            if (showTrackButton && order != null)
              SizedBox(
                width: double.infinity,
                height: 40.h,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.to(() => OrderDetailScreen(order: order!));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFAE933F),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  icon: Icon(Icons.local_shipping_outlined, size: 16.sp),
                  label: Text(
                    'Track Order',
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: 60.w,
      height: 60.w,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(
        Icons.image_outlined,
        color: Colors.grey.shade400,
        size: 28.sp,
      ),
    );
  }
}
