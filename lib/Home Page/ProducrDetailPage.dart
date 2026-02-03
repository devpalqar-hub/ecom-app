// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

// import 'package:new_project/CartScreen/Services/CartController.dart';
// import 'package:new_project/Home Page/Service/ProductController.dart';
// import 'package:new_project/Home Page/Model/ProductDetailModel.dart';
// import 'package:new_project/Home%20Page/Model/ProdutModel.dart'
//     hide ProductImage;
// import 'package:new_project/Home%20Page/Views/ProductImageCarousel.dart';
// import 'package:new_project/Home%20Page/Views/ProductsCard.dart';
// import 'package:new_project/Wishlist/Service/WishlistController.dart';

// class ProductDetailPage1 extends StatefulWidget {
//   final String productId;
//   ProductDetailPage({super.key, required this.productId});

//   @override
//   State<ProductDetailPage> createState() => _ProductDetailPageState();
// }

// class _ProductDetailPageState extends State<ProductDetailPage> {
//   final ProductController productController = Get.find<ProductController>();
//   final CartController cartController = Get.put(CartController());
//   final WishlistController wishlistController = Get.put(WishlistController());

//   int selectedVariationIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     fetchProduct();
//   }

//   void fetchProduct() {
//     productController.productDetail.value = null;
//     productController.fetchProductDetail(widget.productId);
//   }

//   void navigateToProduct(String productId) {
//     Future.delayed(Duration.zero, () {
//       Get.to(() => ProductDetailPage(productId: productId));
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(375, 812),
//       builder: (_, __) => Scaffold(
//         backgroundColor: Colors.white,
//         body: SafeArea(
//           child: Obx(() {
//             if (productController.isLoadingProductDetail.value) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             final ProductDetailModel? product =
//                 productController.productDetail.value;

//             if (product == null) {
//               return const Center(child: Text("Product not found"));
//             }

//             final variations = product.variations;
//             final selectedVariation = variations.isNotEmpty
//                 ? variations[selectedVariationIndex]
//                 : null;

//             final double price =
//                 selectedVariation?.price ?? product.discountedPrice;

//             final bool isWishlisted = wishlistController.isProductWishlisted(
//               product.id,
//             );

//             return Stack(
//               children: [
//                 Padding(
//                   padding: EdgeInsets.only(bottom: 80.h),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         ProductImagesCarousel(images: product.images),
//                         SizedBox(height: 16.h),

//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 16.w),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 product.name,
//                                 style: GoogleFonts.montserrat(
//                                   fontSize: 18.sp,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               SizedBox(height: 6.h),
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     "QAR ${price.toStringAsFixed(0)}",
//                                     style: GoogleFonts.montserrat(
//                                       fontSize: 20.sp,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   SizedBox(width: 8.w),

//                                   if (product.actualPrice > price)
//                                     Text(
//                                       "QAR ${product.actualPrice.toStringAsFixed(0)}",
//                                       style: GoogleFonts.montserrat(
//                                         fontSize: 14.sp,
//                                         color: Colors.grey,
//                                         decoration: TextDecoration.lineThrough,
//                                       ),
//                                     ),

//                                   SizedBox(width: 15.w),

//                                   if (product.actualPrice > price)
//                                     Container(
//                                       padding: EdgeInsets.symmetric(
//                                         horizontal: 8.w,
//                                         vertical: 3.h,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         color: Colors.green.shade100,
//                                         borderRadius: BorderRadius.circular(
//                                           6.r,
//                                         ),
//                                       ),
//                                       child: Text(
//                                         "${(((product.actualPrice - price) / product.actualPrice) * 100).round()}% OFF",
//                                         style: GoogleFonts.montserrat(
//                                           fontSize: 11.sp,
//                                           fontWeight: FontWeight.w600,
//                                           color: Colors.green.shade800,
//                                         ),
//                                       ),
//                                     ),
//                                   SizedBox(width: 15.w),
//                                   Icon(
//                                     Icons.star,
//                                     color: Colors.amber,
//                                     size: 16.sp,
//                                   ),
//                                   SizedBox(width: 5.w),
//                                   Text(
//                                     product.reviewStats.averageRating
//                                         .toStringAsFixed(1),
//                                     style: GoogleFonts.montserrat(
//                                       fontSize: 13.sp,
//                                     ),
//                                   ),
//                                   SizedBox(width: 4.w),
//                                   Text(
//                                     "(${product.reviewStats.totalReviews})",
//                                     style: GoogleFonts.montserrat(
//                                       fontSize: 12.sp,
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                 ],
//                               ),

