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
          // Fix: Avoid division by zero which results in NaN
          final double height = (maxAmount > 0) 
              ? (data.amount / maxAmount) * 100 
              : 0;
              
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 30,
                height: height.isNaN ? 0 : height,
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
