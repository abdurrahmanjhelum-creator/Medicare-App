class ReviewModel {
  final String doctorId;
  final String userName;
  final String reviewText;
  final String rating;


  const ReviewModel({
    required this.doctorId,
    required this.userName,
    required this.reviewText,
    required this.rating,

  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      doctorId: json['doctorId']?.toString() ?? '',
      userName: json['userName'] ?? json['patientName'] ?? '',
      reviewText: json['reviewText'] ?? json['comment'] ?? '',
      rating: json['rating']?.toString() ?? '0',
    );
  }
}
