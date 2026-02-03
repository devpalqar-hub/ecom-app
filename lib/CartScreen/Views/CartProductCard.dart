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
      final updatedItem = controller.cart.value?.data
          .firstWhereOrNull((item) => item.cartKey == cartItem.cartKey);

      if (updatedItem == null || updatedItem.product == null) {
        return const SizedBox.shrink();
      }

      final product = updatedItem.product!;
      final int qty = updatedItem.qty;

      final bool isOutOfStock =
          product.stockCount == 0 || qty >= product.stockCount;

      final double lineTotal = product.effectivePrice * qty;
      final double actualLineTotal = product.actualPrice * qty;

      return Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: product.images.isNotEmpty
                      ? Image.network(
                          product.images.first.url,
                          height: 107.h,
                          width: 92.w,
                          fit: BoxFit.cover,
                        )
                      : _imagePlaceholder(),
                ),

                SizedBox(width: 12.w),

                /// DETAILS
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: GoogleFonts.poppins(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 6.h),

                      _stockStatusLabel(isOutOfStock),

                      SizedBox(height: 10.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _quantitySelector(
                            controller: controller,
                            item: updatedItem,
                            isOutOfStock: isOutOfStock,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'QAR ${lineTotal.toStringAsFixed(0)}',
                                style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (product.actualPrice >
                                  product.effectivePrice)
                                Text(
                                  'QAR ${actualLineTotal.toStringAsFixed(0)}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.sp,
                                    color: Colors.grey,
                                    decoration:
                                        TextDecoration.lineThrough,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (showDivider)
            Divider(thickness: 0.7, color: Colors.grey.shade300),
        ],
      );
    });
  }

  Widget _imagePlaceholder() => Container(
        height: 107.h,
        width: 92.w,
        color: Colors.grey.shade200,
        child: const Icon(Icons.image),
      );

  Widget _stockStatusLabel(bool isOutOfStock) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isOutOfStock
            ? Colors.red.withOpacity(0.12)
            : Colors.green.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        isOutOfStock ? 'Out of Stock' : 'In Stock',
        style: GoogleFonts.poppins(
          fontSize: 11.sp,
          color: isOutOfStock ? Colors.red : Colors.green,
        ),
      ),
    );
  }

  Widget _quantitySelector({
    required CartController controller,
    required CartItem item,
    required bool isOutOfStock,
  }) {
    return Container(
      width: 100.w,
      height: 28.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xffE8ECF4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () => controller.addToIncrement(item.cartKey, -1),
            child: const Icon(Icons.remove, size: 18),
          ),
          Text('${item.qty}', style: GoogleFonts.poppins(fontSize: 13.sp)),
          InkWell(
            onTap: isOutOfStock
                ? null
                : () => controller.addToIncrement(item.cartKey, 1),
            child: Icon(
              Icons.add,
              size: 18,
              color: isOutOfStock ? Colors.grey : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
