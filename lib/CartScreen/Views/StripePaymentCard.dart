import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class StripePaymentCard extends StatelessWidget {
  const StripePaymentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [

          Container(
            height: 48.w,
            width: 48.w,
            decoration: BoxDecoration(
              color: const Color(0xff635BFF).withOpacity(0.12),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Center(
              child: Image.asset(
                'assets/icons/stripe.png',
                height: 26.h,
                fit: BoxFit.contain,
              ),
            ),
          ),

          SizedBox(width: 14.w),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Stripe",
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                "Credit / Debit Card, UPI, Net Banking",
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
