import 'package:flutter/material.dart';

// ======================================================
// ROLE BUTTON WIDGET
// ======================================================

class RoleButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleButton({
    super.key,

    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),

        height: 50,

        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F8F3) : Colors.white,

          borderRadius: BorderRadius.circular(10),

          border: Border.all(
            color: isSelected
                ? const Color(0xFF129A74)
                : const Color(0xFFE5E7EB),

            width: isSelected ? 2 : 1.3,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),

              blurRadius: 8,

              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Center(
          child: Text(
            title,

            style: TextStyle(
              fontSize: 16,

              fontWeight: FontWeight.w600,

              color: isSelected
                  ? const Color(0xFF129A74)
                  : const Color(0xFF0D1B3D),
            ),
          ),
        ),
      ),
    );
  }
}