//                               SizedBox(height: 12.h),

//                               Text(
//                                 product.description,
//                                 style: GoogleFonts.montserrat(
//                                   fontSize: 13.sp,
//                                   color: Colors.black54,
//                                 ),
//                               ),
//                               SizedBox(height: 24.h),
//                             ],
//                           ),
//                         ),

//                         if (variations.isNotEmpty) ...[
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 16.w),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Wrap(
//                                   spacing: 10.w,
//                                   runSpacing: 10.h,
//                                   children: List.generate(variations.length, (
//                                     index,
//                                   ) {
//                                     final v = variations[index];
//                                     final isSelected =
//                                         selectedVariationIndex == index;

//                                     return GestureDetector(
//                                       onTap: () {
//                                         setState(() {
//                                           selectedVariationIndex = index;
//                                         });
//                                       },
//                                       child: Container(
//                                         padding: EdgeInsets.symmetric(
//                                           horizontal: 16.w,
//                                           vertical: 8.h,
//                                         ),
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(
//                                             20.r,
//                                           ),
//                                           color: isSelected
//                                               ? const Color(0xffC17D4A)
//                                               : Colors.white,
//                                           border: Border.all(
//                                             color: isSelected
//                                                 ? const Color(0xffC17D4A)
//                                                 : Colors.grey.shade300,
//                                           ),
//                                         ),
//                                         child: Text(
//                                           v.variationName,
//                                           style: GoogleFonts.montserrat(
//                                             fontSize: 12.sp,
//                                             fontWeight: FontWeight.w500,
//                                             color: isSelected
//                                                 ? Colors.white
//                                                 : Colors.black,
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   }),
//                                 ),
//                                 SizedBox(height: 24.h),
//                               ],
//                             ),
//                           ),
//                         ],

//                         if (product.reviews.isNotEmpty) ...[
//                           Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   " Reviews and Ratings",
//                                   style: GoogleFonts.montserrat(
//                                     fontSize: 16.sp,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),

//                                 SizedBox(height: 12.h),

