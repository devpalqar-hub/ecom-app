import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_project/LoginScreen/Service/AuthenticationController.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<Authenticationcontroller>(
          builder: (authCtrl) {
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20.w, top: 10.h),

                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black26),
                      ),

                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50.h),

                Text(
                  "Verify Code",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 21.sp,
                  ),
                ),
                Text(
                  "Please enter the code we just sent to email",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13.sp,
                  ),
                ),
                Text(
                  authCtrl.emailController.text,
                  style: TextStyle(color: Color(0xFFAE933F), fontSize: 13.sp),
                ),
                SizedBox(height: 20.h),

                Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 24.w),
                  child: Pinput(length: 6, controller: authCtrl.otpController),
                ),
                SizedBox(height: 20.h),

                Text(
                  "Didn't receive otp ?",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13.sp,
                    color: Colors.black26,
                  ),
                ),
                InkWell(
                  onTap: () {
                    authCtrl.sendOtp();
                  },
                  child: Text(
                    "Resend",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                InkWell(
                  onTap: () {
                    authCtrl.VerfyOtp();
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    height: 45.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      //border: Border.all(color: Color(0xFFAE933F)),
                      color: Color(0xFFAE933F),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: (authCtrl.isLoading)
                        ? CircularProgressIndicator(
                            color: Colors.white,
                            padding: EdgeInsetsGeometry.all(2.w),
                          )
                        : Text(
                            "Verify OTP",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
