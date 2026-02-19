import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_project/Home%20Page/Model/CategoryModel.dart';
import 'package:new_project/Home%20Page/Model/ProductDetailModel.dart';
import 'package:new_project/SearchProductScreen/Services/SearchProductController.dart';

class SearchFilterBottomSheet extends StatefulWidget {
  SearchFilterBottomSheet({super.key});

  @override
  State<SearchFilterBottomSheet> createState() =>
      _SearchFilterBottomSheetState();
}

class _SearchFilterBottomSheetState extends State<SearchFilterBottomSheet> {
  Searchproductcontroller ctrl = Get.put(Searchproductcontroller());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    priceValue = "${ctrl.minPrice}-${ctrl.maxPrice}";
    selectedSubCategory = ctrl.selectedSubCategoryId;
    setState(() {});
  }

  SubCategoryModel? selectedSubCategory = null;
  String priceValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          if (priceValue != "") {
            var splited = priceValue.split("-");
            ctrl.minPrice = splited[0];
            ctrl.maxPrice = splited[1];
          } else {
            ctrl.minPrice = "";
            ctrl.maxPrice = "";
          }

          if (selectedSubCategory != null) {
            ctrl.selectedSubCategoryId = selectedSubCategory;
          } else {
            ctrl.selectedSubCategoryId = null;
          }
          ctrl.update();
          ctrl.products = [];
          ctrl.fetchProducts();
          Get.back();
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 30.h, left: 20.w, right: 20.w),
          height: 45.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            //border: Border.all(color: Color(0xFFAE933F)),
            color: Color(0xFFAE933F),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            "Apply Filter",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r),
            topRight: Radius.circular(30.r),
          ),
        ),
        padding: EdgeInsets.only(top: 25.h, left: 20.w, right: 20.w),

        child: GetBuilder<Searchproductcontroller>(
          builder: (__) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Product Filters",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          priceValue = "";
                          selectedSubCategory = null;
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "Clear All",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(Icons.close),
                      ),
                    ],
                  ),
                  if (__.subCategories.isNotEmpty) ...[
                    SizedBox(height: 15.h),
                    Text(
                      "Sub Category",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    Wrap(
                      runSpacing: 10.w,
                      spacing: 10.w,
                      children: [
                        for (var data in __.subCategories)
                          InkWell(
                            onTap: () {
                              if (selectedSubCategory != null &&
                                  selectedSubCategory!.id == data.id) {
                                selectedSubCategory = null;
                              } else
                                selectedSubCategory = data;
                              setState(() {});
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 3.h,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    (selectedSubCategory != null &&
                                        selectedSubCategory!.id == data.id)
                                    ? Color(0xFFAE933F)
                                    : null,
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(color: Colors.black26),
                              ),
                              child: Text(
                                data.name,
                                style: TextStyle(
                                  color:
                                      (selectedSubCategory != null &&
                                          selectedSubCategory!.id == data.id)
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                  SizedBox(height: 10.h),
                  Text(
                    "Price Range",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10.h),

                  RadioListTile<String>(
                    value: "0-1000",
                    groupValue: priceValue,
                    onChanged: (value) {
                      if (priceValue == "0-1000") {
                        priceValue = "";
                      } else {
                        priceValue = "0-1000";
                      }
                      setState(() {});
                    },
                    title: Text(
                      "Under 1000 QAR",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  RadioListTile<String>(
                    value: "1000-2000",
                    groupValue: priceValue,
                    onChanged: (value) {
                      if (priceValue == "1000-2000") {
                        priceValue = "";
                      } else {
                        priceValue = "1000-2000";
                      }
                      setState(() {});
                    },
                    title: Text(
                      "QAR 1000 - QAR 2000",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  RadioListTile<String>(
                    value: "2000-5000",
                    groupValue: priceValue,
                    onChanged: (value) {
                      if (priceValue == "2000-5000") {
                        priceValue = "";
                      } else {
                        priceValue = "2000-5000";
                      }
                      setState(() {});
                    },
                    title: Text(
                      "QAR 2000 - QAR 5000",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  RadioListTile<String>(
                    value: "5000-0",
                    groupValue: priceValue,
                    onChanged: (value) {
                      if (priceValue == "5000-0") {
                        priceValue = "";
                      } else {
                        priceValue = "5000-0";
                      }
                      setState(() {});
                    },
                    title: Text(
                      "Above 5000 QAR",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
