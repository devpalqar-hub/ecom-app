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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GetBuilder<Authenticationcontroller>(
          builder: (__) {
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(width: double.infinity),
                      Spacer(),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 60.0.w),
                        child: Image.asset("assets/logo_full.png"),
                      ),
                      SizedBox(height: 30.h),
                      Text(
                        "Login with Email",
                        textAlign: TextAlign.center,

                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.sp,
                          color: Color(0xFFAE933F),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Text(
                          "We'll send a verification code to your email",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 40.w),
                        height: 50.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Color(0xFFAE933F),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: authCtrl.emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.start,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 14.h,
                            ),
                            isDense: true,
                            hintText: "Enter your email address",
                            hintStyle: GoogleFonts.poppins(
                              fontSize: 13.sp,
                              color: Colors.grey.shade400,
                            ),
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: Color(0xFFAE933F),
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 24.h),

                      InkWell(
                        onTap: () {
                          authCtrl.sendOtp();
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
                          child: (__.isLoading)
                              ? SizedBox(
                                  height: 20.h,
                                  width: 20.w,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  "Continue",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.sp,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),

                      Spacer(),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Column(
                          children: [
                            Text(
                              "Finest Shopping Destination in Qatar",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 11.sp,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              "MODEST WEAR • NIGHT WEARS • HIJABS",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 10.sp,
                                color: Color(0xFFAE933F),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30.h),
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
