import 'package:flutter/material.dart';

// =====================================================
// REUSABLE CUSTOM BUTTON WIDGET
// =====================================================

class LoginButton extends StatelessWidget {
  final double height;
  final double width;
  final String text;
  final VoidCallback onTap;

  const LoginButton({
    super.key,
    required this.height,
    required this.width,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        height: height,
        width: width,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),

          gradient: const LinearGradient(
            colors: [Color(0xFF129A74), Color(0xFF22C7B8)],
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
