import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/token_service.dart';
import '../models/emergency_contact_model.dart';

class EmergencyState {
  final List<EmergencyContactModel> contacts;
  final bool isLoading;
  final String? error;

  EmergencyState({
    required this.contacts,
    this.isLoading = false,
    this.error,
  });

  EmergencyState copyWith({
    List<EmergencyContactModel>? contacts,
    bool? isLoading,
    String? error,
  }) {
    return EmergencyState(
      contacts: contacts ?? this.contacts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class EmergencyNotifier extends StateNotifier<EmergencyState> {
  EmergencyNotifier()
      : super(
          EmergencyState(
            contacts: [],
          ),
        ) {
    fetchContacts();
  }

  // Fetch emergency contacts from backend
  Future<void> fetchContacts() async {
    // Role check to prevent accidental calls from other roles
    final role = await TokenService.getUserRole();
    if (role != 'patient') return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await ApiService.get(
        endpoint: '/emergency/contacts',
        auth: false,
      );

      final list = ApiService.unwrapList(response, listKey: 'contacts');
      final contacts = list.map((c) => EmergencyContactModel.fromJson(c)).toList();
      state = state.copyWith(
        contacts: contacts,
        isLoading: false,
      );
    } catch (e) {
      if (e.toString().contains('permissions')) return;
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Fetch single contact by ID
  Future<EmergencyContactModel?> fetchContactById(String contactId) async {
    try {
      final response = await ApiService.get(
        endpoint: '/emergency/contacts/$contactId',
        auth: false,
      );
      
      final data = ApiService.unwrapMap(response);
      return EmergencyContactModel.fromJson(
        data['contact'] is Map ? data['contact'] as Map<String, dynamic> : data,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }
}
