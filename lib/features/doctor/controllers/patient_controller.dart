// Doctor Patient Controller - Doctor patients state management
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/api_service.dart';
import '../models/patient_model.dart';

// Patient State
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

// Patient Notifier
class DoctorPatientNotifier extends StateNotifier<DoctorPatientState> {
  DoctorPatientNotifier() : super(DoctorPatientState());

  // Patients load karein
  Future<void> loadPatients() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // API se data fetch karein
      // Backend does not expose a direct "patients for doctor" endpoint yet.
      // Fetch doctor's appointments and extract unique patients from them.
      final response = await ApiService.get(
        endpoint: '/appointments/doctor/my-appointments',
        auth: true,
      );

      // Normalize response: backend may return { appointments: [...], total }
      List appointmentsList = [];
      if (response is Map<String, dynamic>) {
        if (response.containsKey('appointments') && response['appointments'] is List) {
          appointmentsList = response['appointments'] as List;
        } else if (response.containsKey('data')) {
          final d = response['data'];
          if (d is List) appointmentsList = d;
          else if (d is Map && d.containsKey('appointments') && d['appointments'] is List) appointmentsList = d['appointments'] as List;
        }
      }
      
      final appointments = appointmentsList.map((e) => e as Map<String, dynamic>).toList();

      final Set<String> patientIds = {};
      for (final apt in appointments) {
        final id = (apt['patientId'] ?? apt['patient']?['id'] ?? apt['patient']?['_id'])?.toString();
        if (id != null && id.isNotEmpty) patientIds.add(id);
      }

      // Fetch full patient profiles in parallel
      final futures = patientIds.map((id) async {
        try {
          final pResp = await ApiService.get(endpoint: '/patients/$id', auth: true);
          // pResp expected: { user: {...}, patient: {...} }
          final user = (pResp['user'] ?? {}) as Map<String, dynamic>;
          final patient = (pResp['patient'] ?? {}) as Map<String, dynamic>;

          final mapped = {
            '_id': patient['id'] ?? patient['_id'] ?? '',
            'userId': patient['id'] ?? patient['_id'] ?? '',
            'name': user['name'] ?? '',
            'email': user['email'] ?? '',
            'phone': user['phone'] ?? '',
            'age': (patient['age'] ?? '').toString(),
            'gender': patient['gender'] ?? '',
            'bloodGroup': patient['bloodGroup'] ?? '',
            'address': patient['address'] ?? '',
            'profileImage': user['profileImage'] ?? '',
            'medicalHistory': patient['medicalHistory'] ?? '',
          };

          return DoctorPatientModel.fromJson(mapped);
        } catch (e) {
          return null;
        }
      }).toList();

      final results = await Future.wait(futures);
      final patients = results.whereType<DoctorPatientModel>().toList();

      state = state.copyWith(isLoading: false, patients: patients);
    } catch (e) {
      // If API fails, show empty list and set error
      state = state.copyWith(isLoading: false, patients: [], error: e.toString());
    }
  }

  // Search patients
  Future<void> searchPatients(String query) async {
    state = state.copyWith(searchQuery: query);

    if (query.isEmpty) {
      await loadPatients();
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      // Reuse loadPatients logic but filter results after fetching full profiles
      await loadPatients();

      final filtered = state.patients.where((patient) =>
        patient.name.toLowerCase().contains(query.toLowerCase()) ||
        patient.email.toLowerCase().contains(query.toLowerCase()) ||
        patient.phone.contains(query)
      ).toList();

      state = state.copyWith(isLoading: false, patients: filtered);
    } catch (e) {
      state = state.copyWith(isLoading: false, patients: [], error: e.toString());
    }
  }
}

// Patient Provider
final doctorPatientProvider =
    StateNotifierProvider<DoctorPatientNotifier, DoctorPatientState>((ref) {
  return DoctorPatientNotifier();
});
