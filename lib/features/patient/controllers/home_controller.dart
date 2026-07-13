import 'package:flutter/material.dart';
import '../../../core/services/token_service.dart';
import '../../../core/services/api_service.dart';

class HomeController extends ChangeNotifier {
  String _patientName = "Loading...";
  String get patientName => _patientName;
  final ScrollController scrollController = ScrollController();

  int _appointments = 0;
  int get appointments => _appointments;

  int _labReports = 0;
  int get labReports => _labReports;

  int _prescriptions = 0;
  int get prescriptions => _prescriptions;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  HomeController() {
    refreshData();
  }

  Future<void> refreshData() async {
    // Security Check: Sirf patient ke liye data fetch karo
    final role = await TokenService.getUserRole();
    if (role != 'patient') return;

    _isLoading = true;
    notifyListeners();
    
    await _loadPatientName();
    await _loadStats();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadPatientName() async {
    try {
      final name = await TokenService.getUserName();
      if (name != null && name.isNotEmpty) {
        _patientName = name;
      } else {
        _patientName = "Patient";
      }
    } catch (_) {
      _patientName = "Patient";
    }
  }

  Future<void> _loadStats() async {
    try {
      final resp = await ApiService.get(endpoint: '/patient-dashboard/stats', auth: true);
      final data = ApiService.unwrapMap(resp);
      _appointments = data['totalAppointments'] ?? 0;
      _labReports = data['totalMedicalRecords'] ?? 0;
      _prescriptions = data['totalPrescriptions'] ?? 0;
    } catch (e) {
      debugPrint("Error loading home stats: $e");
      // Graceful fallback for missing profile or server error
      _appointments = 0;
      _labReports = 0;
      _prescriptions = 0;
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
