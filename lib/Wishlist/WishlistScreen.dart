import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_project/CartScreen/Services/CartController.dart';
import 'package:new_project/ProductDetailScreen/ProductDetailScreen.dart';
import 'package:new_project/Wishlist/Service/WishlistController.dart';
import 'package:new_project/Wishlist/Views/WishlistProductCard.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlistController = Get.put(WishlistController());
    final cartController = Get.put(CartController());

    wishlistController.fetchWishlist();

    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: ()
          {
            Navigator.pop(context);
          },
        ),
        title: Text(

          "My Wishlist",
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: Obx(() {
        if (wishlistController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: Color(0xFFAEAC3F)),
          );
        }

        final filteredWishlist = wishlistController.filteredWishlist;

        if (filteredWishlist.isEmpty) {
          return _emptyWishlistView();
        }

        return Column(
          children: [
            // Header with count
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  Text(
                    '${filteredWishlist.length} ${filteredWishlist.length == 1 ? 'item' : 'items'}',
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),

            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
                itemCount: filteredWishlist.length,
                separatorBuilder: (_, __) => SizedBox(height: 5.h),
                itemBuilder: (context, index) {
                  final wishlistItem = filteredWishlist[index];
                  final product = wishlistItem.product;
                  if (product == null) return const SizedBox();

                  return WishlistProductCard(
                    wishlistProduct: wishlistItem,
                    onTap: () => Get.to(
                      () => ProductDetailScreen(productId: product.id),
                    ),
                    onRemove: () {
                      wishlistController.removeFromWishlist(
                        wishlistItem.wishlistId,
                      );
                    },
                    onMoveToBag: () async {
                      if (product.stockCount > 0) {
                        await cartController.addToCart(
                          productId: product.id,
                          quantity: 1,
                          productVariationId: wishlistItem.productVariationId,
                        );
                        wishlistController.removeFromWishlist(
                          wishlistItem.wishlistId,
                        );
                        Get.snackbar(
                          "Added to Cart",
                          "${product.name} added successfully",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green.shade100,
                          colorText: Colors.green.shade900,
                        );
                      } else {
                        Get.snackbar(
                          "Out of Stock",
                          "${product.name} is out of stock",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red.shade100,
                          colorText: Colors.red.shade900,
                        );
                      }
                    },
                  );
                },
              ),
            ),

            // Bottom Move All Button
            // if (filteredWishlist.isNotEmpty)
            //   Container(
            //     color: Colors.white,
            //     padding: EdgeInsets.all(16.w),
            //     child: SafeArea(
            //       top: false,
            //       child: SizedBox(
            //         width: double.infinity,
            //         height: 50.h,
            //         child: ElevatedButton(
            //           onPressed: () async {
            //             bool anyOutOfStock = false;
            //             int addedCount = 0;

            //             for (var item in filteredWishlist) {
            //               final product = item.product;
            //               if (product != null && product.stockCount > 0) {
            //                 await cartController.addToCart(
            //                   productId: product.id,
            //                   quantity: 1,
            //                   productVariationId: item.productVariationId,
            //                 );
            //                 wishlistController.removeFromWishlist(
            //                   item.wishlistId,
            //                 );
            //                 addedCount++;
            //               } else {
            //                 anyOutOfStock = true;
            //               }
            //             }

            //             if (addedCount > 0) {
            //               Get.snackbar(
            //                 "Success",
            //                 "$addedCount ${addedCount == 1 ? 'item' : 'items'} moved to cart",
            //                 snackPosition: SnackPosition.BOTTOM,
            //                 backgroundColor: Colors.green.shade100,
            //                 colorText: Colors.green.shade900,
            //               );
            //             }

            //             if (anyOutOfStock) {
            //               Get.snackbar(
            //                 "Notice",
            //                 "Some items were out of stock",
            //                 snackPosition: SnackPosition.BOTTOM,
            //                 backgroundColor: Colors.orange.shade100,
            //                 colorText: Colors.orange.shade900,
            //               );
            //             }
            //           },
            //           style: ElevatedButton.styleFrom(
            //             backgroundColor: Color(0xFFAE933F),
            //             foregroundColor: Colors.white,
            //             elevation: 0,
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(12.r),
            //             ),
            //           ),
            //           child: Text(
            //             "Move All to Cart",
            //             style: GoogleFonts.poppins(
            //               fontSize: 16.sp,
            //               fontWeight: FontWeight.w600,
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
          ],
        );
      }),
    );
  }

  Widget _emptyWishlistView() {
    
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Color(0xFFFFF4E6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_outline,
                size: 80.sp,
                color: Color(0xFFAE933F),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Your Wishlist is Empty',
              style: GoogleFonts.poppins(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Save items you love by tapping the\nheart icon on products',
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
