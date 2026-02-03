import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_project/Wishlist/Model/WishlistProductModel.dart';

class WishlistProductCard extends StatelessWidget {
  final WishlistProduct wishlistProduct;
  final VoidCallback? onTap;
  final VoidCallback? onMoveToBag;

  const WishlistProductCard({
    super.key,
    required this.wishlistProduct,
    this.onTap,
    this.onMoveToBag,
  });

  @override
  Widget build(BuildContext context) {
    final product = wishlistProduct.product;
    if (product == null) return const SizedBox();

    final double price =
        double.tryParse(product.discountedPrice) ?? 0;

    final double mrp =
        double.tryParse(product.actualPrice) ?? 0;

    final bool isOutOfStock = product.stockCount == 0;

    final String imageUrl =
    product.images.isNotEmpty ? product.images.first.url : '';

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: InkWell(
            onTap: onTap,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// SAME IMAGE STYLE AS CART
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                    imageUrl,
                    height: 107.h,
                    width: 92.w,
                    fit: BoxFit.cover,
                  )
                      : Container(
                    height: 107.h,
                    width: 92.w,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image),
                  ),
                ),

                SizedBox(width: 12.w),

                /// SAME DETAILS LAYOUT AS CART
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

                      /// STOCK LABEL (same as cart)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 4.h),
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
                            color: isOutOfStock
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                      ),

                      SizedBox(height: 10.h),

                      /// ⭐ MOVE TO BAG BUTTON (replaces quantity)
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [

                          SizedBox(
                            height: 28.h,
                            child: ElevatedButton(
                              onPressed: onMoveToBag,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                const Color(0xFFC17D4A),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(12.r),
                                ),
                              ),
                              child: Text(
                                "Move to Bag",
                                style: GoogleFonts.poppins(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.end,
                            children: [
                              Text(
                                'QAR ${price.toStringAsFixed(0)}',
                                style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (mrp > price)
                                Text(
                                  'QAR ${mrp.toStringAsFixed(0)}',
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
        ),

        /// SAME DIVIDER AS CART
        Divider(thickness: 0.7, color: Colors.grey.shade300),
      ],
    );
  }
}