//                                 ListView.separated(
//                                   shrinkWrap: true,
//                                   physics: NeverScrollableScrollPhysics(),
//                                   itemCount: product.reviews.length,
//                                   separatorBuilder: (_, __) =>
//                                       SizedBox(height: 0.h),
//                                   itemBuilder: (_, index) {
//                                     final review = product.reviews[index];
//                                     return Container(
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius: BorderRadius.circular(
//                                           12.r,
//                                         ),
//                                         border: Border.all(
//                                           color: Colors.grey.shade300,
//                                           width: 1,
//                                         ),
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: Colors.grey.withOpacity(0.1),
//                                             spreadRadius: 1,
//                                             blurRadius: 6,
//                                             offset: Offset(0, 3),
//                                           ),
//                                         ],
//                                       ),
//                                       margin: EdgeInsets.symmetric(
//                                         vertical: 6.h,
//                                         horizontal: 0.w,
//                                       ),
//                                       padding: EdgeInsets.all(12.w),
//                                       child: Row(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           CircleAvatar(
//                                             radius: 18.r,
//                                             backgroundColor: Colors.black,
//                                             child: Text(
//                                               // Take first letter of name, fallback to "C" for "Customer"
//                                               (review
//                                                           .customerProfile
//                                                           .name
//                                                           ?.isNotEmpty ??
//                                                       false)
//                                                   ? review.customerProfile.name!
//                                                         .substring(0, 1)
//                                                         .toUpperCase()
//                                                   : "C",
//                                               style: GoogleFonts.montserrat(
//                                                 fontSize: 14.sp,
//                                                 fontWeight: FontWeight.w600,
//                                                 color: Colors.white,
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(width: 12.w),
//                                           Expanded(
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(
//                                                   review.customerProfile.name ??
//                                                       "Customer",
//                                                   style: GoogleFonts.montserrat(
//                                                     fontSize: 13.sp,
//                                                     fontWeight: FontWeight.w600,
//                                                   ),
//                                                 ),
//                                                 SizedBox(height: 4.h),
//                                                 Row(
//                                                   children: List.generate(
//                                                     5,
//                                                     (i) => Icon(
//                                                       i < review.rating
//                                                           ? Icons.star
//                                                           : Icons.star_border,
//                                                       size: 14.sp,
//                                                       color: Colors.amber,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 if (review
//                                                     .comment
//                                                     .isNotEmpty) ...[
//                                                   SizedBox(height: 6.h),
//                                                   Text(
//                                                     review.comment,
//                                                     style:
//                                                         GoogleFonts.montserrat(
//                                                           fontSize: 12.sp,
//                                                           color: Colors.black54,
//                                                         ),
//                                                   ),
//                                                 ],
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 10.h),
//                         ],

//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 16.w),
//                           child: FutureBuilder<List<ProductModel>>(
//                             future: productController.fetchRelatedProducts(
//                               product,
//                             ),
//                             builder: (_, snapshot) {
//                               if (snapshot.connectionState ==
//                                   ConnectionState.waiting) {
//                                 return const Center(
//                                   child: CircularProgressIndicator(),
//                                 );
//                               }

//                               final relatedProducts = snapshot.data ?? [];
//                               if (relatedProducts.isEmpty) {
//                                 return const SizedBox();
//                               }

//                               return Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     "Related Products",
//                                     style: GoogleFonts.montserrat(
//                                       fontSize: 16.sp,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                   SizedBox(height: 12.h),
//                                   GridView.builder(
//                                     shrinkWrap: true,
//                                     physics:
//                                         const NeverScrollableScrollPhysics(),
//                                     itemCount: relatedProducts.length,
//                                     gridDelegate:
//                                         SliverGridDelegateWithFixedCrossAxisCount(
//                                           crossAxisCount: 2,
//                                           mainAxisSpacing: 12.h,
//                                           crossAxisSpacing: 12.w,
//                                           childAspectRatio: 0.65,
//                                         ),
//                                     itemBuilder: (_, index) {
//                                       final p = relatedProducts[index];
//                                       final variation = p.variations.isNotEmpty
//                                           ? p.variations.first
//                                           : null;

//                                       return GestureDetector(
//                                         onTap: () {
//                                           navigateToProduct(p.id);
//                                         },
//                                         child: ProductCard(
//                                           productId: p.id,
//                                           category: p.subCategory.name,
//                                           title: p.name,
//                                           imageUrl: p.images.isNotEmpty
//                                               ? p.images.first.url
//                                               : '',
//                                           price:
//                                               variation?.price ??
//                                               p.discountedPrice,
//                                           productVariationId: variation?.id,
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ],
//                               );
//                             },
//                           ),
//                         ),
//                         SizedBox(height: 80.h),
//                       ],
//                     ),
//                   ),
//                 ),

//                 Positioned(
//                   top: 12.h,
//                   left: 12.w,
//                   child: GestureDetector(
//                     onTap: () => Get.back(),
//                     child: Container(
//                       height: 35.h,
//                       width: 35.h,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.grey.shade300,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.25),
//                             blurRadius: 8,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: const Center(
//                         child: Icon(
//                           Icons.arrow_back_ios_new,
//                           size: 18,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),

