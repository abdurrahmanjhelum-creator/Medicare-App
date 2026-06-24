import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/core/providers/providers.dart';
import 'package:medicare/features/patient/presentation/reports/widgets/report_card.dart';
import 'package:medicare/core/widgets/common/back_button.dart';
import 'package:medicare/core/widgets/common/header.dart';

class LabReportsScreen extends ConsumerWidget {
  const LabReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportController = ref.watch(reportProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: Column(
        children: [
          DoctorListHeader(
            title: "Lab Reports",
            shortText: "Your Health Reports",
            hintText: "Search",
            leading: BackToLoginButton(
              onTap: () => Navigator.pop(context),
              text: "Back",
            ),
            firstColor: const Color(0xff089B73),
            secondColor: const Color(0xff28C7C0),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF089B73), Color(0xFF28C7C0)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF089B73).withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.file_upload_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                      label: const Text(
                        "Upload Report",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ...reportController.reports.map(
                    (report) => ReportCard(
                      title: report.title,
                      category: report.category,
                      date: report.date,
                      doctorName: report.doctorName,
                      status: report.status,
                      onDownload: () {},
                      onShare: () {},
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
