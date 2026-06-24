import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class AvailableDaysWidget extends StatelessWidget {
  final List<String> days;

  const AvailableDaysWidget({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Icon
          const Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                color: Color(0xff089B73),
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                "Available Days",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D1B3D),
                ),
              ),
            ],
          ),

          // Days Grid (Exactly like the image style)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 columns
              childAspectRatio: 2.5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 12,
            ),
            itemCount: days.length,
            itemBuilder: (context, index) {
              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.primaryGreen, width: 1.2),
                ),
                child: Text(
                  days[index],
                  style: const TextStyle(
                    color: Color(0xff089B73),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
