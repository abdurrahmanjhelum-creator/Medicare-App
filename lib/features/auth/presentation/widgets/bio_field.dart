import 'package:flutter/material.dart';

class BioField extends StatelessWidget {
  final TextEditingController? controller;

  const BioField({
    super.key,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "About Yourself",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 14),
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
            ),
          ),
          child: TextField(
            controller: controller,
            maxLines: 5,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Write about your experience...",
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }
}