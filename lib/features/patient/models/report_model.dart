// Lab report ka data model — pehle reports_screen.dart ke andar tha
class ReportModel {
  final String title;
  final String category;
  final String date;
  final String doctorName;
  final String status;

  const ReportModel({
    required this.title,
    required this.category,
    required this.date,
    required this.doctorName,
    required this.status,
  });
}
