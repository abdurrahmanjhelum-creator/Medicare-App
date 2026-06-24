import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class TimeSelectionWidget extends StatelessWidget {
  final List<String> timeSlots;
  final String? selectedTime;
  final Function(String) onTimeSelected;

  const TimeSelectionWidget({
    super.key,
    required this.timeSlots,
    this.selectedTime,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.access_time_outlined,
                color: AppColors.primaryGreen,
                size: 20,
              ),
              const SizedBox(width: 10),
              const Text(
                'Select Time',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          GridView.builder(
            shrinkWrap:
                true, // Column ke andar GridView chalane ke liye zaroori hai
            physics:
                const NeverScrollableScrollPhysics(), // Scroll Column karega, Grid nahi
            itemCount: timeSlots.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Ek row mein 3 slots
              childAspectRatio:
                  1.8, // Box ki shape (width aur height ka balance)
              crossAxisSpacing: 15, // Horizontal gap
              mainAxisSpacing: 30, // Vertical gap
            ),
            itemBuilder: (context, index) {
              final time = timeSlots[index];
              final isSelected = selectedTime == time;

              return InkWell(
                onTap: () => onTimeSelected(time),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryGreen
                        : AppColors.scaffoldBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryGreen
                          : AppColors.border,
                    ),
                  ),
                  child: Text(
                    time,
                    style: TextStyle(
                      fontSize: 13,
                      color: isSelected
                          ? AppColors.white
                          : AppColors.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ),
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
