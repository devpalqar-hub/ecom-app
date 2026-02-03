import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_project/LoginScreen/Service/AuthenticationController.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  Authenticationcontroller authCtrl = Get.put(Authenticationcontroller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<Authenticationcontroller>(
          builder: (__) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(width: double.infinity),
                SizedBox(height: 25.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 70.0.w),
                  child: Image.asset("assets/logo_full.png"),
                ),
                SizedBox(height: 25.h),
                Text(
                  "Login with Email",
                  textAlign: TextAlign.center,

                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 21.sp,
                    color: Color(0xFFAE933F),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "We'll send an OTP to your email",
                  textAlign: TextAlign.center,

                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20.h),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50.w),
                  height: 45.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFAE933F)),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: TextField(
                    controller: authCtrl.emailController,
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      isCollapsed: true,
                      hintText: "Enter Your Email ID",
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                InkWell(
                  onTap: () {
                    authCtrl.sendOtp();
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 50.w),
                    height: 45.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      //border: Border.all(color: Color(0xFFAE933F)),
                      color: Color(0xFFAE933F),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: (__.isLoading)
                        ? CircularProgressIndicator(
                            color: Colors.white,
                            padding: EdgeInsetsGeometry.all(2.w),
                          )
                        : Text(
                            "Login Now",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                Spacer(),
                Text(
                  "Finest Shopping Destination in Qatar",
                  textAlign: TextAlign.center,

                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "MODEST WEAR • NIGHT WEARS • HIJABS",
                  textAlign: TextAlign.center,

                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 25.h),
              ],
            );
          },
        ),
      ),
    );
  }
}
