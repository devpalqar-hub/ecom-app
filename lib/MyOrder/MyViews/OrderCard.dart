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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  orderId,
                  style: GoogleFonts.poppins(
                      fontSize: 16.sp, fontWeight: FontWeight.w600),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: getStatusColor(),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    status,
                    style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              date,
              style:
                  GoogleFonts.poppins(fontSize: 12.sp, color: Colors.grey),
            ),
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
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        style: GoogleFonts.poppins(
                            fontSize: 14.sp, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Qty: $quantity',
                        style: GoogleFonts.poppins(
                            fontSize: 12.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Text(
                  'QA$price',
                  style: GoogleFonts.poppins(
                      fontSize: 14.sp, fontWeight: FontWeight.w600),
                )
              ],
            ),

            SizedBox(height: 12.h),

            if (status.toLowerCase() == 'delivered')
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle,
                        size: 16.sp, color: Colors.green),
                    SizedBox(width: 4.w),
                    Text(
                      'Delivered successfully',
                      style: GoogleFonts.poppins(
                          fontSize: 12.sp, color: Colors.green.shade800),
                    ),
                  ],
                ),
              ),

            SizedBox(height: 12.h),

          
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount\nQAR$price',
                  style: GoogleFonts.poppins(
                      fontSize: 14.sp, fontWeight: FontWeight.w600),
                ),
                if (showTrackButton && order != null)
  ElevatedButton.icon(
    onPressed: () {
      Get.to(() => OrderDetailScreen(order: order!));
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xffC17D4A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.r),
      ),
    ),
    icon: const Icon(Icons.local_shipping, size: 16, color: Colors.white),
    label: Text(
      'Track Order',
      style: GoogleFonts.poppins(fontSize: 12.sp, color: Colors.white),
    ),
  ),

              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: 60.w,
      height: 60.w,
      color: Colors.grey.shade200,
      child: const Icon(
        Icons.image_not_supported,
        color: Colors.grey,
      ),
    );
  }
}
