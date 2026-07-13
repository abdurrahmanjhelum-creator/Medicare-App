// Doctor Patients Screen - 100% Functional Patient List
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../controllers/patient_controller.dart';
import '../widgets/patient_card.dart';
import '../widgets/search_bar.dart';
import 'patient_details_screen.dart';

class DoctorPatientsScreen extends ConsumerStatefulWidget {
  const DoctorPatientsScreen({super.key});

  @override
  ConsumerState<DoctorPatientsScreen> createState() => _DoctorPatientsScreenState();
}

class _DoctorPatientsScreenState extends ConsumerState<DoctorPatientsScreen> {
  @override
  void initState() {
    super.initState();
    // Patients load karein
    Future.microtask(() => ref.read(doctorPatientProvider.notifier).loadPatients());
  }

  @override
  Widget build(BuildContext context) {
    final patientState = ref.watch(doctorPatientProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const Text(
          'My Patients',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(doctorPatientProvider.notifier).loadPatients(),
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPaddingHorizontal,
                vertical: AppDimensions.spacing16,
              ),
              child: DoctorSearchBar(
                onSearch: (query) {
                  ref.read(doctorPatientProvider.notifier).searchPatients(query);
                },
              ),
            ),

            // Patients list
            Expanded(
              child: patientState.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : patientState.error != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Error: ${patientState.error}',
                                style: const TextStyle(color: Colors.red),
                              ),
                              ElevatedButton(
                                onPressed: () => ref.read(doctorPatientProvider.notifier).loadPatients(),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : patientState.patients.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'No patients found',
                                    style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.screenPaddingHorizontal,
                              ),
                              itemCount: patientState.patients.length,
                              itemBuilder: (context, index) {
                                final patient = patientState.patients[index];
                                return PatientCard(
                                  patient: patient,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PatientDetailsScreen(patient: patient),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
