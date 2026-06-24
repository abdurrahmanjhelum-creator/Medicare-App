import 'package:flutter/material.dart';

class BackToLoginButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const BackToLoginButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

     
        child: Row(
          mainAxisSize: MainAxisSize.min,

          children: [

             Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
            // BACK ARROW
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: Color(0xFF64748B),
            ),
          ),

            const SizedBox(width: 10),

            // TEXT
            Text(
              text,

              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF475569),
              ),
            ),
              
          ],
        ),
      );
  
  }
}
