import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:new_project/User/CartScreen/CartScreen.dart';
import 'package:new_project/User/Home%20Page/Views/ProductsCard.dart';
import 'package:new_project/User/ProductDetailScreen/Models/ProductDetailModel.dart';
import 'package:new_project/User/ProductDetailScreen/Services/ProductController.dart';
import 'package:new_project/User/ProductDetailScreen/Views/RatingBar.dart';
import 'package:new_project/main.dart';
import 'package:new_project/utils.dart';
import 'package:readmore/readmore.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Productcontroller ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = Get.put(Productcontroller(widget.productId), tag: widget.productId);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      Future.delayed(Duration.zero, () {
        if (mounted) ctrl.fetchProduct();
      });
    }
  }

  void showImageOverlay(int initialIndex) {
    if (ctrl.product!.images == null || ctrl.product!.images!.isEmpty) return;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(0),
        child: Stack(
          children: [
            Container(color: Colors.black.withOpacity(0.7)),
            Center(
              child: PageView.builder(
                controller: PageController(initialPage: initialIndex),
                itemCount: ctrl.product!.images!.length,
                itemBuilder: (context, index) {
                  final imgData = ctrl.product!.images![index];
                  return InteractiveViewer(
                    child: Image.network(imgData.url!, fit: BoxFit.contain),
                  );
                },
              ),
            ),
            Positioned(
              top: 40.h,
              right: 20.w,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black54,
                  ),
                  padding: EdgeInsets.all(8.w),
                  child: Icon(Icons.close, color: Colors.white, size: 24.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Products",
          style: GoogleFonts.montserrat(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        foregroundColor: Colors.black,
        actions: [
          GetBuilder<Productcontroller>(
            tag: widget.productId,
            builder: (___) {
              if (___.product == null) return const SizedBox();
              return IconButton(
                onPressed: () => ___.toggleWishlist(),
                icon: ___.isWishlistLoading
                    ? SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: const Color(0xFFAE933F),
                        ),
                      )
                    : Icon(
                        (___.product!.isWishlisted ?? false)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: const Color(0xFFAE933F),
                      ),
              );
            },
          ),
        ],
      ),

      // ── Bottom Bar ──────────────────────────────────────────────────────
      bottomNavigationBar: GetBuilder<Productcontroller>(
        tag: widget.productId,
        builder: (___) {
          if (___.product == null) return const SizedBox();
          return FadeInUp(
            child: Container(
              height: 70.h,
              margin: EdgeInsets.only(bottom: 45.h),
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, -.2),
                    blurRadius: 2,
                    spreadRadius: 1,
                    color: Colors.black12.withOpacity(.1),
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
              ),
              child: Row(
                children: [
                  // Price column
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Price",
                        style: GoogleFonts.montserrat(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "${___.getCurrentPrice()} QAR  ",
                            style: GoogleFonts.montserrat(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          if (___.getCurrentActualPrice() != null)
                            Text(
                              "${___.getCurrentActualPrice()} QAR",
                              style: GoogleFonts.montserrat(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Cart button
                  InkWell(
                    onTap: () {
                      if (login != "IN") {
                        showLoginDialog();
                        return;
                      }
                      if (!___.checkStock()) {
                        Fluttertoast.showToast(msg: "Product is out of stock");
                        return;
                      }
                      // If already in cart → navigate to cart screen
                      // If not → add to cart
                      if (___.isCurrentInCart) {
                        Get.to(
                          () => CartScreen(),
                          transition: Transition.rightToLeft,
                        );
                      } else {
                        ___.addToCart();
                      }
                    },
                    child: Container(
                      width: 180.w,
                      height: 45.h,
                      margin: EdgeInsets.symmetric(horizontal: 10.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        color: const Color(0xFFAE933F),
                      ),
                      child: ___.isCartLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  ___.isCurrentInCart
                                      ? Icons.shopping_cart
                                      : Icons.add_shopping_cart,
                                  color: Colors.white,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  !___.checkStock()
                                      ? "Out of Stock"
                                      : ___.isCurrentInCart
                                      ? "View Cart"
                                      : "Add to Cart",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),

      // ── Body ────────────────────────────────────────────────────────────
      body: SafeArea(
        child: GetBuilder<Productcontroller>(
          tag: widget.productId,
          builder: (___) {
            if (___.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFAE933F)),
              );
            }

            if (___.product == null) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LottieBuilder.asset(
                    "assets/Lotties/NodataFound.json",
                    width: 250.w,
                  ),
                  Text(
                    "No Product Found",
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "Please get back later",
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              );
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Image Carousel ─────────────────────────────────────
                  CarouselSlider(
                    items: [
                      for (int i = 0; i < ___.product!.images!.length; i++)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: GestureDetector(
                              onTap: () => showImageOverlay(i),
                              child: Image.network(
                                ___.product!.images![i].url!,
                                fit: BoxFit.contain,
                                height:
                                    MediaQuery.of(context).size.width * 3 / 4,
                                width: double.infinity,
                              ),
                            ),
                          ),
                        ),
                    ],
                    options: CarouselOptions(
                      autoPlay: true,
                      viewportFraction: 0.9,
                      height: MediaQuery.of(context).size.width * 3 / 4,
                    ),
                  ),

                  SizedBox(height: 25.h),

                  // ── Subcategory + Rating ───────────────────────────────
                  Row(
                    children: [
                      SizedBox(width: 16.w),
                      Text(
                        ___.product!.subCategory!.name,
                        style: GoogleFonts.montserrat(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.star_rounded, color: Colors.amber),
                      Text(
                        (___.product!.reviewStats!.averageRating ?? 0)
                            .toStringAsFixed(1),
                        style: GoogleFonts.montserrat(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(width: 16.w),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // ── Product Name ───────────────────────────────────────
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      ___.product!.name ?? "",
                      style: GoogleFonts.montserrat(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  SizedBox(height: 10.h),

                  // ── Description ────────────────────────────────────────
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      "Product Details",
                      style: GoogleFonts.montserrat(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: ReadMoreText(
                      ___.product!.description ?? "",
                      trimLength: 140,
                      moreStyle: GoogleFonts.montserrat(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFAE933F),
                      ),
                      lessStyle: GoogleFonts.montserrat(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFAE933F),
                      ),
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.montserrat(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  // ── Variations ─────────────────────────────────────────
                  if (___.product!.variations != null &&
                      ___.product!.variations!.isNotEmpty) ...[
                    SizedBox(height: 10.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        "Select ${___.product!.variationTitle ?? "Size"}",
                        style: GoogleFonts.montserrat(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SizedBox(width: 16.w),
                          for (
                            int i = 0;
                            i < ___.product!.variations!.length;
                            i++
                          )
                            GestureDetector(
                              onTap: () => ___.selectVariation(i),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15.w,
                                  vertical: 8.h,
                                ),
                                margin: EdgeInsets.only(right: 10.w),
                                decoration: BoxDecoration(
                                  color: ___.selectedVariationIndex == i
                                      ? const Color(0xFFAE933F)
                                      : Colors.white,
                                  border: Border.all(
                                    color: ___.selectedVariationIndex == i
                                        ? const Color(0xFFAE933F)
                                        : Colors.black12,
                                  ),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      ___
                                              .product!
                                              .variations![i]
                                              .variationName ??
                                          "",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                        color: ___.selectedVariationIndex == i
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                    // Cart badge: shows if this specific
                                    // variation is already in the cart
                                    if (___.cartedKeys.contains(
                                      ___.product!.variations![i].id,
                                    )) ...[
                                      SizedBox(width: 5.w),
                                      Icon(
                                        Icons.shopping_cart_rounded,
                                        size: 13.sp,
                                        color: ___.selectedVariationIndex == i
                                            ? Colors.white
                                            : const Color(0xFFAE933F),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],

                  // ── Related Products ───────────────────────────────────
                  if (___.releatedProducts.isNotEmpty) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        "Products From ${___.product!.subCategory!.category.name}",
                        style: GoogleFonts.montserrat(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: ___.releatedProducts.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.w,
                          mainAxisSpacing: 16.h,
                          childAspectRatio: 0.7,
                        ),
                        itemBuilder: (context, index) {
                          final data = ___.releatedProducts[index];
                          return ProductCard(
                            productId: data.id,
                            category: data.subCategory.name,
                            title: data.name,
                            imageUrl: data.images.first.url,
                            price:
                                double.tryParse(
                                  data.discountedPrice.toString(),
                                ) ??
                                0.0,
                            fullPrice: data.actualPrice != data.discountedPrice
                                ? data.actualPrice.toString()
                                : null,
                          );
                        },
                      ),
                    ),
                  ],

                  // ── Ratings & Reviews ──────────────────────────────────
                  if (___.product!.reviews != null &&
                      ___.product!.reviews!.isNotEmpty) ...[
                    SizedBox(height: 24.h),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        "Ratings & Reviews",
                        style: GoogleFonts.montserrat(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Summary card
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          color: Colors.grey.shade100,
                        ),
                        child: Row(
                          children: [
                            // Average rating column
                            Column(
                              children: [
                                Text(
                                  "${___.product!.reviewStats!.averageRating ?? 0}",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 26.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Row(
                                  children: List.generate(5, (index) {
                                    return Icon(
                                      index >
                                              (___
                                                      .product!
                                                      .reviewStats!
                                                      .averageRating ??
                                                  0)
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.amber,
                                      size: 18.sp,
                                    );
                                  }),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  "${___.product!.reviewStats!.totalReviews ?? 0} reviews",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 11.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(width: 24.w),

                            // Rating distribution bars
                            Expanded(
                              child: Column(
                                children: [
                                  buildRatingBar(
                                    5,
                                    ___
                                            .product!
                                            .reviewStats!
                                            .ratingDistribution
                                            ?.i5 ??
                                        0,
                                    ___,
                                  ),
                                  buildRatingBar(
                                    4,
                                    ___
                                            .product!
                                            .reviewStats!
                                            .ratingDistribution
                                            ?.i4 ??
                                        0,
                                    ___,
                                  ),
                                  buildRatingBar(
                                    3,
                                    ___
                                            .product!
                                            .reviewStats!
                                            .ratingDistribution
                                            ?.i3 ??
                                        0,
                                    ___,
                                  ),
                                  buildRatingBar(
                                    2,
                                    ___
                                            .product!
                                            .reviewStats!
                                            .ratingDistribution
                                            ?.i2 ??
                                        0,
                                    ___,
                                  ),
                                  buildRatingBar(
                                    1,
                                    ___
                                            .product!
                                            .reviewStats!
                                            .ratingDistribution
                                            ?.i1 ??
                                        0,
                                    ___,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Review list
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: ___.product!.reviews!.length,
                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final review = ___.product!.reviews![index];
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Container(
                            padding: EdgeInsets.all(14.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        review.customerProfile?.name ?? "User",
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: List.generate(5, (star) {
                                        return Icon(
                                          star < (review.rating ?? 0)
                                              ? Icons.star
                                              : Icons.star_border,
                                          size: 16.sp,
                                          color: Colors.amber,
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                if (review.comment != null)
                                  Text(
                                    review.comment!,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12.sp,
                                      color: Colors.black87,
                                    ),
                                  ),
                                SizedBox(height: 6.h),
                                Text(
                                  review.createdAt ?? "",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 10.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],

                  SizedBox(height: 30.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
