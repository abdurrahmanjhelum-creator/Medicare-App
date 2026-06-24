import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_dimensions.dart';
import '../../constants/app_strings.dart';
import '../../utils/validators.dart';

class EmailTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const EmailTextField({super.key, this.controller, this.validator});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.email,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacing12),
        Container(
          height: AppDimensions.textFieldHeight,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radius10),
            border: Border.all(
              color: AppColors.border,
              width: AppDimensions.strokeWidth1,
            ),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            validator: validator ?? Validators.validateEmail,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Enter your email",
              hintStyle: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacing8,
                ),
                child: Icon(
                  Icons.email_outlined,
                  color: AppColors.textSecondary,
                  size: AppDimensions.iconSize24,
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: AppDimensions.spacing20,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: AppDimensions.spacing12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
