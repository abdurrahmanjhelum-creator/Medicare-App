import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/api_service.dart';
import '../models/patient_model.dart';

class DoctorPatientState {
  final bool isLoading;
  final String? error;
  final List<DoctorPatientModel> patients;
  final String searchQuery;

  DoctorPatientState({
    this.isLoading = false,
    this.error,
    this.patients = const [],
    this.searchQuery = '',
  });

  DoctorPatientState copyWith({
    bool? isLoading,
    String? error,
    List<DoctorPatientModel>? patients,
    String? searchQuery,
  }) {
    return DoctorPatientState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      patients: patients ?? this.patients,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class DoctorPatientNotifier extends StateNotifier<DoctorPatientState> {
  DoctorPatientNotifier() : super(DoctorPatientState());

  List<DoctorPatientModel> _allPatients = [];

  String _formatMedicalHistory(dynamic history) {
    if (history == null) return '';
    if (history is List) return history.map((e) => e.toString()).join(', ');
    return history.toString();
  }

  Future<void> loadPatients() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await ApiService.get(
        endpoint: '/appointments/doctor/my-appointments',
        auth: true,
      );

      final appointmentsList =
          ApiService.unwrapList(response, listKey: 'appointments');
      final appointments =
          appointmentsList.map((e) => e as Map<String, dynamic>).toList();

      // Appointments store patientId as userId — dedupe by userId
      final Map<String, Map<String, dynamic>> patientMap = {};
      for (final apt in appointments) {
        final userId = apt['patientId']?.toString();
        if (userId == null || userId.isEmpty) continue;
        patientMap[userId] = {
          'userId': userId,
          'name': apt['patientName'] ?? 'Patient',
        };
      }

      final futures = patientMap.entries.map((entry) async {
        try {
          final pResp =
              await ApiService.get(endpoint: '/patients/${entry.key}', auth: true);
          final unwrapped = ApiService.unwrapMap(pResp);
          final user = (unwrapped['user'] ?? {}) as Map<String, dynamic>;
          final patient = (unwrapped['patient'] ?? {}) as Map<String, dynamic>;

          return DoctorPatientModel.fromJson({
            'id': patient['id'] ?? patient['_id'] ?? '',
            'userId': user['id'] ?? entry.key,
            'name': user['name'] ?? entry.value['name'] ?? '',
            'email': user['email'] ?? '',
            'phone': user['phone'] ?? '',
            'age': (patient['age'] ?? '').toString(),
            'gender': patient['gender'] ?? '',
            'bloodGroup': patient['bloodGroup'] ?? '',
            'address': patient['address'] ?? '',
            'profileImage': user['profileImage'] ?? '',
            'medicalHistory': _formatMedicalHistory(patient['medicalHistory']),
          });
        } catch (_) {
          // Fallback: show basic info from appointment if profile fetch fails
          return DoctorPatientModel.fromJson({
            'id': entry.key,
            'userId': entry.key,
            'name': entry.value['name'] ?? 'Patient',
            'email': '',
            'phone': '',
            'age': '',
            'gender': '',
            'bloodGroup': '',
            'address': '',
            'profileImage': '',
            'medicalHistory': '',
          });
        }
      }).toList();

      final results = await Future.wait(futures);
      _allPatients = results;
      _allPatients.sort((a, b) => a.name.compareTo(b.name));

      state = state.copyWith(isLoading: false, patients: _allPatients);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        patients: [],
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> searchPatients(String query) async {
    state = state.copyWith(searchQuery: query);

    if (_allPatients.isEmpty) {
      await loadPatients();
    }

    if (query.isEmpty) {
      state = state.copyWith(patients: _allPatients);
      return;
    }

    final lowerQuery = query.toLowerCase();
    final filtered = _allPatients
        .where((patient) =>
            patient.name.toLowerCase().contains(lowerQuery) ||
            patient.email.toLowerCase().contains(lowerQuery) ||
            patient.phone.contains(query))
        .toList();

    state = state.copyWith(patients: filtered);
  }
}

final doctorPatientProvider =
    StateNotifierProvider<DoctorPatientNotifier, DoctorPatientState>((ref) {
  return DoctorPatientNotifier();
});
