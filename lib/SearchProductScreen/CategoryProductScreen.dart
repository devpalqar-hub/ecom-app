import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'package:new_project/Home%20Page/Service/ProductController.dart';
import 'package:new_project/Home%20Page/Views/ProductsCard.dart';
import 'package:new_project/SearchProductScreen/FilterBottomSheet.dart';
import 'package:new_project/SearchProductScreen/Services/SearchProductController.dart';

class SearchProductScreen extends StatelessWidget {
  final String categoryId;

  SearchProductScreen({super.key, this.categoryId = ""});

  Searchproductcontroller searchProduct = Get.put(Searchproductcontroller());

  @override
  Widget build(BuildContext context) {
    searchProduct.loadInit(categoryID: categoryId);
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
        child: GetBuilder<Searchproductcontroller>(
          builder: (__) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: __.searchText,
                            onSubmitted: (value) {
                              __.fetchProducts();
                            },
                            decoration: InputDecoration(
                              hintText: "Search products...",
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 0.h,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),

                        InkWell(
                          onTap: () {
                            Get.bottomSheet(SearchFilterBottomSheet());
                          },
                          borderRadius: BorderRadius.circular(10.r),
                          child: Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: const Icon(
                              Icons.filter_list,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (categoryId == "") ...[
                    SizedBox(height: 10.h),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SizedBox(width: 20.h),

                          for (var data in __.categories)
                            InkWell(
                              onTap: () {
                                if (__.selectedCategory != null &&
                                    __.selectedCategory!.id == data.id) {
                                  __.selectedCategory = null;
                                  __.subCategories = [];
                                  __.selectedSubCategoryId = null;
                                  __.update();
                                  __.fetchProducts();
                                } else
                                  __.selectedCategory = data;
                                __.update();
                                __.fetchProducts();
                                __.subCategories = [];
                                __.selectedSubCategoryId = null;
                                __.fetchSubCategories(__.selectedCategory!.id);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.w,
                                  vertical: 3.h,
                                ),
                                margin: EdgeInsets.only(right: 10.w),
                                decoration: BoxDecoration(
                                  color:
                                      (__.selectedCategory != null &&
                                          __.selectedCategory!.id == data.id)
                                      ? Color(0xFFAE933F)
                                      : null,
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(color: Colors.black26),
                                ),
                                child: Text(
                                  data.name,
                                  style: TextStyle(
                                    color:
                                        (__.selectedCategory != null &&
                                            __.selectedCategory!.id == data.id)
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],

                  SizedBox(height: 10.h),

                  GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: __.products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20.h,
                      crossAxisSpacing: 12.w,
                      childAspectRatio: 0.72,
                    ),
                    itemBuilder: (context, index) {
                      final data = __.products[index];

                      return ProductCard(
                        productId: data.id,
                        category: data.subCategory.name,
                        title: data.name,
                        imageUrl: (data.images == null || data.images.isEmpty)
                            ? ""
                            : data.images.first.url ?? "",
                        price: data.discountedPrice,
                      );
                    },
                  ),

                  // Container(
                  //   padding: EdgeInsets.symmetric(horizontal: 20.w),
                  //   width: double.infinity,
                  //   child: Wrap(
                  //     runSpacing: 20.h,
                  //     // spacing: 20.w,
                  //     crossAxisAlignment: WrapCrossAlignment.center,
                  //     runAlignment: WrapAlignment.spaceAround,
                  //     alignment: (__.products.length == 1)
                  //         ? WrapAlignment.start
                  //         : WrapAlignment.spaceEvenly,
                  //     children: [
                  //       for (var data in __.products)
                  //         ProductCard(
                  //           productId: data.id,
                  //           category: data.subCategory.name,
                  //           title: data.name,
                  //           imageUrl: (data.images == null || data.images.isEmpty)
                  //               ? ""
                  //               : data.images.first.url ?? "",
                  //           price: data.discountedPrice,
                  //         ),

                  //       if (!__.isloading && __.products.isEmpty)
                  //         Column(
                  //           children: [
                  //             LottieBuilder.asset(
                  //               "assets/Lotties/NodataFound.json",
                  //               width: 250.w,
                  //             ),
                  //             Text(
                  //               "No Product Founds",
                  //               style: GoogleFonts.poppins(
                  //                 fontSize: 16.sp,
                  //                 fontWeight: FontWeight.w500,
                  //               ),
                  //             ),
                  //             Text(
                  //               "Please get back later",
                  //               style: GoogleFonts.poppins(
                  //                 fontSize: 12.sp,
                  //                 fontWeight: FontWeight.w400,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget _placeholder() {
  return Container(
    color: Colors.grey.shade300,
    child: Center(
      child: Icon(
        Icons.image_not_supported,
        color: Colors.grey.shade600,
        size: 20.sp,
      ),
    ),
  );
}
