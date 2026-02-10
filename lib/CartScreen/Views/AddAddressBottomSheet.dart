import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_project/CartScreen/Services/CheckoutController.dart';

class AddAddressBottomSheet extends StatefulWidget {
  const AddAddressBottomSheet({super.key});

  @override
  State<AddAddressBottomSheet> createState() => _AddAddressBottomSheetState();
}

class _AddAddressBottomSheetState extends State<AddAddressBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final CheckoutController controller = Get.find<CheckoutController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();

  bool isDefault = false;
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    postalCodeController.dispose();
    countryController.dispose();
    phoneController.dispose();
    landmarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
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

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 20.h,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add New Address',
                      style: GoogleFonts.poppins(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFAE933F),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Name
                    _buildTextField(
                      controller: nameController,
                      label: 'Address Label (e.g., Home, Office)',
                      hint: 'Home',
                      icon: Icons.label_outline,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter address label';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    // Address
                    _buildTextField(
                      controller: addressController,
                      label: 'Street Address',
                      hint: '123 Main Street',
                      icon: Icons.home_outlined,
                      maxLines: 2,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    // Landmark (Optional)
                    _buildTextField(
                      controller: landmarkController,
                      label: 'Landmark (Optional)',
                      hint: 'Near City Mall',
                      icon: Icons.location_on_outlined,
                    ),
                    SizedBox(height: 16.h),

                    // City and State
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: cityController,
                            label: 'City',
                            hint: 'Doha',
                            icon: Icons.location_city,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Enter city';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildTextField(
                            controller: stateController,
                            label: 'State',
                            hint: 'Qatar',
                            icon: Icons.map_outlined,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Enter state';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // Postal Code and Country
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: postalCodeController,
                            label: 'Postal Code',
                            hint: '10001',
                            icon: Icons.local_post_office_outlined,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Enter code';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildTextField(
                            controller: countryController,
                            label: 'Country',
                            hint: 'Qatar',
                            icon: Icons.flag_outlined,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Enter country';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // Phone
                    _buildTextField(
                      controller: phoneController,
                      label: 'Phone Number',
                      hint: '+1234567890',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter phone number';
                        }
                        if (value.length < 8) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    // Set as Default
                    Row(
                      children: [
                        Checkbox(
                          value: isDefault,
                          onChanged: (value) {
                            setState(() {
                              isDefault = value ?? false;
                            });
                          },
                          activeColor: Color(0xFFAE933F),
                        ),
                        Text(
                          'Set as default address',
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFAE933F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: isLoading
                            ? SizedBox(
                                width: 24.w,
                                height: 24.h,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Save Address',
                                style: GoogleFonts.poppins(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Color(0xFFAE933F)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: Color(0xFFAE933F)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: Colors.red),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Check delivery availability for postal code
    final deliveryCheck = await controller.checkDelivery(
      postalCodeController.text.trim(),
    );

    if (deliveryCheck == null || deliveryCheck['success'] != true) {
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(
        msg:
            deliveryCheck?['message'] ??
            'Delivery not available at this location',
        backgroundColor: Colors.red,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
      );
      return;
    }

    // Show delivery charge info
    final deliveryCharge = deliveryCheck['deliveryCharge'] ?? 0.0;
    Fluttertoast.showToast(
      msg:
          'Delivery available! Charge: QAR ${deliveryCharge.toStringAsFixed(2)}',
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );

    // Proceed with adding address
    final success = await controller.addAddress(
      name: nameController.text.trim(),
      address: addressController.text.trim(),
      city: cityController.text.trim(),
      state: stateController.text.trim(),
      postalCode: postalCodeController.text.trim(),
      country: countryController.text.trim(),
      phone: phoneController.text.trim(),
      landmark: landmarkController.text.trim(),
      isDefault: isDefault,
    );

    setState(() {
      isLoading = false;
    });

    if (success) {
      Get.back();
    }
  }
}
