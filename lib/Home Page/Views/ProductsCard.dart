import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_project/CartScreen/Services/CartController.dart';
import 'package:new_project/ProductDetailScreen/ProductDetailScreen.dart';

class ProductCard extends StatelessWidget {
  final String productId;
  final String category;
  final String title;
  final String imageUrl;
  final double price;
  final String? productVariationId;
  final String? fullPrice;

  const ProductCard({
    super.key,
    required this.productId,
    required this.category,
    required this.title,
    required this.imageUrl,
    required this.price,
    this.productVariationId,
    this.fullPrice = "",
  });

  @override
  Widget build(BuildContext context) {
    // final CartController cartController = Get.find<CartController>();

    return GestureDetector(
      onTap: () {
        Get.to(
          () => ProductDetailScreen(productId: productId),
          transition: Transition.rightToLeft,
          preventDuplicates: false,
        );
      },

      child: SizedBox(
        width: 160.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: imageUrl.isEmpty ? Colors.grey.shade300 : null,
                  image: imageUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: imageUrl.isEmpty
                    ? Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey.shade700,
                          size: 24.sp,
                        ),
                      )
                    : null,
              ),
            ),

            SizedBox(height: 6.h),

            Text(
              category.toUpperCase(),
              style: TextStyle(
                color: Colors.grey,
                fontSize: 8.sp,
                letterSpacing: 1.1,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: 4.h),

            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
            ),

            SizedBox(height: 2.h),

            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "QAR ${price.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 11.sp,
                    color: Color(0xffC68E56),
                  ),
                ),
                SizedBox(width: 5.w),

                if (fullPrice != "")
                  Text(
                    "QAR ${fullPrice}",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 9.sp,
                      decoration: TextDecoration.lineThrough,
                      color: Colors.black26,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
