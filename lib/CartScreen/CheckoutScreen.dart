import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:new_project/CartScreen/Services/CartController.dart';
import 'package:new_project/CartScreen/Services/CheckoutController.dart';
import 'package:new_project/CartScreen/Views/AddAddressBottomSheet.dart';
import 'package:new_project/CartScreen/Views/AddressSelectionBottomSheet.dart';
import 'package:new_project/CartScreen/Views/CoupenCard.dart';
import 'package:new_project/MyOrder/OrderDetailScreen.dart';
import 'package:new_project/MyOrder/Model/OrderDetailModel.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final CheckoutController controller = Get.put(CheckoutController());
  final CartController cartController = Get.find<CartController>();

  @override
  void initState() {
    super.initState();
    controller.fetchAddresses();
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
          'Checkout',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAddressSection(),
            SizedBox(height: 24.h),
            _buildPaymentMethodSection(),
            SizedBox(height: 24.h),
            _buildCouponSection(),
            SizedBox(height: 24.h),
            _buildSummarySection(),
            SizedBox(height: 30.h),
            _buildPlaceOrderButton(),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Delivery Address',
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Get.bottomSheet(
                  const AddAddressBottomSheet(),
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  isDismissible: true,
                  enableDrag: true,
                );
              },
              icon: Icon(Icons.add, color: Color(0xFFAE933F)),
              label: Text(
                'Add New',
                style: GoogleFonts.poppins(
                  color: Color(0xFFAE933F),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(20.h),
                child: CircularProgressIndicator(color: Color(0xFFAE933F)),
              ),
            );
          }

          if (controller.error.value != null) {
            return Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Text(
                controller.error.value!,
                style: GoogleFonts.poppins(color: Colors.red, fontSize: 13.sp),
              ),
            );
          }

          final addresses = controller.addresses;

          // Show "Select Address" button
          if (addresses.isEmpty) {
            return InkWell(
              onTap: () {
                Get.bottomSheet(
                  const AddAddressBottomSheet(),
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  isDismissible: true,
                  enableDrag: true,
                );
              },
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Color(0xFFFFF4E6),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Color(0xFFAE933F),
                    style: BorderStyle.solid,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.add_location_alt_outlined,
                      color: Color(0xFFAE933F),
                      size: 30.sp,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'No Address Found',
                            style: GoogleFonts.poppins(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFAE933F),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Tap here to add your delivery address',
                            style: GoogleFonts.poppins(
                              fontSize: 11.sp,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFFAE933F),
                      size: 16.sp,
                    ),
                  ],
                ),
              ),
            );
          }

          // Auto-select default address
          if (controller.selectedAddress.value == null &&
              controller.defaultAddress != null) {
            Future.microtask(() {
              controller.selectedAddress.value = controller.defaultAddress;
            });
          }

          final selectedAddress = controller.selectedAddress.value;

          // Show selected address or "Select Address" button
          return InkWell(
            onTap: () {
              Get.bottomSheet(
                const AddressSelectionBottomSheet(),
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                isDismissible: true,
                enableDrag: true,
              );
            },
            child: Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: selectedAddress != null
                    ? Color(0xFFFFF4E6)
                    : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: selectedAddress != null
                      ? Color(0xFFAE933F)
                      : Colors.grey.shade300,
                  width: selectedAddress != null ? 1 : 1,
                ),
              ),
              child: selectedAddress == null
                  ? Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Color(0xFFAE933F),
                          size: 20.sp,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            'Select Delivery Address',
                            style: GoogleFonts.poppins(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFAE933F),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xFFAE933F),
                          size: 14.sp,
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Color(0xFFAE933F),
                          size: 20.sp,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    selectedAddress.name,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (selectedAddress.isDefault) ...[
                                    SizedBox(width: 6.w),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6.w,
                                        vertical: 2.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFAE933F),
                                        borderRadius: BorderRadius.circular(
                                          4.r,
                                        ),
                                      ),
                                      child: Text(
                                        'Default',
                                        style: GoogleFonts.poppins(
                                          fontSize: 9.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                selectedAddress.address,
                                style: GoogleFonts.poppins(
                                  fontSize: 12.sp,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                '${selectedAddress.city}, ${selectedAddress.state}, ${selectedAddress.postalCode}',
                                style: GoogleFonts.poppins(
                                  fontSize: 11.sp,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                'Phone: ${selectedAddress.phone}',
                                style: GoogleFonts.poppins(
                                  fontSize: 11.sp,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.edit_outlined,
                          color: Color(0xFFAE933F),
                          size: 18.sp,
                        ),
                      ],
                    ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        Obx(() {
          return Column(
            children: PaymentMethod.values.map((method) {
              final isSelected =
                  controller.selectedPaymentMethod.value == method;
              return GestureDetector(
                onTap: () {
                  controller.selectedPaymentMethod.value = method;
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 10.h),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xFFFFF4E6) : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isSelected
                          ? Color(0xFFAE933F)
                          : Colors.grey.shade300,
                      width: isSelected ? 1 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Radio<PaymentMethod>(
                        value: method,
                        groupValue: controller.selectedPaymentMethod.value,
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedPaymentMethod.value = value;
                          }
                        },
                        activeColor: Color(0xFFAE933F),
                      ),
                      SizedBox(width: 6.w),
                      Icon(
                        method.icon,
                        color: isSelected
                            ? Color(0xFFAE933F)
                            : Colors.grey.shade700,
                        size: 20.sp,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          method.displayName,
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: isSelected ? Colors.black87 : Colors.black54,
                          ),
                        ),
                      ),
                      if (method != PaymentMethod.cashOnDelivery)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFAE933F).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: Text(
                            'MyFatoorah',
                            style: GoogleFonts.poppins(
                              fontSize: 9.sp,
                              color: Color(0xFFAE933F),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildCouponSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Apply Coupon',
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        CouponCard(cartController: cartController),
      ],
    );
  }

  Widget _buildSummarySection() {
    return Obx(() {
      final total = cartController.getTotalPrice();
      final discount = cartController.discountAmount.value;
      final coupon = cartController.appliedCoupon.value;
      final deliveryCharge = controller.currentDeliveryCharge;
      final payable = (total - discount + deliveryCharge).clamp(
        0.0,
        double.infinity,
      );

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: Color(0xFFF7F8F9),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                _summaryRow('Total Price', 'QAR ${total.toStringAsFixed(2)}'),
                if (discount > 0 && coupon != null && coupon.isNotEmpty)
                  _summaryRow(
                    'Coupon Discount',
                    '-QAR ${discount.toStringAsFixed(2)}',
                    color: Colors.green,
                  ),
                if (deliveryCharge > 0)
                  _summaryRow(
                    'Delivery Charge',
                    'QAR ${deliveryCharge.toStringAsFixed(2)}',
                    color: Color(0xFFAE933F),
                  ),
                Divider(height: 24.h),
                _summaryRow(
                  'Payable Amount',
                  'QAR ${payable.toStringAsFixed(2)}',
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
      final hasAddress = controller.selectedAddress.value != null;
      final cart = cartController.cart.value;
      final isProcessing = controller.isLoading.value;

      return SizedBox(
        width: double.infinity,
        height: 46.h,
        child: ElevatedButton(
          onPressed:
              !hasAddress || cart == null || cart.data.isEmpty || isProcessing
              ? null
              : () => _handlePlaceOrder(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFAE933F),
            disabledBackgroundColor: Colors.grey.shade300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          child: isProcessing
              ? SizedBox(
                  height: 20.h,
                  width: 20.w,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  'Place Order',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
        ),
      );
    });
  }

  Future<void> _handlePlaceOrder() async {
    final total = cartController.getTotalPrice();
    final discount = cartController.discountAmount.value;
    final deliveryCharge = controller.currentDeliveryCharge;
    final payable = (total - discount + deliveryCharge).clamp(
      0.0,
      double.infinity,
    );
    final coupon = cartController.appliedCoupon.value;

    final result = await controller.processCheckout(
      payableAmount: payable,
      couponName: coupon?.isNotEmpty == true ? coupon : null,
    );

    if (result != null) {
      // Order created successfully
      // Navigate to order details page
      try {
        final orderData = result['data']["order"];
        if (orderData != null) {
          // Create OrderDetailModel from response
          final order = OrderDetailModel.fromJson(orderData);

          // Clear cart after successful order
          await cartController.fetchCart();

          // Navigate to order details
          Get.off(() => OrderDetailScreen(order: order));
        }
      } catch (e) {
        debugPrint("Error navigating to order details: $e");
        // Fallback: just go back to home
        Get.back();
      }
    }
  }

  Widget _summaryRow(
    String label,
    String value, {
    bool isBold = false,
    Color? color,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
