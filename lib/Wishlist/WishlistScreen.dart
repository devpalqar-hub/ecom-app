import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_project/CartScreen/Services/CartController.dart';
import 'package:new_project/Home%20Page/ProducrDetailPage.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Wishlist',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            fontFamily: "Inter",
          ),
        ),
      ),
      body: Obx(() {
        if (wishlistController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final filteredWishlist = wishlistController.filteredWishlist;

      if (filteredWishlist.isEmpty) {
  return _emptyWishlistView();
}


        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                itemCount: filteredWishlist.length + 1,
                itemBuilder: (context, index) {
                  if (index < filteredWishlist.length) {
                    final wishlistItem = filteredWishlist[index];
                    final product = wishlistItem.product;
                    if (product == null) return const SizedBox();

                    return Column(
                      children: [
                        WishlistProductCard(
                          wishlistProduct: wishlistItem,
                          onTap: () => Get.to(
                            () => ProductDetailScreen(productId: product.id),
                          ),
                          onMoveToBag: () async {
                            if (product.stockCount > 0) {
                              await cartController.addToCart(
                                productId: product.id,
                                quantity: 1,
                                productVariationId:
                                    wishlistItem.productVariationId,
                              );
                              wishlistController
                                  .removeFromWishlist(wishlistItem.wishlistId);
                              Get.snackbar(
                                "Added to Cart",
                                "${product.name} added successfully",
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            } else {
                              Get.snackbar(
                                "Out of Stock",
                                "${product.name} is out of stock",
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          },
                        ),
                        SizedBox(height: 16.h),
                      ],
                    );
                  } else {
                  
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: SizedBox(
                        width: double.infinity,
                        height: 45.h,
                        child: ElevatedButton(
                          onPressed: () async {
                            bool anyOutOfStock = false;

                            for (var item in filteredWishlist) {
                              final product = item.product;
                              if (product != null && product.stockCount > 0) {
                                await cartController.addToCart(
                                  productId: product.id,
                                  quantity: 1,
                                  productVariationId: item.productVariationId,
                                );
                                wishlistController
                                    .removeFromWishlist(item.wishlistId);
                              } else {
                                anyOutOfStock = true;
                              }
                            }

                            if (anyOutOfStock) {
                              Get.snackbar(
                                "Notice",
                                "Some items were out of stock",
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC17D4A),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                          ),
                          child: Text(
                            "Move All to Bag",
                            style: GoogleFonts.montserrat(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _emptyWishlistView() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.favorite_border,
          size: 90.sp,
          color: Colors.grey.shade400,
        ),
        SizedBox(height: 16.h),
        Text(
          'Your wishlist is empty',
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'Save items you love to view them later',
          style: GoogleFonts.poppins(
            fontSize: 13.sp,
            color: Colors.grey.shade500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

}
