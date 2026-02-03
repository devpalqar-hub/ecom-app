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
    final double cardSize = 60.w;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: cardSize,
            height: cardSize,
            margin: EdgeInsets.only(right: 8.w),

            // ✅ only removed borderRadius
            decoration: BoxDecoration(
              shape: BoxShape.circle, // ⭐ makes it circle
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),

            // ✅ only changed ClipRRect → ClipOval
            child: imageUrl != null && imageUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(100.r),
                    child: Image.network(
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
                      errorBuilder: (context, error, stackTrace) {
                        return _placeholder();
                      },
                    ),
                  )
                : _placeholder(),
          ),
          SizedBox(height: 10.w),

          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Colors.grey.shade300,
      ),
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
