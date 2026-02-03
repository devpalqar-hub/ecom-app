import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_project/CartScreen/CheckoutScreen.dart';
import 'package:new_project/Home%20Page/HomePage.dart';
import 'package:new_project/MyOrder/MyOrderScreen.dart';
import 'package:new_project/ProfileScreen/ProfileScreen.dart';
import 'package:new_project/Wishlist/WishlistScreen.dart';

void main() {
  runApp(const MaterialApp(home: DashBoard()));
}

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
    CheckoutScreen(),
    MyOrderScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(child: _pages[_selectedIndex]),
    bottomNavigationBar: SafeArea(
      child: Container(
        height: 70.h,
        decoration:  BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 4.r),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navIcon(icon: Icons.home_outlined, selectedIcon: Icons.home, index: 0),
            _navIcon(icon: Icons.favorite_border, selectedIcon: Icons.favorite, index: 1),
            _navIcon(icon: Icons.local_shipping, selectedIcon: Icons.local_shipping, index: 2),
            _navIcon(icon: Icons.card_giftcard, selectedIcon: Icons.card_giftcard, index: 3),
            _navIcon(icon: Icons.person_outline, selectedIcon: Icons.person, index: 4),
          ],
        ),
      ),
    ),
  );
}


  Widget _navIcon({
  required IconData icon,
  required IconData selectedIcon,
  required int index,
}) {
  final bool isSelected = _selectedIndex == index;

  return GestureDetector(
    onTap: () => _onItemTapped(index),
    child: SizedBox(
      width: 32.w,
      height: 32.h,
      child: isSelected
          ? Stack(
              alignment: Alignment.center,
              children: [
               
                Icon(
                  icon,
                  size: 30.sp,
                  color: const Color(0xffC17D4A), 
                ),

               
                Icon(
                  selectedIcon,
                  size: 26.sp, 
                  color: const Color(0xffF7D8C0),
                ),
              ],
            )
          : Icon(
              icon,
              size: 30.sp,
              color: const Color(0xff9E9E9E), 
            ),
    ),
  );
}


}
