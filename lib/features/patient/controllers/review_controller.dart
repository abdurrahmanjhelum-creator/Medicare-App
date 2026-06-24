import '../../../core/services/api_service.dart';
import '../models/review_model.dart';

class ReviewController {
  static const List<ReviewModel> dummyReviews = [
    ReviewModel(
      doctorId: "ali-123",
      userName: "Emma Wilson",
      reviewText: "Excellent doctor! Very thorough and caring.",
      rating: "5",
    ),
    ReviewModel(
      doctorId: "sarah-456",
      userName: "John Smith",
      reviewText: "Highly recommended. Explained everything clearly.",
      rating: "5",

    ),
    ReviewModel(
      doctorId: "ahmed-456",
      userName: "Lisa Brown",
      reviewText: "Good experience overall. Professional service.",
      rating: "4",

    ),
  ];

  // Fetch reviews by doctor ID from backend
  Future<List<ReviewModel>> getReviewsByDoctorId(String doctorId) async {
    try {
      final response = await ApiService.get(
        endpoint: '/reviews/doctor/$doctorId',
        auth: false,
      );

      final data = response['data'] ?? response;
      if (data is List) {
        return data.map((r) => ReviewModel.fromJson(r)).toList();
      }
      return dummyReviews;
    } catch (e) {
      // Fallback to dummy data on error
      return dummyReviews;
    }
  }

  // Create new review
  Future<bool> createReview(Map<String, dynamic> reviewData) async {
    try {
      await ApiService.post(
        endpoint: '/reviews',
        body: reviewData,
        auth: true,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  // Delete review
  Future<bool> deleteReview(String reviewId) async {
    try {
      await ApiService.delete(
        endpoint: '/reviews',
        auth: true,
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
