import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_project/Wishlist/Model/WishlistProductModel.dart';


class WishlistProductCard extends StatelessWidget {
  const WishlistProductCard({
    super.key,
    required this.wishlistProduct,
    this.onTap,
    this.onMoveToBag,
  });

  final WishlistProduct wishlistProduct;
  final VoidCallback? onTap;
  final VoidCallback? onMoveToBag;

  @override
  Widget build(BuildContext context) {
    final product = wishlistProduct.product;
    if (product == null) return const SizedBox();

  
    final double price =
        double.tryParse(product.discountedPrice) ?? 0;
    final double mrp =
        double.tryParse(product.actualPrice) ?? 0;

    final int discountPercent =
        mrp > price ? (((mrp - price) / mrp) * 100).round() : 0;


    final String imageUrl =
        product.images.isNotEmpty ? product.images.first.url : '';

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isSmall = screenWidth < 360;
        final isTablet = screenWidth > 600;

        final imageSize = isTablet ? 110.0 : isSmall ? 72.0 : 86.0;
        final titleSize = isTablet ? 16.0 : isSmall ? 12.5 : 14.0;
        final priceSize = isTablet ? 18.0 : isSmall ? 14.0 : 16.0;
        final buttonHeight = isTablet ? 38.0 : 32.0;

        return InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(isTablet ? 14 : 10),
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.grey.shade100,
               
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.09),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
             
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: imageSize,
                    height: imageSize,
                    color: const Color(0xFFF6ECFF),
                    child: imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.image_not_supported),
                          )
                        : const Icon(Icons.image_not_supported),
                  ),
                ),

                SizedBox(width: isTablet ? 20 : 14),

             
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF333333),
                        ),
                      ),

                      const SizedBox(height: 6),

                     
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        children: [
                          Text(
                            "QAR ${price.toStringAsFixed(0)}",
                            style: GoogleFonts.montserrat(
                              fontSize: priceSize,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF333333),
                            ),
                          ),
                          if (mrp > price)
                            Text(
                              "QAR ${mrp.toStringAsFixed(0)}",
                              style: GoogleFonts.montserrat(
                                fontSize: priceSize - 4,
                                color: const Color(0xFF9E9E9E),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          if (discountPercent > 0)
                            Text(
                              "$discountPercent% off",
                              style: GoogleFonts.montserrat(
                                fontSize: priceSize - 4,
                                color: const Color(0xFF21A144),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 10),

                    
                      SizedBox(
                        height: buttonHeight,
                        child: ElevatedButton(
                          onPressed: onMoveToBag,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC17D4A),
                            elevation: 0,
                            padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 20 : 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            "Move to Bag",
                            style: GoogleFonts.montserrat(
                              fontSize: isTablet ? 14 : 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
