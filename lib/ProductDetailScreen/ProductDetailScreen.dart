import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:new_project/Home%20Page/Views/ProductsCard.dart';
import 'package:new_project/ProductDetailScreen/Models./ProductDetailModel.dart';
import 'package:new_project/ProductDetailScreen/Services/ProductController.dart';
import 'package:readmore/readmore.dart';

class ProductDetailScreen extends StatefulWidget {
  String productId;
  ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Productcontroller ctrl;

  @override
  Widget build(BuildContext context) {
    ctrl = Get.put(Productcontroller(widget.productId), tag: widget.productId);

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
                            scrollDirection: Axis.vertical,
                            child: Row(
                              children: [
                                SizedBox(width: 16.w),
                                for (Variations data
                                    in ctrl.product!.variations ?? [])
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 3.h,
                                    ),
                                    margin: EdgeInsets.only(right: 10.w),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black12),
                                      borderRadius: BorderRadius.circular(5.w),
                                    ),
                                    child: Text(data.variationName ?? ""),
                                  ),
                              ],
                            ),
                          ),

                          SizedBox(height: 20.h),
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
                          if (___.releatedProducts.isNotEmpty) ...[
                            SizedBox(height: 20.h),

                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              width: double.infinity,
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                alignment: WrapAlignment.center,
                                // runAlignment: WrapAlignment.spaceAround,
                                spacing: 28.w,
                                runSpacing: 10.h,
                                children: [
                                  for (var data in ___.releatedProducts)
                                    ProductCard(
                                      productId: data.id,
                                      category: data.subCategory.name,
                                      title: data.name,
                                      imageUrl: data.images.first.url,
                                      price: data.discountedPrice,
                                    ),
                                ],
                              ),
                            ),
                          ],
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
