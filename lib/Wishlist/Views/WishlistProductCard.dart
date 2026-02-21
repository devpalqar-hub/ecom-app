import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_project/Wishlist/Model/WishlistProductModel.dart';

class WishlistProductCard extends StatelessWidget {
  final WishlistProduct wishlistProduct;
  final VoidCallback? onTap;
  final VoidCallback? onMoveToBag;
  final VoidCallback? onRemove;

  const WishlistProductCard({
    super.key,
    required this.wishlistProduct,
    this.onTap,
    this.onMoveToBag,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final product = wishlistProduct.product;
    if (product == null) return const SizedBox();

    final double price = double.tryParse(product.discountedPrice) ?? 0;
    final double mrp = double.tryParse(product.actualPrice) ?? 0;
    final bool isOutOfStock = product.stockCount == 0;
    final String imageUrl = product.images.isNotEmpty
        ? product.images.first.url
        : '';

    return Container(
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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(10.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
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
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Remove button
                        InkWell(
                          onTap: onRemove,
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

                    // Price
                    Row(
                      children: [
                        Text(
                          'QAR ${price.toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFAE933F),
                          ),
                        ),
                        if (mrp > price) ...[
                          SizedBox(width: 6.w),
                          Text(
                            'QAR ${mrp.toStringAsFixed(0)}',
                            style: GoogleFonts.poppins(
                              fontSize: 11.sp,
                              color: Colors.grey.shade500,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                        Spacer(),
                        SizedBox(
                          height: 32.h,
                          child: ElevatedButton.icon(
                            onPressed: isOutOfStock ? null : onMoveToBag,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFAE933F),
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey.shade300,
                              disabledForegroundColor: Colors.grey.shade600,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                            ),
                            // icon: Icon(
                            //   Icons.shopping_bag_outlined,
                            //   size: 14.sp,
                            // ),
                            label: Text(
                              "Move to Cart",
                              style: GoogleFonts.poppins(
                                fontSize: 9.5.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8.h),

                    // Move to Bag Button
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
