import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/token_service.dart';
import '../models/report_model.dart';

class ReportState {
  final List<ReportModel> reports;
  final bool isLoading;
  final String? error;

  ReportState({
    required this.reports,
    this.isLoading = false,
    this.error,
  });

  ReportState copyWith({
    List<ReportModel>? reports,
    bool? isLoading,
    String? error,
  }) {
    return ReportState(
      reports: reports ?? this.reports,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ReportNotifier extends StateNotifier<ReportState> {
  ReportNotifier()
      : super(
          ReportState(
            reports: [],
          ),
        ) {
    fetchReports();
  }

  // Fetch reports from backend
  Future<void> fetchReports() async {
    // Security check: Only fetch if the user is a patient
    final role = await TokenService.getUserRole();
    if (role != 'patient') return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await ApiService.get(
        endpoint: '/reports',
        auth: true,
      );

      final list = ApiService.unwrapList(response, listKey: 'reports');
      final reports = list.map((r) => ReportModel.fromJson(r)).toList();
      state = state.copyWith(
        reports: reports,
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

  // Upload new report
  Future<bool> uploadReport(Map<String, dynamic> reportData) async {
    try {
      await ApiService.post(
        endpoint: '/reports',
        body: reportData,
        auth: true,
      );
      await fetchReports();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  // Delete report
  Future<bool> deleteReport(String reportId) async {
    try {
      await ApiService.delete(
        endpoint: '/reports/$reportId',
        auth: true,
      );
      await fetchReports();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}
