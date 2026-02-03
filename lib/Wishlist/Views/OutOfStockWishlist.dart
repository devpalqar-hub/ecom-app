
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OutOfStockWishlistTile extends StatelessWidget {
  const OutOfStockWishlistTile({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.mrp,
    this.onNotify,
    this.onMinus,
    this.onPlus,
    this.quantity = 1,
  });

  final String imageUrl;
  final String title;
  final double price;
  final double mrp;
  final VoidCallback? onNotify;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: 0.5, 
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
      
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 64,
                  height: 64,
                  color: const Color(0xFFF2F2F2),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: onMinus,
                            icon: const Icon(Icons.remove, size: 18),
                            splashRadius: 18,
                          ),
                          Text(
                            quantity.toString().padLeft(2, '0'),
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          IconButton(
                            onPressed: onPlus,
                            icon: const Icon(Icons.add, size: 18),
                            splashRadius: 18,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
        
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₹${price.toStringAsFixed(0)}",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF8C8C8C),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "₹${mrp.toStringAsFixed(0)}",
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: const Color(0xFFBDBDBD),
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
       
        Positioned(
          right: 0,
          top: 0,
          child: TextButton(
            onPressed: onNotify,
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFC17D4A),
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              "Notify me",
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
