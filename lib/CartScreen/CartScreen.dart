import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_project/CartScreen/CheckoutScreen.dart';
import 'package:new_project/CartScreen/Services/CartController.dart';
import 'package:new_project/CartScreen/Views/CartProductCard.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartController cartController = Get.put(CartController());

  @override
  void initState() {
    super.initState();
    cartController.fetchCart();
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
          'Cart',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: Obx(() {
        final cart = cartController.cart.value;
        final validItems =
            cart?.data.where((item) => item.isValid).toList() ?? [];

        if (cartController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: Color(0xFFAE933F)),
          );
        }

        if (validItems.isEmpty) {
          return _emptyCartView();
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Items',
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    ...validItems.map(
                      (item) => Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: CartProductCard(cartItem: item),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildBottomBar(validItems),
          ],
        );
      }),
    );
  }

  Widget _buildBottomBar(List validItems) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        //    color: Colors.white,
        // boxShadow: [
        //   BoxShadow(
        //     offset: Offset(0, -2),
        //     blurRadius: 8,
        //     color: Colors.black.withOpacity(0.1),
        //   ),
        // ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 46.h,
              child: ElevatedButton(
                onPressed: validItems.isEmpty
                    ? null
                    : () {
                        Get.to(
                          () => CheckoutScreen(),
                          transition: Transition.rightToLeft,
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFAE933F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Text(
                  'Checkout (QAR ${cartController.getTotalPrice().toStringAsFixed(0)})',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyCartView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 70.sp,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16.h),
          Text(
            'No products in your cart',
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Looks like you haven\'t added anything yet',
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
