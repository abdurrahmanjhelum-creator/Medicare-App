// Doctor Appointment Model - Doctor ke liye appointment ka data model
class DoctorAppointmentModel {
  final String id;
  final String patientId;
  final String patientName;
  final String patientImage;
  final String date;
  final String time;
  final String type;
  final String status; // pending, confirmed, completed, cancelled
  final String? patientNotes;
  final String? diagnosis;
  final String? prescription;

  const DoctorAppointmentModel({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.patientImage,
    required this.date,
    required this.time,
    required this.type,
    required this.status,
    this.patientNotes,
    this.diagnosis,
    this.prescription,
  });

  // JSON se model create karne ke liye
  factory DoctorAppointmentModel.fromJson(Map<String, dynamic> json) {
    return DoctorAppointmentModel(
      id: json['_id'] ?? json['id'] ?? '',
      patientId: json['patientId'] ?? '',
      patientName: json['patientName'] ?? '',
      patientImage: json['patientImage'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? 'pending',
      patientNotes: json['patientNotes'],
      diagnosis: json['diagnosis'],
      prescription: json['prescription'],
    );
  }

  // Model ko JSON mein convert karne ke liye
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'patientName': patientName,
      'patientImage': patientImage,
      'date': date,
      'time': time,
      'type': type,
      'status': status,
      'patientNotes': patientNotes,
      'diagnosis': diagnosis,
      'prescription': prescription,
    };
  }
}
