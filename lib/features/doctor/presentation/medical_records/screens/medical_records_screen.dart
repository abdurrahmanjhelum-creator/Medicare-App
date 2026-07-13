// Medical Records Screen - Medical records screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../controllers/medical_record_controller.dart';
import '../widgets/medical_record_card.dart';
import '../../../models/medical_record_model.dart';

class MedicalRecordsScreen extends ConsumerStatefulWidget {
  final String patientId;
  final String patientName;

  const MedicalRecordsScreen({
    super.key,
    required this.patientId,
    required this.patientName,
  });

  @override
  ConsumerState<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends ConsumerState<MedicalRecordsScreen> {
  @override
  void initState() {
    super.initState();
    // Medical records load karein
    Future.microtask(() => ref.read(medicalRecordProvider.notifier).loadMedicalRecords(widget.patientId));
  }

  @override
  Widget build(BuildContext context) {
    final recordState = ref.watch(medicalRecordProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          '${widget.patientName} - Records',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddRecordDialog(context),
          ),
        ],
      ),
      body: recordState.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : recordState.error != null
              ? Center(
                  child: Text(
                    'Error: ${recordState.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : recordState.records.isEmpty
                  ? const Center(
                      child: Text('No medical records found'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(AppDimensions.screenPaddingHorizontal),
                      itemCount: recordState.records.length,
                      itemBuilder: (context, index) {
                        final record = recordState.records[index];
                        return MedicalRecordCard(
                          record: record,
                          onUpdate: () => _showUpdateRecordDialog(context, record),
                        );
                      },
                    ),
    );
  }

  // Add record dialog
  void _showAddRecordDialog(BuildContext context) {
    final diagnosisController = TextEditingController();
    final prescriptionController = TextEditingController();
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Medical Record'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: diagnosisController,
                decoration: const InputDecoration(
                  labelText: 'Diagnosis',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: AppDimensions.spacing16),
              TextField(
                controller: prescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Prescription',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: AppDimensions.spacing16),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (diagnosisController.text.isNotEmpty) {
                final success = await ref.read(medicalRecordProvider.notifier).createMedicalRecord({
                  'patientId': widget.patientId,
                  'diagnosis': diagnosisController.text,
                  'prescription': prescriptionController.text,
                  'notes': notesController.text,
                });
                if (context.mounted) {
                  Navigator.pop(context);
                  if (!success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(ref.read(medicalRecordProvider).error ?? 'Failed to save record')),
                    );
                  }
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // Update record dialog
  void _showUpdateRecordDialog(BuildContext context, MedicalRecordModel record) {
    final diagnosisController = TextEditingController(text: record.diagnosis);
    final prescriptionController = TextEditingController(text: record.prescription);
    final notesController = TextEditingController(text: record.notes);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Medical Record'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: diagnosisController,
                decoration: const InputDecoration(
                  labelText: 'Diagnosis',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: AppDimensions.spacing16),
              TextField(
                controller: prescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Prescription',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: AppDimensions.spacing16),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(medicalRecordProvider.notifier).updateMedicalRecord(
                record.id,
                {
                  'diagnosis': diagnosisController.text,
                  'prescription': prescriptionController.text,
                  'notes': notesController.text,
                },
              );
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}
