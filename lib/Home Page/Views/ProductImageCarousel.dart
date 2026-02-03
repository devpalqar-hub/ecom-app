
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:new_project/Home%20Page/Model/ProductDetailModel.dart' show ProductImage;

class ProductImagesCarousel extends StatefulWidget {
  final List<ProductImage> images;
  const ProductImagesCarousel({super.key, required this.images});

  @override
  State<ProductImagesCarousel> createState() => _ProductImagesCarouselState();
}

class _ProductImagesCarouselState extends State<ProductImagesCarousel> {
  int currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return SizedBox(
        height: 300.h,
        child: const Center(child: Text("No image available")),
      );
    }

   
    if (widget.images.length == 1) {
      return SizedBox(
        height: 300.h,
        width: double.infinity,
        child: Image.network(
          widget.images.first.url,
          fit: BoxFit.cover,
        ),
      );
    }

    
    return SizedBox(
      height: 300.h,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (_, index) {
              final img = widget.images[index];
              return Image.network(
                img.url,
                fit: BoxFit.cover,
                width: double.infinity,
              );
            },
          ),
          Positioned(
            bottom: 10.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  width: currentIndex == index ? 10.w : 6.w,
                  height: currentIndex == index ? 10.w : 6.w,
                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? const Color(0xffC17D4A)
                        : Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
      


        ],
      ),
    );
  }
}
