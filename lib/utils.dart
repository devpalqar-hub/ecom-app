import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_project/LoginScreen/LoginScreen.dart';

void showLoginDialog() {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon Header
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFFAE933F).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_person_rounded,
                color: const Color(0xFFAE933F),
                size: 32.sp,
              ),
            ),
            SizedBox(height: 20.h),

            // Title
            Text(
              "Login Required",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 18.sp,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12.h),

            // Subtitle / Description
            Text(
              "To access the finest shopping experience in Qatar, please login to your account.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 13.sp,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            SizedBox(height: 28.h),

            // Action Buttons
            Column(
              children: [
                // Proceed Button (Primary)
                InkWell(
                  onTap: () {
                    Get.back();
                    Get.to(() => LoginScreen());
                  },
                  child: Container(
                    height: 48.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFAE933F),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      "Proceed to Login",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),

                // Skip/Continue Guest Button (Secondary)
                TextButton(
                  onPressed: () => Get.back(),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey.shade600,
                  ),
                  child: Text(
                    "Continue as Guest",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      //  decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: true,
  );
}
