import 'review_model.dart';

class DoctorModel {
  final String image;
  final String name;
  final String specialization;
  final String rating;
  final String pmdcLicenceNumber;
  final String reviews;
  final String experience;
  final String branch;
  final String availability;
  final String bio;
  final String qualification;
  final double doctorFee;
  final List<ReviewModel> reviewsList;
  final List<String> availableDays;
  final List<String> availableSlots;

  const DoctorModel({
    required this.image,
    required this.name,
    required this.pmdcLicenceNumber,
    required this.specialization,
    required this.rating,
    required this.reviews,
    required this.doctorFee,
    required this.experience,
    required this.branch,
    required this.availability,
    required this.bio,
    required this.qualification,
    required this.reviewsList,
    required this.availableDays,
    required this.availableSlots,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      image: json['profileImage'] ?? json['image'] ?? '',
      name: json['name'] ?? '',
      pmdcLicenceNumber: json['pmdcLicenceNumber'] ?? '',
      specialization: json['specialization'] ?? '',
      rating: json['rating']?.toString() ?? '0.0',
      reviews: json['reviews']?.toString() ?? '0',
      doctorFee: (json['fee'] ?? json['doctorFee'] ?? 0).toDouble(),
      experience: json['experience']?.toString() ?? '0 Years',
      branch: json['clinic'] ?? json['branch'] ?? '',
      availability: json['availability'] ?? 'Not Available',
      bio: json['bio'] ?? '',
      qualification: json['qualification'] ?? '',
      reviewsList: json['reviewsList'] != null 
          ? (json['reviewsList'] as List).map((r) => ReviewModel.fromJson(r)).toList()
          : [],
      availableDays: json['availableDays'] != null 
          ? List<String>.from(json['availableDays'])
          : [],
      availableSlots: json['availableSlots'] != null 
          ? List<String>.from(json['availableSlots'])
          : [],
    );
  }
}
