import 'package:flutter/material.dart';

class AboutDoctor extends StatelessWidget {
  final String bio;
  final String branch;

  const AboutDoctor({super.key, required this.bio, required this.branch});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with Icon
          const Row(
            children: [
              Icon(Icons.bookmark_outline, color: Color(0xff089B73), size: 22),
              SizedBox(width: 8),
              Text(
                "About",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D1B3D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Bio Text
          Text(
            bio,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              height: 1.6,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 15),
          // Location/Branch Row
          Row(
            children: [
              Icon(Icons.location_on_outlined, color: Colors.black, size: 20),
              const SizedBox(width: 8),
              Text(
                branch,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
