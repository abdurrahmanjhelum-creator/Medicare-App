// Medical Record Model - Medical record ka data model
class MedicalRecordModel {
  final String id;
  final String patientId;
  final String patientName;
  final String doctorId;
  final String doctorName;
  final String diagnosis;
  final String prescription;
  final String notes;
  final List<String> attachments;
  final String? appointmentId;
  final String createdAt;
  final String updatedAt;

  const MedicalRecordModel({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.doctorId,
    required this.doctorName,
    required this.diagnosis,
    required this.prescription,
    required this.notes,
    required this.attachments,
    this.appointmentId,
    required this.createdAt,
    required this.updatedAt,
  });

  // JSON se model create karne ke liye
  factory MedicalRecordModel.fromJson(Map<String, dynamic> json) {
    return MedicalRecordModel(
      id: json['_id'] ?? json['id'] ?? '',
      patientId: json['patientId'] ?? '',
      patientName: json['patientName'] ?? '',
      doctorId: json['doctorId'] ?? '',
      doctorName: json['doctorName'] ?? '',
      diagnosis: json['diagnosis'] ?? '',
      prescription: json['prescription'] ?? '',
      notes: json['notes'] ?? '',
      attachments: json['attachments'] != null 
          ? List<String>.from(json['attachments']) 
          : [],
      appointmentId: json['appointmentId'],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  // Model ko JSON mein convert karne ke liye
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'patientName': patientName,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'diagnosis': diagnosis,
      'prescription': prescription,
      'notes': notes,
      'attachments': attachments,
      'appointmentId': appointmentId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
