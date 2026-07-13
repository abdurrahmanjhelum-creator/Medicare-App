import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../../doctor/models/medical_record_model.dart';

class PatientMedicalRecordState {
  final List<MedicalRecordModel> records;
  final bool isLoading;
  final String? error;

  PatientMedicalRecordState({
    this.records = const [],
    this.isLoading = false,
    this.error,
  });

  PatientMedicalRecordState copyWith({
    List<MedicalRecordModel>? records,
    bool? isLoading,
    String? error,
  }) {
    return PatientMedicalRecordState(
      records: records ?? this.records,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class PatientMedicalRecordNotifier extends StateNotifier<PatientMedicalRecordState> {
  PatientMedicalRecordNotifier() : super(PatientMedicalRecordState()) {
    fetchMyMedicalRecords();
  }

  Future<void> fetchMyMedicalRecords() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await ApiService.get(
        endpoint: '/medical-records/my',
        auth: true,
      );

      final list = ApiService.unwrapList(response, listKey: 'medicalRecords');
      final records = list.map((e) => MedicalRecordModel.fromJson(e)).toList();
      
      state = state.copyWith(
        records: records,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }
}

final patientMedicalRecordProvider =
    StateNotifierProvider.autoDispose<PatientMedicalRecordNotifier, PatientMedicalRecordState>((ref) {
  return PatientMedicalRecordNotifier();
});
