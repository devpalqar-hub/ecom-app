import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderSummaryCard extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const OrderSummaryCard({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {

    final validItems =
        items.where((item) => (item['qty'] as int) > 0).toList();

  
    final int totalQty = validItems.fold(
      0,
      (sum, item) => sum + (item['qty'] as int),
    );

   
    final double grandTotal = validItems.fold(
      0.0,
      (sum, item) =>
          sum + ((item['qty'] as int) * (item['price'] as double)),
    );

    if (validItems.isEmpty) {
      return const SizedBox.shrink(); 
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: const Color(0xffECECEC),
          width: 1.w,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        children: [
         
          for (int i = 0; i < validItems.length; i++) ...[
            _buildItem(
              title: validItems[i]['title'],
              qty: validItems[i]['qty'],
              unitPrice: validItems[i]['price'],
            ),
            if (i != validItems.length - 1)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Divider(
                  color: Colors.grey.shade300,
                  thickness: 1,
                ),
              ),
          ],

      
          if (totalQty > 0) ...[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Divider(
                color: Colors.grey.shade400,
                thickness: 1.2,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total ($totalQty items)',
                  style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Text(
                  ' QAR${grandTotal.toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildItem({
    required String title,
    required int qty,
    required double unitPrice,
  }) {
    final double totalPrice = qty * unitPrice;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              ' QAR${totalPrice.toStringAsFixed(0)}',
              style: GoogleFonts.poppins(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        SizedBox(height: 4.h),

     
        Text(
          'Qty: $qty × QAR ${unitPrice.toStringAsFixed(0)}',
          style: GoogleFonts.poppins(
            fontSize: 13.sp,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
