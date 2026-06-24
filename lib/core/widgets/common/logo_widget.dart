import 'package:flutter/material.dart';

// REUSABLE LOGO WIDGET
// =====================================================

class AppLogo extends StatelessWidget {
  final double height;
  final double width;
  final Color iconcolor;
  final Color backgroundcolor;
  final IconData icon;

  const AppLogo({
    super.key,
    required this.height,
    required this.width,
    required this.iconcolor,
    required this.backgroundcolor,
    required this.icon,

  });

  @override
  Widget build(BuildContext context) {
 

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: backgroundcolor,
        borderRadius: BorderRadius.circular(20),
      ),

      // CENTER ICON PERFECTLY
      child: Center(
        child: Icon(
          icon,
          color: iconcolor,

          // PERFECT ICON SIZE
          size: height * 0.78,
        ),
      ),
    );
  }
}
