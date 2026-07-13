import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/common/header.dart';
import '../../../../../core/widgets/common/back_button.dart';
import '../../../controllers/medical_record_controller.dart';

class PrescriptionsScreen extends ConsumerWidget {
  const PrescriptionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordState = ref.watch(patientMedicalRecordProvider);
    final recordNotifier = ref.read(patientMedicalRecordProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Column(
        children: [
          DoctorListHeader(
            title: "Prescriptions",
            shortText: "View your medical prescriptions and diagnosis",
            showSearch: false,
            leading: BackToLoginButton(
              onTap: () => Navigator.pop(context),
              text: "Back",
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => recordNotifier.fetchMyMedicalRecords(),
              child: recordState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : recordState.error != null && recordState.records.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(recordState.error!),
                              ElevatedButton(
                                onPressed: () => recordNotifier.fetchMyMedicalRecords(),
                                child: const Text("Retry"),
                              ),
                            ],
                          ),
                        )
                      : recordState.records.isEmpty
                          ? const Center(child: Text("No prescriptions found"))
                          : ListView.builder(
                              padding: const EdgeInsets.all(20),
                              itemCount: recordState.records.length,
                              itemBuilder: (context, index) {
                                final record = recordState.records[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Dr. ${record.doctorName}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          Text(
                                            record.createdAt.split('T')[0],
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(height: 20),
                                      const Text(
                                        "Diagnosis:",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryGreen,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        record.diagnosis,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        "Prescription:",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryGreen,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        record.prescription,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      if (record.notes.isNotEmpty) ...[
                                        const SizedBox(height: 12),
                                        const Text(
                                          "Notes:",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          record.notes,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                );
                              },
                            ),
            ),
          ),
        ],
      ),
    );
  }
}
