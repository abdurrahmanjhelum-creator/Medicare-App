// Appointment Tabs Widget - Doctor Side (4 Tabs: Upcoming, Confirmed, Completed, Cancelled)
import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';

class AppointmentTabs extends StatelessWidget {
  final int selectedTab;
  final Function(int) onTabChanged;

  const AppointmentTabs({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPaddingHorizontal),
        padding: const EdgeInsets.all(AppDimensions.spacing4),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.02 * 255).round()),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _TabItem(
              title: 'Upcoming',
              isSelected: selectedTab == 0,
              onTap: () => onTabChanged(0),
            ),
            _TabItem(
              title: 'Confirmed',
              isSelected: selectedTab == 1,
              onTap: () => onTabChanged(1),
            ),
            _TabItem(
              title: 'Completed',
              isSelected: selectedTab == 2,
              onTap: () => onTabChanged(2),
            ),
            _TabItem(
              title: 'Cancelled',
              isSelected: selectedTab == 3,
              onTap: () => onTabChanged(3),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({
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
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing20,
          vertical: AppDimensions.spacing12,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius8),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? AppColors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
