import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_project/ProductDetailScreen/Services/ProductController.dart';

Widget buildRatingBar(int star, int count, Productcontroller ctrl) {
  final total = ctrl.product?.reviewStats?.totalReviews ?? 0;

  /// Prevent divide-by-zero
  double percent = 0;

  if (total > 0) {
    percent = count / total;
  }

  /// Extra safety clamp (ensures value between 0-1)
  percent = percent.clamp(0.0, 1.0);

  return Padding(
    padding: EdgeInsets.symmetric(vertical: 2.h),
    child: Row(
      children: [
        Text("$star"),
        SizedBox(width: 4.w),
        Icon(Icons.star, size: 12.sp, color: Colors.amber),
        SizedBox(width: 8.w),

        Expanded(
          child: LinearProgressIndicator(
            value: percent, // ✅ Always safe now
            minHeight: 6.h,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
          ),
        ),

        SizedBox(width: 6.w),
        Text("$count"),
      ],
    ),
  );
}
