import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_dimensions.dart';
import '../../utils/validators.dart';

class PasswordTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const PasswordTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.validator,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
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
            controller: widget.controller,
            obscureText: _isObscure,
            validator: widget.validator ?? Validators.validatePassword,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.hintText,
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
                  Icons.lock_outline,
                  color: AppColors.textSecondary,
                  size: AppDimensions.iconSize24,
                ),
              ),
              suffixIcon: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacing8,
                ),
                child: IconButton(
                  onPressed: () => setState(() => _isObscure = !_isObscure),
                  icon: Icon(
                    _isObscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.textSecondary,
                    size: AppDimensions.iconSize24,
                  ),
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: AppDimensions.spacing20,
              ),
              suffixIconConstraints: const BoxConstraints(
                minWidth: AppDimensions.spacing32,
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