//                 Positioned(
//                   bottom: 0,
//                   left: 0,
//                   right: 0,
//                   child: Container(
//                     color: Colors.white,
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 16.w,
//                       vertical: 10.h,
//                     ),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: OutlinedButton.icon(
//                             onPressed: () async {
//                               if (isWishlisted) {
//                                 final item = wishlistController.wishlistItems
//                                     .firstWhere(
//                                       (e) =>
//                                           e.productVariationId ==
//                                               selectedVariation?.id ||
//                                           e.productId == product.id,
//                                     );
//                                 await wishlistController.removeFromWishlist(
//                                   item.wishlistId,
//                                 );
//                               } else {
//                                 await wishlistController.addToWishlist(
//                                   productId: selectedVariation == null
//                                       ? product.id
//                                       : null,
//                                   productVariationId: selectedVariation?.id,
//                                 );
//                               }
//                             },
//                             icon: Icon(
//                               isWishlisted
//                                   ? Icons.favorite
//                                   : Icons.favorite_border,
//                               color: const Color(0xffC17D4A),
//                             ),
//                             label: Text(
//                               isWishlisted ? "Wishlisted" : "Wishlist",
//                               style: GoogleFonts.montserrat(
//                                 fontSize: 13.sp,
//                                 color: const Color(0xffC17D4A),
//                               ),
//                             ),
//                             style: OutlinedButton.styleFrom(
//                               side: const BorderSide(color: Color(0xffC17D4A)),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(20.r),
//                               ),
//                               padding: EdgeInsets.symmetric(vertical: 12.h),
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 12.w),
//                         Expanded(
//                           child: Obx(() {
//                             final bool inCart = productController
//                                 .isProductInCart(
//                                   productId: product.id,
//                                   productVariationId: selectedVariation?.id,
//                                 );

//                             return ElevatedButton(
//                               onPressed: cartController.isLoading.value
//                                   ? null
//                                   : () async {
//                                       if (inCart) {
//                                         final cartItem = cartController
//                                             .cart
//                                             .value
//                                             ?.data
//                                             .firstWhereOrNull(
//                                               (e) =>
//                                                   e.productVariationId ==
//                                                       selectedVariation?.id ||
//                                                   e.productId == product.id,
//                                             );

//                                         if (cartItem != null) {
//                                           await cartController.removeFromCart(
//                                             cartItem.id,
//                                             cartItem.quantity,
//                                           );
//                                           Get.snackbar(
//                                             "Removed from Cart",
//                                             "Product removed successfully",
//                                             snackPosition: SnackPosition.BOTTOM,
//                                           );
//                                         }
//                                       } else {
//                                         // ADD TO CART
//                                         await cartController.addToCart(
//                                           productId: product.id,
//                                           quantity: 1,
//                                           productVariationId:
//                                               selectedVariation?.id,
//                                         );
//                                         Get.snackbar(
//                                           "Added to Cart",
//                                           "Product added successfully",
//                                           snackPosition: SnackPosition.BOTTOM,
//                                         );
//                                       }
//                                     },
//                               style: inCart
//                                   ? OutlinedButton.styleFrom(
//                                       side: BorderSide(
//                                         color: Color(0xffC17D4A),
//                                       ),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(
//                                           20.r,
//                                         ),
//                                       ),
//                                       padding: EdgeInsets.symmetric(
//                                         vertical: 12.h,
//                                       ),
//                                     )
//                                   : ElevatedButton.styleFrom(
//                                       backgroundColor: const Color(0xffC17D4A),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(
//                                           20.r,
//                                         ),
//                                       ),
//                                       padding: EdgeInsets.symmetric(
//                                         vertical: 12.h,
//                                       ),
//                                     ),
//                               child: cartController.isLoading.value
//                                   ? const CircularProgressIndicator(
//                                       color: Colors.white,
//                                     )
//                                   : Text(
//                                       inCart ? "Remove from Bag" : "Add to Bag",
//                                       style: GoogleFonts.montserrat(
//                                         fontSize: 14.sp,
//                                         color: inCart
//                                             ? const Color(0xffC17D4A)
//                                             : Colors.white,
//                                       ),
//                                     ),
//                             );
//                           }),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }
