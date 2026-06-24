// Earnings Chart Widget - Earnings chart widget
import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../models/dashboard_model.dart';

class EarningsChart extends StatelessWidget {
  final List<EarningStats> earningsData;

  const EarningsChart({
    super.key,
    required this.earningsData,
  });

  @override
  Widget build(BuildContext context) {
    if (earningsData.isEmpty) {
      return const SizedBox(
        height: 150,
        child: Center(
          child: Text('No data available'),
        ),
      );
    }

    final maxAmount = earningsData.map((e) => e.amount).reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: earningsData.map((data) {
          final height = (data.amount / maxAmount) * 100;
          return Column(
            children: [
              Container(
                width: 30,
                height: height,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadius8),
                ),
              ),
              const SizedBox(height: AppDimensions.spacing8),
              Text(
                data.date,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
