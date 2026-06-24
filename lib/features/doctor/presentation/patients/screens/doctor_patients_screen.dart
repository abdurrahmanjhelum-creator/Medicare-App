// Doctor Patients Screen - Doctor patients screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../controllers/patient_controller.dart';
import '../widgets/patient_card.dart';
import '../widgets/search_bar.dart';

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
          'Patients',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
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
          const SizedBox(height: AppDimensions.spacing16),

          // Patients list
          Expanded(
            child: patientState.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : patientState.error != null
                    ? Center(
                        child: Text(
                          'Error: ${patientState.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
                    : patientState.patients.isEmpty
                        ? const Center(
                            child: Text('No patients found'),
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
                                  // Patient details screen par navigate karein
                                  // TODO: Patient details screen add karein
                                },
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
