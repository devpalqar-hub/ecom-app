import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_project/LoginScreen/Service/AuthenticationController.dart';

class CompleteProfileBottomSheet extends StatelessWidget {
  const CompleteProfileBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.find<Authenticationcontroller>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: GetBuilder<Authenticationcontroller>(
        builder: (__) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Title
              Text(
                "Complete Your Profile",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 20.sp,
                  color: Color(0xFFAE933F),
                ),
              ),
              SizedBox(height: 8.h),

              Text(
                "Please provide your details to continue",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 13.sp,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 25.h),

              // Name Field
              Text(
                "Full Name",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),

              Container(
                height: 50.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFAE933F)),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: TextField(
                  controller: authCtrl.nameController,
                  textAlign: TextAlign.start,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    isCollapsed: true,
                    hintText: "Enter your full name",
                    prefixIcon: Icon(Icons.person),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 15.h,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Phone Field
              Text(
                "Phone Number",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),

              Container(
                height: 50.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFAE933F)),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: TextField(
                  controller: authCtrl.phoneController,
                  keyboardType: TextInputType.phone,
                  textAlign: TextAlign.start,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    isCollapsed: true,
                    hintText: "Enter your phone number",
                    prefixIcon: Icon(Icons.phone),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 15.h,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.h),

              // Submit Button
              InkWell(
                onTap: () {
                  authCtrl.completeProfile();
                },
                child: Container(
                  width: double.infinity,
                  height: 50.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xFFAE933F),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: (__.isLoading)
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Continue",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          );
        },
      ),
    );
  }
}
