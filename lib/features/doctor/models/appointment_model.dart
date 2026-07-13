import 'package:medicare/features/patient/models/appointment_model.dart';

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
  final String? specialization; // For compatibility if needed

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
    this.specialization,
  });

  // Patient side ki screens reuse karne ke liye conversion helper
  AppointmentModel toAppointmentModel() {
    return AppointmentModel(
      id: id,
      doctorimage: patientImage, // Doctor side pe patient ki image dikhayenge
      doctorName: patientName,   // Doctor side pe patient ka naam dikhayenge header mein
      specialization: specialization ?? 'Patient',
      time: time,
      type: type,
      location: type == 'Video Call' ? 'Online' : 'Clinic',
      status: status,
      patientNotes: patientNotes,
      date: date,
    );
  }

  factory DoctorAppointmentModel.fromJson(Map<String, dynamic> json) {
    return DoctorAppointmentModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      patientId: (json['patientId'] ?? json['patient']?['_id'] ?? json['patient']?['id'] ?? '').toString(),
      patientName: json['patientName'] ?? json['patient']?['name'] ?? 'Patient',
      patientImage: json['patientImage'] ?? json['patient']?['image'] ?? '',
      date: json['date']?.toString() ?? '',
      time: json['time'] ?? '',
      type: json['type'] ?? json['appointmentType'] ?? 'Video Call',
      status: json['status'] ?? 'pending',
      patientNotes: json['patientNotes'],
      diagnosis: json['diagnosis'],
      prescription: json['prescription'],
      specialization: json['specialization'],
    );
  }

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
