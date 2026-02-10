import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:new_project/CartScreen/CartScreen.dart';
import 'package:new_project/Home%20Page/Views/ProductsCard.dart';
import 'package:new_project/ProductDetailScreen/Models/ProductDetailModel.dart';
import 'package:new_project/ProductDetailScreen/Services/ProductController.dart';
import 'package:new_project/ProductDetailScreen/Views/RatingBar.dart';
import 'package:readmore/readmore.dart';

class ProductDetailScreen extends StatefulWidget {
  String productId;
  ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with RouteAware {
  late Productcontroller ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = Get.put(Productcontroller(widget.productId), tag: widget.productId);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Subscribe to route changes
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      // Refetch when coming back to this screen
      Future.delayed(Duration.zero, () {
        if (mounted) {
          ctrl.fetchProduct();
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
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
              if (___.product == null) return SizedBox();

              return IconButton(
                onPressed: () {
                  ___.toggleWishlist();
                },
                icon: ___.isWishlistLoading
                    ? SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFFAE933F),
                        ),
                      )
                    : Icon(
                        ___.product!.isWishlisted ?? false
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Color(0xFFAE933F),
                      ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: GetBuilder<Productcontroller>(
        tag: widget.productId,
        builder: (___) {
          return (___.product == null)
              ? Container()
              : FadeInUp(
                  child: Container(
                    height: 70.h,
                    margin: EdgeInsets.only(bottom: 45.h),
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, -.2),
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
                              mainAxisAlignment: MainAxisAlignment.center,
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
                        Spacer(),
                        InkWell(
                          onTap: () {
                            if (!(___.product!.isStock ?? false)) {
                              Fluttertoast.showToast(
                                msg: "Product is out of stock",
                              );
                              return;
                            }
                            if (___.product!.isInCart ?? false) {
                              // Navigate to cart page
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
                              color: Color(0xFFAE933F),
                            ),
                            child: ___.isCartLoading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        ___.product!.isInCart ?? false
                                            ? Icons.shopping_cart
                                            : Icons.add_shopping_cart,
                                        color: Colors.white,
                                        size: 20.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        (!(___.product!.isStock ?? false))
                                            ? "Out of Stock"
                                            : ___.product!.isInCart ?? false
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
      body: SafeArea(
        child: GetBuilder<Productcontroller>(
          tag: widget.productId,
          builder: (___) {
            return (ctrl.isLoading)
                ? Center(
                    child: CircularProgressIndicator(color: Color(0xFFAE933F)),
                  )
                : (ctrl.product == null)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LottieBuilder.asset(
                        "assets/Lotties/NodataFound.json",
                        width: 250.w,
                      ),
                      Text(
                        "No Product Founds",
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
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          //  height: 300.h,
                          width: double.infinity,
                          child: CarouselSlider(
                            items: [
                              for (Images img in ctrl.product!.images ?? [])
                                Padding(
                                  padding: EdgeInsetsGeometry.symmetric(
                                    horizontal: 5.w,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      10.r,
                                    ),
                                    child: Image.network(
                                      img.url!!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                                ),
                            ],
                            options: CarouselOptions(
                              autoPlay: true,

                              // height: 20.h,
                              viewportFraction: .9,
                              // enlargeCenterPage: true,
                            ),
                          ),
                        ),
                        SizedBox(height: 25.h),
                        Row(
                          children: [
                            SizedBox(width: 16.w),
                            Text(
                              ctrl.product!.subCategory!.name,
                              style: GoogleFonts.montserrat(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                            ),
                            Spacer(),
                            Icon(Icons.star_rounded, color: Colors.amber),
                            Text(
                              (ctrl.product!.reviewStats!.averageRating ?? 0)
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
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            ctrl.product!.name ?? "",
                            style: GoogleFonts.montserrat(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),

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
                            ctrl.product!.description ?? "",
                            trimLength: 140,
                            moreStyle: GoogleFonts.montserrat(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFAE933F),
                            ),
                            lessStyle: GoogleFonts.montserrat(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFAE933F),
                            ),
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.montserrat(
                              fontSize: 14.sp,

                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        if (___.product!.variations!.isNotEmpty) ...[
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
                                  i < (ctrl.product!.variations ?? []).length;
                                  i++
                                )
                                  GestureDetector(
                                    onTap: () {
                                      ctrl.selectVariation(i);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 15.w,
                                        vertical: 8.h,
                                      ),
                                      margin: EdgeInsets.only(right: 10.w),
                                      decoration: BoxDecoration(
                                        color: ctrl.selectedVariationIndex == i
                                            ? Color(0xFFAE933F)
                                            : Colors.white,
                                        border: Border.all(
                                          color:
                                              ctrl.selectedVariationIndex == i
                                              ? Color(0xFFAE933F)
                                              : Colors.black12,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                      child: Text(
                                        ctrl
                                                .product!
                                                .variations![i]
                                                .variationName ??
                                            "",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              ctrl.selectedVariationIndex == i
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          SizedBox(height: 20.h),

                          if (___.releatedProducts.isNotEmpty) ...[
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Text(
                                "Product From ${ctrl.product!.subCategory!.category.name}",
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
                                physics:
                                    NeverScrollableScrollPhysics(), // Important inside scroll views
                                itemCount: ___.releatedProducts.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, // 2 products per row
                                      crossAxisSpacing: 16.w,
                                      mainAxisSpacing: 16.h,
                                      childAspectRatio:
                                          0.7, // Adjust based on your ProductCard height
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
                                    fullPrice:
                                        data.actualPrice != data.discountedPrice
                                        ? (data.actualPrice).toString()
                                        : null,
                                  );
                                },
                              ),
                            ),
                          ],
                        ],

                        if (ctrl.product?.reviews != null) ...[
                          SizedBox(height: 24.h),

                          /// TITLE
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

                          /// SUMMARY CARD
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
                                  /// AVG RATING
                                  Column(
                                    children: [
                                      Text(
                                        "${ctrl.product!.reviewStats!.averageRating ?? 0}",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 26.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),

                                      SizedBox(height: 6.h),

                                      Row(
                                        children: List.generate(5, (index) {
                                          return Icon(
                                            index <
                                                    (ctrl
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
                                        "${ctrl.product!.reviewStats!.totalReviews ?? 0} reviews",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 11.sp,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(width: 24.w),

                                  /// DISTRIBUTION
                                  Expanded(
                                    child: Column(
                                      children: [
                                        buildRatingBar(
                                          5,
                                          ctrl
                                                  .product!
                                                  .reviewStats!
                                                  .ratingDistribution
                                                  ?.i5 ??
                                              0,
                                          ctrl,
                                        ),
                                        buildRatingBar(
                                          4,
                                          ctrl
                                                  .product!
                                                  .reviewStats!
                                                  .ratingDistribution
                                                  ?.i4 ??
                                              0,
                                          ctrl,
                                        ),
                                        buildRatingBar(
                                          3,
                                          ctrl
                                                  .product!
                                                  .reviewStats!
                                                  .ratingDistribution
                                                  ?.i3 ??
                                              0,
                                          ctrl,
                                        ),
                                        buildRatingBar(
                                          2,
                                          ctrl
                                                  .product!
                                                  .reviewStats!
                                                  .ratingDistribution
                                                  ?.i2 ??
                                              0,
                                          ctrl,
                                        ),
                                        buildRatingBar(
                                          1,
                                          ctrl
                                                  .product!
                                                  .reviewStats!
                                                  .ratingDistribution
                                                  ?.i1 ??
                                              0,
                                          ctrl,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 20.h),

                          /// REVIEW LIST
                          ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: ctrl.product!.reviews?.length ?? 0,
                            separatorBuilder: (_, __) => SizedBox(height: 12.h),
                            itemBuilder: (context, index) {
                              final review = ctrl.product!.reviews![index];

                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Container(
                                  padding: EdgeInsets.all(14.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /// NAME + STARS
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              review.customerProfile?.name ??
                                                  "User",
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

                                      /// COMMENT
                                      if (review.comment != null)
                                        Text(
                                          review.comment!,
                                          style: GoogleFonts.montserrat(
                                            fontSize: 12.sp,
                                            color: Colors.black87,
                                          ),
                                        ),

                                      SizedBox(height: 6.h),

                                      /// DATE
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
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }
}
