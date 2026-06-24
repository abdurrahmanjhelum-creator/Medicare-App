import 'package:flutter/material.dart';
import 'summary_card.dart';

class SummarySection extends StatelessWidget {
  final Color textColor;

  const SummarySection({
    super.key,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SummaryCard(
            title: "Appointments",
            value: "12",
            icon: Icons.calendar_today_rounded,
            accentColor: const Color(0xFF4A80F5),
            textColor: textColor,
          ),
          SummaryCard(
            title: "Lab Reports",
            value: "08",
            icon: Icons.analytics_outlined,
            accentColor: const Color(0xFFFF9F43),
            textColor: textColor,
          ),
          SummaryCard(
            title: "Prescriptions",
            value: "05",
            icon: Icons.medication_liquid_rounded,
            accentColor: const Color(0xFF11A683),
            textColor: textColor,
          ),
        ],
      ),
    );
  }
}
