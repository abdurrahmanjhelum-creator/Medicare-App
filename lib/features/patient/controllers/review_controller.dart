import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../models/review_model.dart';

class ReviewState {
  final List<ReviewModel> reviews;
  final bool isLoading;
  final String? error;
  final double averageRating;
  final int totalReviews;

  ReviewState({
    required this.reviews,
    this.isLoading = false,
    this.error,
    this.averageRating = 0.0,
    this.totalReviews = 0,
  });

  ReviewState copyWith({
    List<ReviewModel>? reviews,
    bool? isLoading,
    String? error,
    double? averageRating,
    int? totalReviews,
  }) {
    return ReviewState(
      reviews: reviews ?? this.reviews,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
    );
  }
}

class ReviewNotifier extends StateNotifier<ReviewState> {
  ReviewNotifier()
      : super(
          ReviewState(
            reviews: [],
          ),
        );

  // Fetch reviews by doctor ID from backend
  Future<void> fetchReviewsByDoctorId(String doctorId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await ApiService.get(
        endpoint: '/reviews/doctor/$doctorId',
        auth: false,
      );

      final data = ApiService.unwrapMap(response);
      final list = ApiService.unwrapList(response, listKey: 'reviews');
      final reviews = list.map((r) => ReviewModel.fromJson(r)).toList();
      
      state = state.copyWith(
        reviews: reviews,
        isLoading: false,
        averageRating: (data['averageRating'] ?? 0.0).toDouble(),
        totalReviews: data['totalReviews'] ?? 0,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Create new review
  Future<bool> createReview(Map<String, dynamic> reviewData) async {
    state = state.copyWith(error: null);
    try {
      await ApiService.post(
        endpoint: '/reviews',
        body: reviewData,
        auth: true,
      );
      // Refresh reviews after creation if we have a doctorId
      if (reviewData['doctorId'] != null) {
        await fetchReviewsByDoctorId(reviewData['doctorId']);
      }
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  // Delete review
  Future<bool> deleteReview(String reviewId, String doctorId) async {
    try {
      await ApiService.delete(
        endpoint: '/reviews',
        auth: true,
        body: {'reviewId': reviewId},
      );
      await fetchReviewsByDoctorId(doctorId);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}
