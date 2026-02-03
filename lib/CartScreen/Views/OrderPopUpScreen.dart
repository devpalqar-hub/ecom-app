import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_project/Home%20Page/DashBoard.dart';


class OrderSuccessPopup extends StatelessWidget {
  final String orderNumber;
  final double amount;

  const OrderSuccessPopup({
    super.key,
    required this.orderNumber,
    required this.amount,
  });

  void _goDashboard() {
   
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
   
    Get.offAll(() => const DashBoard());
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [

          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  const SizedBox(height: 12),

                
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color(0xffC17D4A),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    "Payment Successful!",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Your order has been confirmed",
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 20),

                  _infoRow("Order Number", orderNumber),
                  _infoRow(
                    "Amount Paid",
                    "QAR ${amount.toStringAsFixed(0)}",
                  ),

                  const SizedBox(height: 20),

                 SizedBox(height: 15.h,),

                  Text(
                    "We've prepared your package with care.\nThank you for your order!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(color: Colors.black),
                  ),

                  const SizedBox(height: 20),

                
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _goDashboard,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xffC17D4A),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        "Continue Shopping →",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

         
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: _goDashboard,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(color: Colors.grey),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final String title;
  final bool active;

  const _Step({
    required this.title,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: active
              ? const Color(0xff9B1357)
              : Colors.grey.shade300,
          child: Icon(
            Icons.check,
            size: 14,
            color: active ? Colors.white : Colors.grey,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: active
                ? const Color(0xff9B1357)
                : Colors.grey,
          ),
        ),
      ],
    );
  }
}
