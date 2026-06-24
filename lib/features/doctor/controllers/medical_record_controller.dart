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
        endpoint: '/medical-records',
        queryParams: {'patientId': patientId},
        auth: true,
      );
      
      // API response se records list create karein
      final recordsList = (response['data'] as List)
          .map((e) => MedicalRecordModel.fromJson(e))
          .toList();
      
      state = state.copyWith(
        isLoading: false,
        records: recordsList,
      );
    } catch (e) {
      // Agar API fail ho jaye toh dummy data use karein
      await Future.delayed(const Duration(seconds: 1));
      
      final dummyRecords = [
        MedicalRecordModel(
          id: 'mr1',
          patientId: patientId,
          patientName: 'Ahmed Khan',
          doctorId: 'd1',
          doctorName: 'Dr. Smith',
          diagnosis: 'Viral fever',
          prescription: 'Paracetamol 500mg - 3 times a day\nRest and fluids',
          notes: 'Patient reported fever for 3 days',
          attachments: [],
          appointmentId: 'apt1',
          createdAt: '2024-06-20',
          updatedAt: '2024-06-20',
        ),
        MedicalRecordModel(
          id: 'mr2',
          patientId: patientId,
          patientName: 'Ahmed Khan',
          doctorId: 'd1',
          doctorName: 'Dr. Smith',
          diagnosis: 'Hypertension checkup',
          prescription: 'Continue current medication\nBlood pressure monitoring',
          notes: 'Regular follow-up required',
          attachments: ['lab_report_1.pdf'],
          appointmentId: 'apt2',
          createdAt: '2024-06-15',
          updatedAt: '2024-06-15',
        ),
      ];
      
      state = state.copyWith(
        isLoading: false,
        records: dummyRecords,
      );
    }
  }

  // Naya medical record create karein
  Future<void> createMedicalRecord(Map<String, dynamic> recordData) async {
    state = state.copyWith(isLoading: true);
    
    try {
      // API call karein
      await ApiService.post(
        endpoint: '/medical-records',
        body: recordData,
        auth: true,
      );
      
      final newRecord = MedicalRecordModel(
        id: 'mr${DateTime.now().millisecondsSinceEpoch}',
        patientId: recordData['patientId'],
        patientName: recordData['patientName'],
        doctorId: recordData['doctorId'],
        doctorName: recordData['doctorName'],
        diagnosis: recordData['diagnosis'],
        prescription: recordData['prescription'],
        notes: recordData['notes'],
        attachments: recordData['attachments'] ?? [],
        appointmentId: recordData['appointmentId'],
        createdAt: DateTime.now().toString(),
        updatedAt: DateTime.now().toString(),
      );
      
      state = state.copyWith(
        isLoading: false,
        records: [newRecord, ...state.records],
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Medical record update karein
  Future<void> updateMedicalRecord(
    String recordId,
    Map<String, dynamic> updates,
  ) async {
    state = state.copyWith(isLoading: true);
    
    try {
      // API call karein
      await ApiService.patch(
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
            updatedAt: DateTime.now().toString(),
          );
        }
        return record;
      }).toList();
      
      state = state.copyWith(
        isLoading: false,
        records: updatedRecords,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
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
