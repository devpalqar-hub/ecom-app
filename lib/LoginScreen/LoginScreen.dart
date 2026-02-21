import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_project/Home%20Page/DashBoard.dart';
import 'package:new_project/LoginScreen/Service/AuthenticationController.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  // It's cleaner to initialize the controller inside the build or via Get.find if already put elsewhere
  final Authenticationcontroller authCtrl = Get.put(Authenticationcontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GetBuilder<Authenticationcontroller>(
          builder: (controller) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: Column(
                      children: [
                        // --- Top Skip Button ---
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              controller.skipLogin();
                              Get.offAll(() => DashBoard());
                            },
                            child: Text(
                              "Skip",
                              style: GoogleFonts.poppins(
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),

                        const Spacer(),

                        // --- Logo Section ---
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.w),
                          child: Image.asset(
                            "assets/logo_full.png",
                            height: 80.h,
                            fit: BoxFit.contain,
                          ),
                        ),

                        SizedBox(height: 40.h),

                        // --- Header Text ---
                        Text(
                          "Welcome Back",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 24.sp,
                            color: const Color(0xFFAE933F),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          "Enter your email to receive a verification code",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 13.sp,
                            color: Colors.black45,
                          ),
                        ),

                        SizedBox(height: 40.h),

                        // --- Email Input Field ---
                        _buildEmailField(controller),

                        SizedBox(height: 20.h),

                        // --- Main Action Button ---
                        _buildContinueButton(controller),

                        SizedBox(height: 15.h),

                        // --- Secondary Skip/Guest Option ---
                        TextButton(
                          onPressed: () async {
                            controller.skipLogin();
                            Get.offAll(() => DashBoard());
                          },
                          child: Text(
                            "Continue as Guest",
                            style: GoogleFonts.poppins(
                              color: const Color(0xFFAE933F),
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                              //  decoration: TextDecoration.underline,
                            ),
                          ),
                        ),

                        const Spacer(),

                        // --- Footer Branding ---
                        _buildFooter(),

                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmailField(Authenticationcontroller controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFAE933F).withOpacity(0.2)),
      ),
      child: TextField(
        controller: controller.emailController,
        keyboardType: TextInputType.emailAddress,
        style: GoogleFonts.poppins(fontSize: 14.sp),
        decoration: InputDecoration(
          hintText: "Email Address",
          hintStyle: GoogleFonts.poppins(
            color: Colors.grey.shade400,
            fontSize: 14.sp,
          ),
          prefixIcon: const Icon(
            Icons.alternate_email_rounded,
            color: Color(0xFFAE933F),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: 15.h,
            horizontal: 20.w,
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton(Authenticationcontroller controller) {
    return SizedBox(
      width: double.infinity,
      height: 55.h,
      child: ElevatedButton(
        onPressed: controller.isLoading ? null : () => controller.sendOtp(),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFAE933F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 4,
          shadowColor: const Color(0xFFAE933F).withOpacity(0.4),
        ),
        child: controller.isLoading
            ? SizedBox(
                height: 20.h,
                width: 20.w,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                "Send Verification Code",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Text(
          "Finest Shopping Destination in Qatar",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 12.sp,
            color: Colors.black38,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          "MODEST WEAR • NIGHT WEARS • HIJABS",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 10.sp,
            color: const Color(0xFFAE933F),
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
