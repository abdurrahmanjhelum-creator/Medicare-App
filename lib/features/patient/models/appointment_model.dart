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
  final String? diagnosis;
  final String? prescription;
  final String? date;
  final String? id;
  final String? doctorId;

  const AppointmentModel({
    required this.doctorimage,
    required this.doctorName,
    required this.specialization,
    required this.time,
    required this.type,
    required this.location,
    required this.status,
    this.patientNotes,
    this.diagnosis,
    this.prescription,
    this.date,
    this.id,
    this.doctorId,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    final nestedDoctor = json['doctor'] as Map<String, dynamic>?;
    final nestedDoctorName = (nestedDoctor?['name'] ?? nestedDoctor?['doctorName'] ?? '').toString().trim();
    final doctorName = (json['doctorName'] ?? '').toString().trim();
    final clinicName = (json['clinic'] ?? json['location'] ?? '').toString().trim();
    final locationValue = (json['location'] ?? json['clinic'] ?? '').toString().trim();

    final resolvedDoctorName = nestedDoctorName.isNotEmpty && nestedDoctorName.toLowerCase() != 'null'
        ? nestedDoctorName
        : doctorName.isNotEmpty && doctorName.toLowerCase() != 'null'
            ? doctorName
            : clinicName.isNotEmpty
                ? clinicName
                : 'Doctor';

    return AppointmentModel(
      doctorimage: json['doctorImage'] ?? json['doctorimage'] ?? '',
      doctorName: resolvedDoctorName,
      specialization: json['specialization'] ?? '',
      time: json['time'] ?? '',
      type: json['type'] ?? json['appointmentType'] ?? 'consultation',
      location: locationValue.isNotEmpty ? locationValue : 'Clinic',
      status: json['status'] ?? 'Upcoming',
      patientNotes: json['patientNotes'],
      diagnosis: json['diagnosis'],
      prescription: json['prescription'],
      date: json['date']?.toString(),
      id: json['_id']?.toString() ?? json['id']?.toString(),
      doctorId: json['doctorId']?.toString() ?? nestedDoctor?['_id']?.toString(),
    );
  }
}
