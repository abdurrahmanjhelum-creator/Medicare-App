import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class DOBTextField extends StatelessWidget {
  final TextEditingController? controller;

  const DOBTextField({super.key, this.controller});

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && controller != null) {
      // ISO format: YYYY-MM-DD
      controller!.text = picked.toIso8601String().split('T')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Date of Birth",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 14),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border, width: 1.2),
            ),
            child: TextField(
              controller: controller,
              enabled: false, // Disable manual typing, use date picker
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Select your date of birth",
                hintStyle: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.calendar_today_outlined,
                    color: AppColors.textSecondary,
                    size: 25,
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(minWidth: 20),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                disabledBorder: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
