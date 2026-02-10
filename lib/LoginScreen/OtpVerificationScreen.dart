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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GetBuilder<Authenticationcontroller>(
          builder: (authCtrl) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20.w, top: 16.h),
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
                              border: Border.all(color: Colors.grey.shade300),
                              color: Colors.white,
                            ),
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.black54,
                              size: 18.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 60.h),

                      Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          color: Color(0xFFFFF4E6),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.email_outlined,
                          size: 40.sp,
                          color: Color(0xFFAE933F),
                        ),
                      ),

                      SizedBox(height: 30.h),

                      Text(
                        "Verify Code",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 24.sp,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Text(
                          "Please enter the verification code sent to",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 13.sp,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        authCtrl.emailController.text,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Color(0xFFAE933F),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 40.h),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.w),
                        child: Pinput(
                          length: 6,
                          controller: authCtrl.otpController,
                          defaultPinTheme: PinTheme(
                            width: 50.w,
                            height: 56.h,
                            textStyle: GoogleFonts.poppins(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          focusedPinTheme: PinTheme(
                            width: 50.w,
                            height: 56.h,
                            textStyle: GoogleFonts.poppins(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFAE933F),
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFFFFF4E6),
                              border: Border.all(
                                color: Color(0xFFAE933F),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Didn't receive code? ",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 13.sp,
                              color: Colors.black54,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              authCtrl.sendOtp();
                            },
                            child: Text(
                              "Resend",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 13.sp,
                                color: Color(0xFFAE933F),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40.h),

                      InkWell(
                        onTap: () {
                          authCtrl.VerfyOtp();
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 40.w),
                          height: 50.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color(0xFFAE933F),
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFAE933F).withOpacity(0.3),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: (authCtrl.isLoading)
                              ? SizedBox(
                                  height: 20.h,
                                  width: 20.w,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  "Verify & Continue",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.sp,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),

                      Spacer(),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
