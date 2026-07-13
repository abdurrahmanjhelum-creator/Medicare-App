class ReviewModel {
  final String? id;
  final String doctorId;
  final String appointmentId;
  final String patientName;
  final String comment;
  final double rating;
  final String? createdAt;

  const ReviewModel({
    this.id,
    required this.doctorId,
    required this.appointmentId,
    required this.patientName,
    required this.comment,
    required this.rating,
    this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      doctorId: json['doctorId']?.toString() ?? '',
      appointmentId: json['appointmentId']?.toString() ?? '',
      patientName: json['patientName'] ?? json['userName'] ?? 'Anonymous',
      comment: json['comment'] ?? json['reviewText'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      createdAt: json['createdAt']?.toString(),
    );
  }
}
