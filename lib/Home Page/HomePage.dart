import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_project/CartScreen/Services/CartController.dart';

import 'package:new_project/Home%20Page/Model/FeaturedProduct.dart';
import 'package:new_project/Home%20Page/Model/FeaturedProductCategoryModel.dart';
import 'package:new_project/Home%20Page/Service/BannerController.dart';
import 'package:new_project/Home%20Page/Service/ProductController.dart';
import 'package:new_project/Home%20Page/Views/CategoryCard.dart';
import 'package:new_project/SearchProductScreen/CategoryProductScreen.dart';
import 'package:new_project/Home%20Page/Views/ProductsCard.dart';
import 'package:new_project/SearchProductScreen/Services/SearchProductController.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductController productController = Get.put(ProductController());
  final Searchproductcontroller searchProductController = Get.put(
    Searchproductcontroller(),
  );
  final BannerController bannerController = Get.put(BannerController());
  final CartController cartController = Get.put(CartController());
  final PageController _bannerPageController = PageController();
  int _currentBannerIndex = 0;

  @override
  void initState() {
    super.initState();

    bannerController.fetchBanners();
    productController.fetchFeaturedProducts();
    productController.fetchCategories().then((_) async {
      for (var category in productController.categories) {
        await productController.fetchFeaturedByCategory(
          categoryId: category.id,
        );
        productController.featuredProductsMap[category.id] = List.from(
          productController.featuredByCategory,
        );
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _bannerPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,

        //    foregroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.menu, size: 30.sp),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Raheeb.qa",
                  style: GoogleFonts.poppins(
                    //letterSpacing: 1.5,
                    fontSize: 16.sp,

                    fontWeight: FontWeight.w600,
                    color: Color(0xFFAE933F),
                  ),
                ),
                Text(
                  "MODEST WEAR • NIGHT WEARS • HIJABS",
                  style: GoogleFonts.poppins(
                    //letterSpacing: 1.5,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                    //  color: Color(0xFFAE933F),
                  ),
                ),
              ],
            ),
          ],
        ),

        actions: [
          InkWell(
            onTap: () {
              Get.to(() => SearchProductScreen());
            },
            child: Icon(Icons.search),
          ),
          SizedBox(width: 20.w),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              if (bannerController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              if (bannerController.banners.isEmpty) {
                return Image.asset("assets/section.png", fit: BoxFit.cover);
              }

              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                padding: EdgeInsets.all(10.w),
                child: CarouselSlider.builder(
                  itemCount: bannerController.banners.length,
                  itemBuilder: (context, index, realIndex) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.r),
                        child: Image.network(
                          bannerController.banners[index].image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 200.h,
                    viewportFraction: .8,

                    autoPlay: true,
                    enlargeCenterPage: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentBannerIndex = index;
                      });
                    },
                  ),
                ),
              );
            }),
            SizedBox(height: 20.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                children: [
                  Text(
                    "Featured Item",
                    style: TextStyle(
                      fontSize: 21.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      Get.to(
                        () => SearchProductScreen(),
                      ); // navigate to all products
                    },
                    child: Text(
                      "View All",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFAE933F),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: Obx(() {
                if (productController.isLoadingFeaturedProducts.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (productController.featuredProducts.isEmpty) {
                  return const Center(child: Text("No featured products"));
                }

                return SizedBox(
                  height: 230.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemCount: productController.featuredProducts.length,
                    separatorBuilder: (_, __) => SizedBox(width: 12.w),
                    itemBuilder: (context, index) {
                      final FeaturedProduct product =
                          productController.featuredProducts[index];

                      return ProductCard(
                        productId: product.id,
                        title: product.name,
                        category: product.subCategory.name,
                        imageUrl: product.images.isNotEmpty
                            ? product.images.first.url
                            : "",
                        price: double.tryParse(product.discountedPrice) ?? 0.0,
                        fullPrice:
                            product.actualPrice != product.discountedPrice
                            ? product.actualPrice
                            : null,
                      );
                    },
                  ),
                );
              }),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                children: [
                  Text(
                    "Shop By Category",
                    style: TextStyle(
                      fontSize: 21.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Obx(() {
              if (productController.isLoadingCategories.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return SizedBox(
                height: 100.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: productController.categories.length,
                  separatorBuilder: (_, __) => SizedBox(width: 12.w),
                  itemBuilder: (context, index) {
                    final category = productController.categories[index];

                    return CategoryCard(
                      imageUrl: category.image ?? '',
                      title: category.name,
                      description: category.description ?? 'No description',
                      onTap: () {
                        Get.to(
                          () => SearchProductScreen(categoryId: category.id),
                        );
                      },
                    );
                  },
                ),
              );
            }),
            SizedBox(height: 20.h),

            Obx(() {
              if (productController.categories.isEmpty) {
                return Container();
              }

              return Column(
                children: productController.categories.map((category) {
                  final products =
                      productController.featuredProductsMap[category.id] ?? [];

                  return (products.isEmpty)
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.only(bottom: 0.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // SizedBox(height: 10.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Row(
                                  children: [
                                    Text(
                                      category.name,
                                      style: TextStyle(
                                        fontSize: 21.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.h),

                              GridView.builder(
                                itemCount: products.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 12.h,
                                      crossAxisSpacing: 12.w,
                                      childAspectRatio: 0.66,
                                    ),
                                itemBuilder: (context, index) {
                                  final product = products[index];
                                  return ProductCard(
                                    productId: product.id,
                                    title: product.name,
                                    category: product.subCategory.name,
                                    imageUrl: product.images.isNotEmpty
                                        ? product.images.first.url
                                        : "",
                                    price:
                                        double.tryParse(
                                          product.discountedPrice,
                                        ) ??
                                        0.0,
                                    fullPrice:
                                        product.actualPrice !=
                                            product.discountedPrice
                                        ? product.actualPrice
                                        : null,
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                }).toList(),
              );
            }),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 16.w),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xffF4ECE4),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 160.h,
                      child: Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(19.r),
                              child: Image.asset(
                                "assets/image1.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(19.r),
                              child: Image.asset(
                                "assets/image2.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(19.r),
                              child: Image.asset(
                                "assets/image3.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Text(
                      "Signature Scents",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12.sp,
                        letterSpacing: 1.1,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Luxury Perfumes",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      "Experience our exclusive collection of premium fragrances. Each scent is carefully crafted to create lasting memories and express your unique personality.",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.black54,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 14.h),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: double.infinity),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  child: Column(
                    children: [
                      Text(
                        "RAHEEB",
                        style: TextStyle(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "DEFINED BY ELEGANCE",
                        style: TextStyle(
                          fontSize: 12.sp,
                          letterSpacing: 3,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

Widget sectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(10, 20, 25, 10),
    child: Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );
}
