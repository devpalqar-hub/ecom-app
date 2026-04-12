import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryCard extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String description;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double cardSize = 60.w; // Fixed circle size
    final double cardWidth = 70.w; // Fixed width for the whole card

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: cardWidth, // fix the card width
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Circle Image
            SizedBox(
              width: cardSize,
              height: cardSize,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: imageUrl != null && imageUrl!.isNotEmpty
                      ? Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: SizedBox(
                                width: 15.w,
                                height: 15.h,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) => _placeholder(),
                        )
                      : _placeholder(),
                ),
              ),
            ),
            SizedBox(height: 6.h),

            // Category title - max 2 lines
            Text(
              title,
              maxLines: 2, // allow 2 lines
              overflow: TextOverflow.ellipsis, // ellipsis if too long
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: Colors.grey.shade300,
      child: Center(
        child: Icon(
          Icons.image_not_supported,
          color: Colors.grey.shade600,
          size: 20.sp,
        ),
      ),
    );
  }
}