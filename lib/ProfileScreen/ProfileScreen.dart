import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_project/CartScreen/AddressFormScreen.dart';
import 'package:new_project/CartScreen/Services/CheckoutController.dart';
import 'package:new_project/LoginScreen/LoginScreen.dart';
import 'package:new_project/MyOrder/MyOrderScreen.dart';
import 'package:new_project/ProfileScreen/AddressListScreen.dart';
import 'package:new_project/ProfileScreen/Service/ProfileController.dart';
import 'package:new_project/Wishlist/WishlistScreen.dart';
import 'package:new_project/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final UserProfileController controller = Get.put(UserProfileController());
  final CheckoutController checkController = Get.put(CheckoutController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // centerTitle: true,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        //   onPressed: () => Get.back(),
        // ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: "Inter",
          ),
        ),
      ),

      body: SafeArea(
        child: Obx(() {
          final profile = controller.profile.value;
          final customer = profile?.data.customerProfile;

          return CustomScrollView(
            slivers: [
              // App Bar / Header
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color(0xFFAE933F),
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 30.r,
                              backgroundColor: Color(0xFFFFF4E6),
                              backgroundImage: customer?.profilePicture != null
                                  ? NetworkImage(customer!.profilePicture!)
                                  : null,
                              child: customer?.profilePicture == null
                                  ? Text(
                                      (customer?.name != null &&
                                              customer!.name!.isNotEmpty
                                          ? customer.name![0].toUpperCase()
                                          : "G"),
                                      style: TextStyle(
                                        fontSize: 28.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFAE933F),
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  customer?.name ?? "Guest User",
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  profile?.data.email ?? "Not available",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey.shade600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (controller.isLoading.value)
                                  Padding(
                                    padding: EdgeInsets.only(top: 8.h),
                                    child: SizedBox(
                                      height: 16.h,
                                      width: 16.h,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xFFAE933F),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SliverPadding(
                padding: EdgeInsets.all(16.w),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(height: 8.h),

                    // Account Section
                    _buildSectionCard(
                      title: "Account",
                      items: [
                        _ProfileMenuItem(
                          icon: Icons.receipt_long_outlined,
                          title: 'My Orders',
                          onTap: () => Get.to(() => MyOrderScreen()),
                        ),
                        _ProfileMenuItem(
                          icon: Icons.location_on_outlined,
                          title: 'Delivery Addresses',
                          onTap: () async {
                            await checkController.fetchAddresses();
                            if (checkController.addresses.isNotEmpty) {
                              Get.to(() => AddressListScreen());
                            } else {
                              Get.to(() => AddressFormScreen());
                            }
                          },
                        ),
                        _ProfileMenuItem(
                          icon: Icons.favorite_outline,
                          title: 'Saved Items',
                          onTap: () => Get.to(() => WishlistScreen()),
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),

                    // Settings Section
                    // _buildSectionCard(
                    //   title: "Settings",
                    //   items: [
                    //     _ProfileMenuItem(
                    //       icon: Icons.language_outlined,
                    //       title: 'Language',
                    //       subtitle: 'English',
                    //       onTap: () {
                    //         _showLanguageDialog(context);
                    //       },
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: 16.h),

                    // Support & Legal Section
                    _buildSectionCard(
                      title: "Support & Legal",
                      items: [
                        _ProfileMenuItem(
                          icon: Icons.privacy_tip_outlined,
                          title: 'Privacy Policy',
                          onTap: () async {
                            // URL: https://raheeb.qa/privacy-policy
                            // You can use url_launcher package or open in webview
                            launchUrl(
                              Uri.parse("https://raheeb.qa/privacy-policy"),
                            );
                          },
                        ),
                        _ProfileMenuItem(
                          icon: Icons.location_on_outlined,
                          title: 'Store Location',
                          onTap: () async {
                            // URL: https://maps.app.goo.gl/ffNzAvLFmeQ4WDMu9
                            // You can use url_launcher package
                            launchUrl(
                              Uri.parse(
                                "https://maps.app.goo.gl/ffNzAvLFmeQ4WDMu9",
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),

                    // Social Media Section
                    _buildSectionCard(
                      title: "Follow Us",
                      items: [
                        _ProfileMenuItem(
                          icon: Icons.facebook_outlined,
                          title: 'Facebook',
                          onTap: () async {
                            // URL: https://www.facebook.com/share/1FmbzSst33/
                            launchUrl(
                              Uri.parse(
                                "https://www.facebook.com/share/1FmbzSst33/",
                              ),
                            );
                          },
                        ),
                        _ProfileMenuItem(
                          icon: Icons.camera_alt_outlined,
                          title: 'Instagram',
                          onTap: () async {
                            // URL: https://www.instagram.com/raheeb.qa_?igsh=dXRuMHhwY2Q1eWQ=
                            launchUrl(
                              Uri.parse(
                                "https://www.instagram.com/raheeb.qa_?igsh=dXRuMHhwY2Q1eWQ=",
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 24.h),

                    // Logout Button
                    _buildLogoutButton(context),
                    SizedBox(height: 24.h),
                    _buildDeleteButton(context),

                    SizedBox(height: 24.h),
                  ]),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<_ProfileMenuItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 12.h),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isLast = index == items.length - 1;
              return Column(
                children: [
                  _buildMenuItem(
                    icon: item.icon,
                    title: item.title,
                    subtitle: item.subtitle,
                    onTap: item.onTap,
                  ),
                  if (!isLast)
                    Padding(
                      padding: EdgeInsets.only(left: 60.w),
                      child: Divider(height: 1, color: Colors.grey.shade200),
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Color(0xFFFFF4E6),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, size: 22.sp, color: Color(0xFFAE933F)),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _logout(context),
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.logout,
                  size: 22.sp,
                  color: Colors.red.shade600,
                ),
              ),
              SizedBox(width: 16.w),
              Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.red.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Get.dialog(
            Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              backgroundColor: Colors.white,
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Warning Icon ──
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.red.shade600,
                        size: 32.sp,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // ── Title ──
                    Text(
                      "Delete Account?",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // ── Message ──
                    Text(
                      "Are you sure you want to delete your account? Your account will be permanently deleted in 30 days. You can cancel this process anytime within 30 days simply by logging back in.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 28.h),

                    // ── Action Buttons ──
                    Row(
                      children: [
                        // Cancel Button
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            onPressed: () => Get.back(), // Close dialog
                            child: Text(
                              "Cancel",
                              style: GoogleFonts.montserrat(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),

                        // Delete Button
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade600,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            onPressed: () async {
                              accessToken = null;

                              var pref = await SharedPreferences.getInstance();
                              pref.clear();

                              Get.delete<UserProfileController>(force: true);

                              Get.offAll(() => LoginScreen());
                            },
                            child: Text(
                              "Delete",
                              style: GoogleFonts.montserrat(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Prevents dismissing by tapping outside if you want to force a button press
            barrierDismissible: false,
          );
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.delete_outline,
                  size: 22.sp,
                  color: Colors.red.shade600,
                ),
              ),
              SizedBox(width: 16.w),
              Text(
                'Delete Account',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.red.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Log out?',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.sp),
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              accessToken = null;

              var pref = await SharedPreferences.getInstance();
              pref.clear();

              Get.delete<UserProfileController>(force: true);

              Get.offAll(() => LoginScreen());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  // Language Selection Dialog
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Container(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFF4E6),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.language_outlined,
                        size: 24.sp,
                        color: Color(0xFFAE933F),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Select Language',
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                _buildLanguageOption(
                  context,
                  language: 'English',
                  flag: '🇬🇧',
                  isSelected: true,
                ),
                SizedBox(height: 12.h),
                _buildLanguageOption(
                  context,
                  language: 'العربية',
                  subtitle: 'Arabic (Qatar)',
                  flag: '🇶🇦',
                  isSelected: false,
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
    BuildContext context, {
    required String language,
    String? subtitle,
    required String flag,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        // Handle language change here
        Navigator.pop(context);
        Get.snackbar(
          'Language Changed',
          'Language changed to $language',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Color(0xFFAE933F),
          colorText: Colors.white,
          margin: EdgeInsets.all(16.w),
          borderRadius: 12.r,
          duration: Duration(seconds: 2),
        );
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFFFF4E6) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? Color(0xFFAE933F) : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: TextStyle(fontSize: 28.sp)),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language,
                    style: GoogleFonts.poppins(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Color(0xFFAE933F) : Colors.black87,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: Color(0xFFAE933F), size: 22.sp),
          ],
        ),
      ),
    );
  }
}

class _ProfileMenuItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  _ProfileMenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });
}
