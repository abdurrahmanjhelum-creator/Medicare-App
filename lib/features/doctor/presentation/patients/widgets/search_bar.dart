// Doctor Search Bar Widget - Search bar widget
import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';

class DoctorSearchBar extends StatelessWidget {
  final Function(String) onSearch;

  const DoctorSearchBar({
    super.key,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).round()),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: onSearch,
        decoration: const InputDecoration(
          hintText: 'Search patients...',
          hintStyle: TextStyle(
            color: AppColors.textSecondary,
          ),
          border: InputBorder.none,
          icon: Icon(
            Icons.search,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
