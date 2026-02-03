import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:new_project/CartScreen/Services/CartController.dart';
class CouponCard extends StatefulWidget {
  final CartController cartController;

  const CouponCard({super.key, required this.cartController});

  @override
  State<CouponCard> createState() => _CouponCardState();
}

class _CouponCardState extends State<CouponCard> {
  final TextEditingController couponController = TextEditingController();

  @override
  void dispose() {
    couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final appliedCoupon = widget.cartController.appliedCoupon.value;
      final isLoading = widget.cartController.couponLoading.value;


      if (appliedCoupon == null && couponController.text.isNotEmpty) {
        couponController.clear();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (appliedCoupon == null || appliedCoupon.isEmpty)
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: couponController,
                    decoration: InputDecoration(
                      hintText: 'Enter coupon code',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 14.h,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                SizedBox(
                  height: 46.h,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            final code =
                                couponController.text.trim();
                            if (code.isNotEmpty) {
                              widget.cartController.applyCoupon(code);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffC17D4A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Apply',
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              color: Colors.white,
                            ),
                          ),
                  ),
                )
              ],
            )
          else
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 12.h,
              ),
              decoration: BoxDecoration(
                color: const Color(0xffFFF4E6),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xffC17D4A)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Applied: $appliedCoupon',
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.cartController.clearCoupon,
                    child: Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 20.sp,
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
    });
  }
}
