import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import '../Model/CartModel.dart';
import '../Services/CartController.dart';

class CartProductCard extends StatelessWidget {
  final CartItem cartItem;
  final bool showDivider;

  const CartProductCard({
    super.key,
    required this.cartItem,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final CartController controller = Get.find<CartController>();

    return Obx(() {
      final updatedItem = controller.cart.value?.data.firstWhereOrNull(
        (item) => item.cartKey == cartItem.cartKey,
      );

      if (updatedItem == null) {
        return const SizedBox.shrink();
      }

      final product = updatedItem.product;
      final int qty = updatedItem.qty;

      final bool isOutOfStock =
          product.stockCount == 0 || qty >= product.stockCount;

      final double lineTotal = product.effectivePrice * qty;
      final double actualLineTotal = product.actualPrice * qty;

      return Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 8.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.01),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(10.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: product.images.isNotEmpty
                        ? Image.network(
                            product.images.first.url,
                            height: 85.h,
                            width: 70.w,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 85.h,
                            width: 70.w,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Icon(
                              Icons.image_outlined,
                              color: Colors.grey.shade400,
                              size: 30.sp,
                            ),
                          ),
                  ),

                  SizedBox(width: 10.w),

                  // Product Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                product.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Remove button
                            InkWell(
                              onTap: () => controller.addToIncrement(
                                updatedItem.cartKey,
                                -updatedItem.qty,
                              ),
                              borderRadius: BorderRadius.circular(15.r),
                              child: Padding(
                                padding: EdgeInsets.all(2.w),
                                child: Icon(
                                  Icons.close,
                                  size: 18.sp,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 6.h),

                        // Stock Badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: isOutOfStock
                                ? Colors.red.shade50
                                : Colors.green.shade50,
                            borderRadius: BorderRadius.circular(5.r),
                            border: Border.all(
                              color: isOutOfStock
                                  ? Colors.red.shade200
                                  : Colors.green.shade200,
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            isOutOfStock ? 'Out of Stock' : 'In Stock',
                            style: GoogleFonts.poppins(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w600,
                              color: isOutOfStock
                                  ? Colors.red.shade700
                                  : Colors.green.shade700,
                            ),
                          ),
                        ),

                        SizedBox(height: 8.h),

                        // Price and Quantity Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Price
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'QAR ${lineTotal.toStringAsFixed(0)}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFFAE933F),
                                  ),
                                ),
                                if (product.actualPrice >
                                    product.effectivePrice)
                                  Text(
                                    'QAR ${actualLineTotal.toStringAsFixed(0)}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11.sp,
                                      color: Colors.grey.shade500,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                              ],
                            ),

                            // Quantity Selector
                            Container(
                              height: 28.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () => controller.addToIncrement(
                                      updatedItem.cartKey,
                                      -1,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8.r),
                                      bottomLeft: Radius.circular(8.r),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                      ),
                                      child: Icon(
                                        Icons.remove,
                                        size: 16.sp,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                    ),
                                    child: Text(
                                      '${updatedItem.qty}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: isOutOfStock
                                        ? null
                                        : () => controller.addToIncrement(
                                            updatedItem.cartKey,
                                            1,
                                          ),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(8.r),
                                      bottomRight: Radius.circular(8.r),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        size: 16.sp,
                                        color: isOutOfStock
                                            ? Colors.grey.shade400
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
