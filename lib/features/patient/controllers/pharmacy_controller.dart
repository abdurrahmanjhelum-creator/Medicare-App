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

      final data = response['data'] ?? response;
      if (data is List) {
        final medicines = data.map((m) => Medicine.fromJson(m)).toList();
        state = state.copyWith(
          medicineList: medicines,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      // Load dummy data on error
      _loadDummyData();
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

      final data = response['data'] ?? response;
      if (data is List) {
        final medicines = data.map((m) => Medicine.fromJson(m)).toList();
        state = state.copyWith(
          medicineList: medicines,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
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

  void _loadDummyData() {
    state = state.copyWith(
      medicineList: [
        Medicine(
          title: "Paracetamol 500mg",
          category: "Pain Relief",
          price: "\$5.99",
        ),
        Medicine(
          title: "Amoxicillin 250mg",
          category: "Antibiotic",
          price: "\$12.99",
        ),
        Medicine(
          title: "Ibuprofen 400mg",
          category: "Anti-inflammatory",
          price: "\$8.50",
        ),
        Medicine(
          title: "Panadol Extra",
          category: "Fever",
          price: "\$3.20",
        ),
        Medicine(
          title: "Vitamin C",
          category: "Supplements",
          price: "\$15.00",
        ),
      ],
    );
  }
}
