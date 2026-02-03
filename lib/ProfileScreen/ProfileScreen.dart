import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_project/CartScreen/AddressFormScreen.dart';
import 'package:new_project/CartScreen/Services/CheckoutController.dart';
import 'package:new_project/LoginScreen/LoginScreen.dart';
import 'package:new_project/LoginScreen/Service/AuthenticationController.dart';
import 'package:new_project/MyOrder/MyOrderScreen.dart';
import 'package:new_project/ProfileScreen/AddressListScreen.dart';
import 'package:new_project/ProfileScreen/Service/ProfileController.dart';
import 'package:new_project/Wishlist/WishlistScreen.dart';
import 'package:new_project/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final UserProfileController controller = Get.put(UserProfileController());
  final CheckoutController checkController = Get.put(CheckoutController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          final profile = controller.profile.value;
          final customer = profile?.data.customerProfile;

          return ListView(
            padding: EdgeInsets.all(20),
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30.r,
                    backgroundColor: Colors.grey.shade400,
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
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),

                  SizedBox(width: 16.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer?.name ?? "Guest User",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        profile?.data.email ?? "Not available",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      if (controller.isLoading.value)
                        Padding(
                          padding: EdgeInsets.only(top: 6.h),
                          child: SizedBox(
                            height: 14.h,
                            width: 14.h,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 20.h),
              Divider(color: Colors.grey.shade300, thickness: 1.h),
              SizedBox(height: 20.h),

              _sectionTitle("Account"),
              SizedBox(height: 20.h),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    _accountItem(
                      'My Orders',
                      Icons.history_outlined,
                      () => Get.to(() => MyOrderScreen()),
                    ),
                    _accountItem(
                      'Delivery Addresses',
                      Icons.location_on_outlined,
                      () async {
                        await checkController.fetchAddresses();
                        if (checkController.addresses.isNotEmpty) {
                          Get.to(() => AddressListScreen());
                        } else {
                          Get.to(() => AddressFormScreen());
                        }
                      },
                    ),
                    _accountItem(
                      'Saved Items',
                      Icons.favorite_border,
                      () => Get.to(() => WishlistScreen()),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: Text(
                    'Log Out',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      color: Colors.red,
                    ),
                  ),
                  onTap: () => _logout(context),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  static Widget _accountItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  static void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xffC47C47)),
            ),
          ),
          TextButton(
            onPressed: () async {
              accessToken = null;

              var pref = await SharedPreferences.getInstance();
              pref.clear();

              Get.delete<UserProfileController>(force: true);

              Get.offAll(() => LoginScreen());
            },

            child: const Text(
              'Log Out',
              style: TextStyle(color: Color(0xffC47C47)),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _sectionTitle(String title) {
  return Text(
    title,
    style: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.bold,
      color: Colors.grey.shade800,
    ),
  );
}
