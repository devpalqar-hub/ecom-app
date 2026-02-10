import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_project/CartScreen/Services/CheckoutController.dart';
import 'package:new_project/CartScreen/Views/AddAddressBottomSheet.dart';

class AddressSelectionBottomSheet extends StatelessWidget {
  const AddressSelectionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CheckoutController>();

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Delivery Address',
                  style: GoogleFonts.poppins(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Get.bottomSheet(
                      const AddAddressBottomSheet(),
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      isDismissible: true,
                      enableDrag: true,
                    );
                  },
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: Color(0xFFAE933F),
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1),

          // Address List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(color: Color(0xFFAE933F)),
                );
              }

              final addresses = controller.addresses;

              if (addresses.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_off_outlined,
                        size: 64.sp,
                        color: Colors.grey.shade400,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'No addresses found',
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      TextButton(
                        onPressed: () {
                          Get.bottomSheet(
                            const AddAddressBottomSheet(),
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            isDismissible: true,
                            enableDrag: true,
                          );
                        },
                        child: Text(
                          'Add Address',
                          style: GoogleFonts.poppins(
                            color: Color(0xFFAE933F),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                itemCount: addresses.length,
                itemBuilder: (context, index) {
                  final address = addresses[index];
                  final isSelected =
                      controller.selectedAddress.value?.id == address.id;

                  return GestureDetector(
                    onTap: () async {
                      // Check if delivery charge exists for this postal code
                      if (!controller.deliveryCharges.containsKey(
                        address.postalCode,
                      )) {
                        // Fetch delivery charge
                        final deliveryCheck = await controller.checkDelivery(
                          address.postalCode,
                        );

                        if (deliveryCheck == null ||
                            deliveryCheck['success'] != true) {
                          Fluttertoast.showToast(
                            msg:
                                'Delivery not available for this address. Please add a new address with deliverable postal code.',
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            toastLength: Toast.LENGTH_LONG,
                          );
                          return;
                        }
                      }

                      // Select the address
                      controller.selectedAddress.value = address;
                      Get.back();
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Color(0xFFFFF4E6)
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isSelected
                              ? Color(0xFFAE933F)
                              : Colors.grey.shade300,
                          width: isSelected ? 1 : 1,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Radio<String>(
                            value: address.id,
                            groupValue: controller.selectedAddress.value?.id,
                            onChanged: null, // Handled by GestureDetector
                            activeColor: Color(0xFFAE933F),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      address.name,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (address.isDefault) ...[
                                      SizedBox(width: 8.w),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
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
                                            fontSize: 10.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  address.address,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.sp,
                                    color: Colors.black87,
                                  ),
                                ),
                                if (address.landmark.isNotEmpty) ...[
                                  SizedBox(height: 4.h),
                                  Text(
                                    'Landmark: ${address.landmark}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12.sp,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                                SizedBox(height: 4.h),
                                Text(
                                  '${address.city}, ${address.state}, ${address.postalCode}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.sp,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'Phone: ${address.phone}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.sp,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
