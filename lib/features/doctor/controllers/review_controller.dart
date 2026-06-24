// Doctor Review Controller - Doctor reviews state management
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/api_service.dart';
import '../models/review_model.dart';

// Review State
class DoctorReviewState {
  final bool isLoading;
  final String? error;
  final List<DoctorReviewModel> reviews;
  final double averageRating;

  DoctorReviewState({
    this.isLoading = false,
    this.error,
    this.reviews = const [],
    this.averageRating = 0.0,
  });

  DoctorReviewState copyWith({
    bool? isLoading,
    String? error,
    List<DoctorReviewModel>? reviews,
    double? averageRating,
  }) {
    return DoctorReviewState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      reviews: reviews ?? this.reviews,
      averageRating: averageRating ?? this.averageRating,
    );
  }
}

// Review Notifier
class DoctorReviewNotifier extends StateNotifier<DoctorReviewState> {
  DoctorReviewNotifier() : super(DoctorReviewState());

  // Reviews load karein
  Future<void> loadReviews() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // First fetch current doctor's profile to get doctor ID
      final profileResp = await ApiService.get(
        endpoint: '/doctor-dashboard/profile',
        auth: true,
      );

      final doctorId = (profileResp['data'] as Map<String, dynamic>)['doctor']?['id'];
      if (doctorId == null) throw Exception('Doctor ID not found');

      // Fetch reviews for this doctor
      final resp = await ApiService.get(
        endpoint: '/reviews/doctor/$doctorId',
        auth: false,
      );

      // Backend returns { reviews, pagination, averageRating, totalReviews }
      final reviewsList = (resp['reviews'] as List)
          .map((e) => DoctorReviewModel.fromJson(e as Map<String, dynamic>))
          .toList();

      final avgRating = (resp['averageRating'] ?? 0).toDouble();

      state = state.copyWith(
        isLoading: false,
        reviews: reviewsList,
        averageRating: avgRating,
      );
    } catch (e) {
      // If API fails or no reviews, show empty list (no dummy data)
      state = state.copyWith(
        isLoading: false,
        reviews: [],
        averageRating: 0.0,
        error: null,
      );
    }
  }

  // Review delete karein
  Future<void> deleteReview(String reviewId) async {
    try {
      // API call karein
      await ApiService.delete(
        endpoint: '/reviews/$reviewId',
        auth: true,
      );
      
      final updatedReviews =
          state.reviews.where((review) => review.id != reviewId).toList();
      
      // Recalculate average rating
      final avgRating = updatedReviews.isEmpty
          ? 0.0
          : updatedReviews.map((r) => r.rating).reduce((a, b) => a + b) /
              updatedReviews.length;
      
      state = state.copyWith(
        reviews: updatedReviews,
        averageRating: avgRating,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

// Review Provider
final doctorReviewProvider =
    StateNotifierProvider<DoctorReviewNotifier, DoctorReviewState>((ref) {
  return DoctorReviewNotifier();
});
