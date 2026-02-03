
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_project/Home Page/Service/BannerController.dart';

class BannerCarousel extends StatelessWidget {
  BannerCarousel({super.key});

  final BannerController controller = Get.find<BannerController>();
  final RxInt currentIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.white),
        );
      }

      if (controller.banners.isEmpty) {
        return Image.asset(
          "assets/section.png",
          fit: BoxFit.cover,
        );
      }

      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CarouselSlider(
            items: controller.banners.map((banner) {
              return Image.network(
                banner.image,
                fit: BoxFit.cover,
                width: double.infinity,
              );
            }).toList(),
            options: CarouselOptions(
              height: double.infinity,
              viewportFraction: 1,
              autoPlay: true,
              autoPlayInterval:  Duration(seconds: 1),
              autoPlayAnimationDuration:
                   Duration(milliseconds: 10),
              onPageChanged: (index, reason) {
                currentIndex.value = index;
              },
            ),
          ),

          
          Positioned(
            bottom: 10,
            child: Row(
              children: List.generate(
                controller.banners.length,
                (index) => Obx(() => Container(
                      width: currentIndex.value == index ? 14 : 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: currentIndex.value == index
                            ? Colors.white
                            : Colors.white54,
                      ),
                    )),
              ),
            ),
          ),
        ],
      );
    });
  }
}
