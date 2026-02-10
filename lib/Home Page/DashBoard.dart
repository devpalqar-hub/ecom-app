import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:new_project/CartScreen/CartScreen.dart';
import 'package:new_project/Home%20Page/HomePage.dart';
import 'package:new_project/MyOrder/MyOrderScreen.dart';
import 'package:new_project/ProfileScreen/ProfileScreen.dart';
import 'package:new_project/Wishlist/WishlistScreen.dart';
import 'package:new_project/main.dart';

// void main() {
//   runApp(const MaterialApp(home: DashBoard()));
// }

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    WishlistScreen(),
    CartScreen(),
    MyOrderScreen(showback: false),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setFcm();
  }

  setFcm() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();

      final response = await post(
        Uri.parse(baseUrl + "/users/fcm-token/users/"),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
        body: json.encode({"token": token}),
      );

      print('FCM Token Response Status: ${response.statusCode}');
      print('FCM Token Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('FCM token sent successfully');
      } else {
        print('Failed to send FCM token to backend');
      }
    } catch (e) {
      print('Error sending FCM token to backend: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_selectedIndex]),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 65.h,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10.r,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(
                icon: Icons.storefront_outlined,
                label: 'Home',
                index: 0,
              ),
              _navItem(
                icon: Icons.favorite_outline,
                label: 'Wishlist',
                index: 1,
              ),
              _navItem(
                icon: Icons.shopping_bag_outlined,
                label: 'Cart',
                index: 2,
              ),
              _navItem(
                icon: Icons.receipt_long_outlined,
                label: 'Orders',
                index: 3,
              ),
              _navItem(icon: Icons.person_outline, label: 'Profile', index: 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24.sp,
              color: isSelected ? Color(0xFFAE933F) : Color(0xFF9E9E9E),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 10.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? Color(0xFFAE933F) : Color(0xFF9E9E9E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
