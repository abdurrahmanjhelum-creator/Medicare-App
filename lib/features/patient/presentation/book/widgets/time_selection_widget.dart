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
          const SizedBox(height: 16),

          // Empty state
          if (timeSlots.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Icon(Icons.schedule, size: 40, color: Colors.grey.shade400),
                    const SizedBox(height: 8),
                    Text(
                      'Is doctor ne abhi koi time slot set nahi kiya.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                    ),
                  ],
                ),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: timeSlots.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.8,
                crossAxisSpacing: 15,
                mainAxisSpacing: 12,
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
                        fontSize: 12,
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
