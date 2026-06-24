import '../models/report_model.dart';

class ReportController {
  final List<ReportModel> reports = const [
    ReportModel(
      title: "Blood Test Report",
      category: "Hematology",
      date: "15/05/2024",
      doctorName: "Dr. Sarah Johnson",
      status: "Ready",
    ),
    ReportModel(
      title: "X-Ray Chest",
      category: "Radiology",
      date: "10/05/2024",
      doctorName: "Dr. Michael Chen",
      status: "Ready",
    ),
  ];
}
