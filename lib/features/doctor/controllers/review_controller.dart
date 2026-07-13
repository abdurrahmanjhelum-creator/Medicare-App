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

      final profileData = ApiService.unwrapMap(profileResp);
      
      // Handle both { data: { doctor: { _id: ... } } } and { doctor: { _id: ... } }
      final doctor = profileData['doctor'] as Map<String, dynamic>?;
      
      if (doctor == null) {
        throw Exception('Doctor profile not found. Please complete your profile.');
      }

      final doctorId = doctor['id']?.toString() ?? doctor['_id']?.toString();
      
      if (doctorId == null || doctorId.isEmpty) {
        throw Exception('Doctor ID not found in profile.');
      }

      final resp = await ApiService.get(
        endpoint: '/reviews/doctor/$doctorId',
        auth: false,
      );

      final data = ApiService.unwrapMap(resp);
      final reviewsList = ApiService.unwrapList(resp, listKey: 'reviews')
          .map((e) => DoctorReviewModel.fromJson(e as Map<String, dynamic>))
          .toList();

      final avgRating = (data['averageRating'] ?? 0).toDouble();

      state = state.copyWith(
        isLoading: false,
        reviews: reviewsList,
        averageRating: avgRating,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        reviews: [],
        averageRating: 0.0,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }
}

// Review Provider
final doctorReviewProvider =
    StateNotifierProvider<DoctorReviewNotifier, DoctorReviewState>((ref) {
  return DoctorReviewNotifier();
});
