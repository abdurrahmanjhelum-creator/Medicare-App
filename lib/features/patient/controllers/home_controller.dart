import 'package:flutter/material.dart';
import '../../../core/services/token_service.dart';

class HomeController extends ChangeNotifier {
  String _patientName = "Loading...";
  String get patientName => _patientName;
  final ScrollController scrollController = ScrollController();

  HomeController() {
    _loadPatientName();
  }

  Future<void> _loadPatientName() async {
    final name = await TokenService.getUserName();
    if (name != null && name.isNotEmpty) {
      _patientName = name;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
