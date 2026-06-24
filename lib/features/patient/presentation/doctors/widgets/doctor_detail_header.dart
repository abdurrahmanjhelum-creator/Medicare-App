import 'package:flutter/material.dart';
import '../../../../../core/widgets/common/cached_image_widget.dart';

class DoctorDetailHeader extends StatelessWidget {
  final String title; // Doctor ka Naam
  final String field; // Shoba (e.g., Cardiologist)
  final String imagePath; // Image ka path
  final double rating; // Rating (4.5)
  final int reviews; // Reviews ki tadad (120)
  final Widget? leading; // Back Button ke liye
  final Color? firstColor; // Gradient start color
  final Color? secondColor; // Gradient end color

  const DoctorDetailHeader({
    super.key,
    required this.title,
    required this.field,
    required this.imagePath,
    required this.rating,
    required this.reviews,
    this.leading,
    this.firstColor,
    this.secondColor,
  });

  @override
  Widget build(BuildContext context) {
    // Check if imagePath is a network URL or asset
    final bool isNetworkImage = imagePath.startsWith('http');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            firstColor ?? const Color(0xff089B73),
            secondColor ?? const Color(0xff28C7C0),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Top Section (Back Button)
          if (leading != null) ...[leading!, const SizedBox(height: 15)],

          // 2. Doctor Info Section
          Row(
            children: [
              // White box for Image
              Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: isNetworkImage
                    ? DoctorProfileImage(imageUrl: imagePath, size: 90)
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.grey,
                              ),
                        ),
                      ),
              ),
              const SizedBox(width: 15),

              // Text Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      field,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Rating Row
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.orangeAccent,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "•  $reviews reviews",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
