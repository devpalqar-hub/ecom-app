import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_project/User/MyOrder/Model/OrderModel.dart';

class OrderCard extends StatelessWidget {
  final VoidCallback? onTap;
  final String orderId;
  final String date;
  final String productName;
  final String? productImage;
  final int quantity;
  final double price;
  final String status;
  final String estimatedDelivery;
  final bool showTrackButton;

  final OrderItem firstItem; // ✅ FROM ORDERMODEL ONLY

  final String? variationSize;
  final String? variationColor;
  final String? variationColorHex;

  const OrderCard({
    super.key,
    required this.orderId,
    required this.date,
    required this.productName,
    this.productImage,
    required this.quantity,
    required this.price,
    required this.status,
    this.estimatedDelivery = '',
    this.showTrackButton = false,
    this.onTap,
    required this.firstItem, // ✅
    this.variationSize,
    this.variationColor,
    this.variationColorHex,
  });

  String? _getDisplayImage() {
    // 1. Variation image FIRST
    final variationImages = firstItem.productVariation?.images;
    if (variationImages != null && variationImages.isNotEmpty) {
      return variationImages.first;
    }

    // 2. Product image
    final productImages = firstItem.product.images;
    if (productImages.isNotEmpty) {
      return productImages.first.url;
    }

    return productImage;
  }

  @override
  Widget build(BuildContext context) {
    final displayImage = _getDisplayImage();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: (displayImage != null && displayImage.isNotEmpty)
                  ? Image.network(
                      displayImage,
                      width: 60.w,
                      height: 60.w,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 60.w,
                      height: 60.w,
                      color: Colors.grey.shade200,
                      child: Icon(Icons.image),
                    ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(productName),
                  Text("Qty: $quantity"),
                ],
              ),
            ),
            Text("QAR $price"),
          ],
        ),
      ),
    );
  }
}