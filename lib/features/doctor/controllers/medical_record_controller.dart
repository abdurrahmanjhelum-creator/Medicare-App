// Doctor Medical Record Controller - Medical records state management
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/medical_record_model.dart';
import '../../../core/services/api_service.dart';

// Medical Record State
class MedicalRecordState {
  final bool isLoading;
  final String? error;
  final List<MedicalRecordModel> records;
  final MedicalRecordModel? selectedRecord;

  MedicalRecordState({
    this.isLoading = false,
    this.error,
    this.records = const [],
    this.selectedRecord,
  });

  MedicalRecordState copyWith({
    bool? isLoading,
    String? error,
    List<MedicalRecordModel>? records,
    MedicalRecordModel? selectedRecord,
  }) {
    return MedicalRecordState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      records: records ?? this.records,
      selectedRecord: selectedRecord ?? this.selectedRecord,
    );
  }
}

// Medical Record Notifier
class MedicalRecordNotifier extends StateNotifier<MedicalRecordState> {
  MedicalRecordNotifier() : super(MedicalRecordState());

  // Medical records load karein
  Future<void> loadMedicalRecords(String patientId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // API se data fetch karein
      final response = await ApiService.get(
        endpoint: '/medical-records/patient/$patientId',
        auth: true,
      );

      final list = ApiService.unwrapList(response, listKey: 'medicalRecords');
      final recordsList = list
          .map((e) => MedicalRecordModel.fromJson(e))
          .toList();
      
      state = state.copyWith(
        isLoading: false,
        records: recordsList,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Naya medical record create karein
  Future<bool> createMedicalRecord(Map<String, dynamic> recordData) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await ApiService.post(
        endpoint: '/medical-records',
        body: recordData,
        auth: true,
      );

      final patientId = recordData['patientId']?.toString() ?? '';
      if (patientId.isNotEmpty) {
        await loadMedicalRecords(patientId);
      } else {
        state = state.copyWith(isLoading: false);
      }
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  // Medical record update karein
  Future<bool> updateMedicalRecord(
    String recordId,
    Map<String, dynamic> updates,
  ) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await ApiService.put(
        endpoint: '/medical-records/$recordId',
        body: updates,
        auth: true,
      );

      final updatedRecords = state.records.map((record) {
        if (record.id == recordId) {
          return MedicalRecordModel(
            id: record.id,
            patientId: record.patientId,
            patientName: record.patientName,
            doctorId: record.doctorId,
            doctorName: record.doctorName,
            diagnosis: updates['diagnosis'] ?? record.diagnosis,
            prescription: updates['prescription'] ?? record.prescription,
            notes: updates['notes'] ?? record.notes,
            attachments: updates['attachments'] ?? record.attachments,
            appointmentId: record.appointmentId,
            createdAt: record.createdAt,
            updatedAt: DateTime.now().toIso8601String(),
          );
        }
        return record;
      }).toList();

      state = state.copyWith(isLoading: false, records: updatedRecords);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  // Record select karein
  void selectRecord(MedicalRecordModel record) {
    state = state.copyWith(selectedRecord: record);
  }

  // Record clear karein
  void clearSelectedRecord() {
    state = state.copyWith(selectedRecord: null);
  }
}

// Medical Record Provider
final medicalRecordProvider =
    StateNotifierProvider<MedicalRecordNotifier, MedicalRecordState>((ref) {
  return MedicalRecordNotifier();
});
