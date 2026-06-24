import 'package:flutter/material.dart';
import '../../../core/services/api_service.dart';
import '../models/emergency_contact_model.dart';

class EmergencyController {
  List<EmergencyContactModel> contacts = [];
  bool isLoading = false;
  String? error;

  // Fetch emergency contacts from backend
  Future<void> fetchContacts() async {
    isLoading = true;
    error = null;
    try {
      final response = await ApiService.get(
        endpoint: '/emergency/contacts',
        auth: false,
      );

      final data = response['data'] ?? response;
      if (data is List) {
        contacts = data.map((c) => EmergencyContactModel.fromJson(c)).toList();
      }
      isLoading = false;
    } catch (e) {
      error = e.toString();
      isLoading = false;
      // Fallback to dummy data if API fails
      _loadDummyData();
    }
  }

  // Fetch single contact by ID
  Future<EmergencyContactModel?> fetchContactById(String contactId) async {
    try {
      final response = await ApiService.get(
        endpoint: '/emergency/contacts/$contactId',
        auth: false,
      );
      
      final data = response['data'] ?? response;
      return EmergencyContactModel.fromJson(data);
    } catch (e) {
      error = e.toString();
      return null;
    }
  }

  // Dummy data fallback
  void _loadDummyData() {
    contacts = const [
      EmergencyContactModel(
        title: "Emergency Helpline",
        subtitle: "Emergency",
        icon: Icons.phone_callback_rounded,
        iconColor: Color(0xFFE57373),
        iconBackgroundColor: Color(0xFFFFEBEE),
      ),
      EmergencyContactModel(
        title: "Ambulance Service",
        subtitle: "Ambulance",
        icon: Icons.error_outline_rounded,
        iconColor: Color(0xFF0FA485),
        iconBackgroundColor: Color(0xFFE0F2F1),
      ),
      EmergencyContactModel(
        title: "Main Hospital",
        subtitle: "Hospital",
        icon: Icons.local_hospital_outlined,
        iconColor: Color(0xFF0FA485),
        iconBackgroundColor: Color(0xFFE0F2F1),
      ),
    ];
  }
}
