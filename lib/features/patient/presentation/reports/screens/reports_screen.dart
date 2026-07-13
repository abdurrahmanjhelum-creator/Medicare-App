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
    final reportState = ref.watch(reportProvider);
    final reportNotifier = ref.read(reportProvider.notifier);

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
            child: RefreshIndicator(
              onRefresh: () => reportNotifier.fetchReports(),
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
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('File upload feature coming soon'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
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
                    if (reportState.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (reportState.error != null && reportState.reports.isEmpty)
                      Column(
                        children: [
                          const SizedBox(height: 60),
                          const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                          const SizedBox(height: 12),
                          Text('Failed to load reports', style: TextStyle(color: Colors.grey[600])),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () => reportNotifier.fetchReports(),
                            child: const Text('Retry'),
                          ),
                        ],
                      )
                    else if (reportState.reports.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: Text('No reports available', style: TextStyle(color: Colors.grey)),
                        ),
                      )
                    else
                      ...reportState.reports.map(
                        (report) => ReportCard(
                          title: report.title,
                          category: report.category,
                          date: report.date,
                          doctorName: report.doctorName,
                          status: report.status,
                          onDownload: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Download feature coming soon'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          onShare: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Share feature coming soon'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
