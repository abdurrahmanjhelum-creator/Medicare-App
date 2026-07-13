import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../models/medicine_model.dart';

class PharmacyState {
  final int cartCounter;
  final List<Medicine> medicineList;
  final bool isLoading;
  final String? error;

  PharmacyState({
    this.cartCounter = 0,
    required this.medicineList,
    this.isLoading = false,
    this.error,
  });

  PharmacyState copyWith({
    int? cartCounter,
    List<Medicine>? medicineList,
    bool? isLoading,
    String? error,
  }) {
    return PharmacyState(
      cartCounter: cartCounter ?? this.cartCounter,
      medicineList: medicineList ?? this.medicineList,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class PharmacyNotifier extends StateNotifier<PharmacyState> {
  PharmacyNotifier()
    : super(
        PharmacyState(
          medicineList: [],
        ),
      ) {
    fetchMedicines();
  }

  // Fetch medicines from backend
  Future<void> fetchMedicines() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await ApiService.get(
        endpoint: '/pharmacy/medicines',
        auth: false,
      );

      final data = ApiService.unwrapMap(response);
      final list = data['medicines'] is List
          ? data['medicines'] as List
          : ApiService.unwrapList(response, listKey: 'medicines');
      final medicines = list.map((m) => Medicine.fromJson(m)).toList();
      state = state.copyWith(
        medicineList: medicines,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Search medicines
  Future<void> searchMedicines(String query) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await ApiService.get(
        endpoint: '/pharmacy/medicines/search?q=$query',
        auth: false,
      );

      final data = ApiService.unwrapMap(response);
      final list = data['medicines'] is List
          ? data['medicines'] as List
          : ApiService.unwrapList(response, listKey: 'medicines');
      final medicines = list.map((m) => Medicine.fromJson(m)).toList();
      state = state.copyWith(
        medicineList: medicines,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void addToCart() {
    state = state.copyWith(cartCounter: state.cartCounter + 1);
  }
}
