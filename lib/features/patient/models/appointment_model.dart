// Appointment ka data model
class AppointmentModel {
  final String doctorimage;
  final String doctorName;
  final String specialization;
  final String time; // e.g., "10:00 AM" or "09:00-09:30"
  final String type;
  final String location;
  final String status;
  final String? patientNotes;

  const AppointmentModel({
    required this.doctorimage,
    required this.doctorName,
    required this.specialization,
    required this.time,
    required this.type,
    required this.location,
    required this.status,
    this.patientNotes,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      doctorimage: json['doctorImage'] ?? json['doctorimage'] ?? '',
      doctorName: json['doctorName'] ?? '',
      specialization: json['specialization'] ?? '',
      time: json['time'] ?? json['date'] ?? '',
      type: json['type'] ?? json['appointmentType'] ?? 'In-Person',
      location: json['location'] ?? json['clinic'] ?? '',
      status: json['status'] ?? 'Upcoming',
      patientNotes: json['patientNotes'],
    );
  }
}
