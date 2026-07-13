// Lab report ka data model — pehle reports_screen.dart ke andar tha
class ReportModel {
  final String title;
  final String category;
  final String date;
  final String doctorName;
  final String status;
  final String? id;

  const ReportModel({
    required this.title,
    required this.category,
    required this.date,
    required this.doctorName,
    required this.status,
    this.id,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      date: json['date'] != null 
          ? (json['date'] is DateTime 
              ? (json['date'] as DateTime).toIso8601String().split('T')[0]
              : json['date'].toString().split('T')[0])
          : '',
      doctorName: json['doctorName'] ?? '',
      status: json['status'] ?? 'pending',
    );
  }
}
