import 'package:flutter/material.dart';
import '../../../../../core/routes/app_routes.dart';
import 'summary_card.dart';

class SummarySection extends StatelessWidget {
  final Color textColor;
  final int appointments;
  final int labReports;
  final int prescriptions;

  const SummarySection({
    super.key,
    required this.textColor,
    required this.appointments,
    required this.labReports,
    required this.prescriptions,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SummaryCard(
            title: "Appointments",
            value: appointments.toString().padLeft(2, '0'),
            icon: Icons.calendar_today_rounded,
            accentColor: const Color(0xFF4A80F5),
            textColor: textColor,
            onTap: () => Navigator.pushNamed(context, AppRoutes.appointment),
          ),
          SummaryCard(
            title: "Lab Reports",
            value: labReports.toString().padLeft(2, '0'),
            icon: Icons.analytics_outlined,
            accentColor: const Color(0xFFFF9F43),
            textColor: textColor,
            onTap: () => Navigator.pushNamed(context, AppRoutes.reports),
          ),
          SummaryCard(
            title: "Prescriptions",
            value: prescriptions.toString().padLeft(2, '0'),
            icon: Icons.medication_liquid_rounded,
            accentColor: const Color(0xFF11A683),
            textColor: textColor,
            onTap: () => Navigator.pushNamed(context, AppRoutes.prescriptions),
          ),
        ],
      ),
    );
  }
}
