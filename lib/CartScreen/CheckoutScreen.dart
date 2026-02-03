import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:new_project/CartScreen/Model/AddressModel.dart';
import 'package:new_project/CartScreen/OrderConfirmation.dart';
import 'package:new_project/CartScreen/Services/CartController.dart';
import 'package:new_project/CartScreen/Services/CheckoutController.dart';
import 'package:new_project/CartScreen/Views/CartProductCard.dart';
import 'package:new_project/CartScreen/Views/CoupenCard.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final CheckoutController controller = Get.put(CheckoutController());
  final CartController cartController = Get.put(CartController());

  final Rx<AddressModel?> selectedAddress = Rx<AddressModel?>(null);

  @override
  void initState() {
    super.initState();
    cartController.fetchCart();
  
    controller.fetchAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, __) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Cart',
            style: GoogleFonts.poppins(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),

       
     body: Obx(() {
  final cart = cartController.cart.value;


  final validItems = cart?.data.where((item) => item.isValid).toList() ?? [];

  if (validItems.isEmpty) {
    return _emptyCartView();
  }


  if (selectedAddress.value == null && controller.defaultAddress != null) {
    selectedAddress.value = controller.defaultAddress;
    controller.selectedAddress.value = controller.defaultAddress;
  }

  return SingleChildScrollView(
    padding: EdgeInsets.all(16.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAddressSection(),
        SizedBox(height: 20.h),
        _buildCartSection(validItems),
        SizedBox(height: 20.h),
        _buildCouponSection(),
        SizedBox(height: 20.h),
        _buildSummarySection(),
        SizedBox(height: 30.h),
        _buildPlaceOrderButton(),
      ],
    ),
  );
}),

      ),
    );
  }


Widget _buildAddressSection() {
  return Obx(() {
    if (controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.error.value != null) {
      return SizedBox(
        width: double.infinity, 
        child: Text(
          controller.error.value!,
          style: GoogleFonts.poppins(color: Colors.red),
        ),
      );
    }

    final addresses = controller.addresses;

   
    if (addresses.isEmpty) {
      return Container(
        width: double.infinity, 
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: const Color(0xffFFF4E6),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xffC17D4A)),
        ),
        child: Text(
          'No address added',
          style: GoogleFonts.poppins(fontSize: 13.sp),
        ),
      );
    }

    final selectedId =
        controller.selectedAddress.value?.id ?? controller.defaultAddress?.id;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xffFFF4E6),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xffC17D4A)),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        underline: const SizedBox(),
        value: selectedId,
        icon: const Icon(Icons.arrow_drop_down, color: Color(0xffC17D4A)),
        onChanged: (id) {
          controller.selectedAddress.value =
              addresses.firstWhere((a) => a.id == id);
        },
        items: addresses.map((address) {
          return DropdownMenuItem(
            value: address.id,
            child: Text(
              '${address.name}, ${address.address}, ${address.city}',
              style: GoogleFonts.poppins(fontSize: 13.sp),
            ),
          );
        }).toList(),
      ),
    );
  });
}


 
  Widget _buildCartSection(List validItems) {
  return Column(
    children: validItems
        .map((item) => CartProductCard(cartItem: item))
        .toList(),
  );
}


Widget _buildCouponSection() {
  return CouponCard(cartController: cartController);
}


Widget _buildSummarySection() {
  return Obx(() {
    final total = cartController.getTotalPrice();
    final discount = cartController.discountAmount.value;
    final coupon = cartController.appliedCoupon.value;

    final payable = (total - discount).clamp(0.0, double.infinity);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Summary',
          style: GoogleFonts.poppins(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xffF7F8F9),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              _summaryRow(
                'Total Price',
                'QAR ${ total.toStringAsFixed(2)}',
              ),

            if (discount > 0)
  if (discount > 0 && coupon != null && coupon.isNotEmpty)
  _summaryRow(
    'Coupon Discount ',
    '-QAR ${discount.toStringAsFixed(2)}',
    color: Colors.green,
  ),



              const Divider(),

              _summaryRow(
                'Payable Amount',
                'QAR ${ payable.toStringAsFixed(2)}',
                isBold: true,
              ),
            ],
          ),
        ),
      ],
    );
  });
}

 
  Widget _buildPlaceOrderButton() {
    return Obx(() {
      final cart = cartController.cart.value;

      return SizedBox(
        width: double.infinity,
        height: 48.h,
        child: ElevatedButton(
          onPressed: selectedAddress.value == null ||
                  cart == null ||
                  cart.data.isEmpty
              ? null
              : () => Get.to(() => const OrderConfirmationScreen()),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xffC17D4A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.r),
            ),
          ),
          child: Text(
            'Place Order',
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      );
    });
  }


  Widget _summaryRow(String label, String value,
      {bool isBold = false, Color? color}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
              color: color,
            ),
          ),
        ],
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
            size: 90.sp,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16.h),
          Text(
            'No products in your cart',
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Looks like you haven’t added anything yet',
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
