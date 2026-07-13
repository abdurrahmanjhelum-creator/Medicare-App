import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../models/doctor_model.dart';

class DoctorState {
  final List<DoctorModel> allDoctors;
  final List<DoctorModel> filteredDoctors;
  final bool isLoading;
  final String? error;
  final bool searchAutofocus;

  DoctorState({
    required this.allDoctors,
    required this.filteredDoctors,
    this.isLoading = false,
    this.error,
    this.searchAutofocus = false,
  });

  DoctorState copyWith({
    List<DoctorModel>? allDoctors,
    List<DoctorModel>? filteredDoctors,
    bool? isLoading,
    String? error,
    bool? searchAutofocus,
  }) {
    return DoctorState(
      allDoctors: allDoctors ?? this.allDoctors,
      filteredDoctors: filteredDoctors ?? this.filteredDoctors,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchAutofocus: searchAutofocus ?? this.searchAutofocus,
    );
  }

  List<DoctorModel> get topRatedDoctors {
    final top = allDoctors.where((doc) {
      final rating = double.tryParse(doc.rating.toString()) ?? 0.0;
      return rating >= 4.0;
    }).toList();
    
    if (top.isEmpty) {
      return allDoctors.take(5).toList();
    }
    return top;
  }
}

class DoctorNotifier extends StateNotifier<DoctorState> {
  DoctorNotifier()
      : super(
          DoctorState(
            allDoctors: [],
            filteredDoctors: [],
          ),
        ) {
    fetchAllDoctors();
  }

  void setSearchAutofocus(bool value) {
    state = state.copyWith(searchAutofocus: value);
  }

  // Fetch all doctors from backend
  Future<void> fetchAllDoctors() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await ApiService.get(
        endpoint: '/doctors',
        auth: false,
      );

      final doctorsList = ApiService.unwrapList(response, listKey: 'doctors');
      final doctors =
          doctorsList.map((doc) => DoctorModel.fromJson(doc)).toList();
      state = state.copyWith(
        allDoctors: doctors,
        filteredDoctors: doctors,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Filter doctors by name or specialization
  void filterDoctors(String query) {
    if (query.isEmpty) {
      state = state.copyWith(filteredDoctors: state.allDoctors);
      return;
    }

    final filtered = state.allDoctors.where((doctor) {
      final name = doctor.name.toLowerCase();
      final spec = doctor.specialization.toLowerCase();
      final q = query.toLowerCase();
      return name.contains(q) || spec.contains(q);
    }).toList();

    state = state.copyWith(filteredDoctors: filtered);
  }

  // Fetch single doctor by ID
  Future<DoctorModel?> fetchDoctorById(String doctorId) async {
    try {
      final response = await ApiService.get(
        endpoint: '/doctors/$doctorId',
        auth: false,
      );
      
      final data = ApiService.unwrapMap(response);
      return DoctorModel.fromJson(data);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }
}
