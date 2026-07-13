// Doctor Reviews Screen - Doctor reviews screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../controllers/review_controller.dart';
import '../widgets/review_card.dart';

class DoctorReviewsScreen extends ConsumerStatefulWidget {
  const DoctorReviewsScreen({super.key});

  @override
  ConsumerState<DoctorReviewsScreen> createState() => _DoctorReviewsScreenState();
}

class _DoctorReviewsScreenState extends ConsumerState<DoctorReviewsScreen> {
  @override
  void initState() {
    super.initState();
    // Reviews load karein
    Future.microtask(() => ref.read(doctorReviewProvider.notifier).loadReviews());
  }

  @override
  Widget build(BuildContext context) {
    final reviewState = ref.watch(doctorReviewProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const Text(
          'Reviews',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Rating summary
          if (!reviewState.isLoading && reviewState.averageRating > 0) ...[
            Container(
              margin: const EdgeInsets.all(AppDimensions.screenPaddingHorizontal),
              padding: const EdgeInsets.all(AppDimensions.spacing24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.05 * 255).round()),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    reviewState.averageRating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return Icon(
                        index < reviewState.averageRating.floor()
                            ? Icons.star
                            : Icons.star_border,
                        color: AppColors.warningOrange,
                        size: 24,
                      );
                    }),
                  ),
                  const SizedBox(height: AppDimensions.spacing8),
                  Text(
                    '${reviewState.reviews.length} reviews',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spacing16),
          ],

          // Reviews list
          Expanded(
            child: reviewState.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : reviewState.error != null
                    ? Center(
                        child: Text(
                          'Error: ${reviewState.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
                    : reviewState.reviews.isEmpty
                        ? const Center(
                            child: Text('No reviews yet'),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.screenPaddingHorizontal,
                            ),
                            itemCount: reviewState.reviews.length,
                            itemBuilder: (context, index) {
                              final review = reviewState.reviews[index];
                              return ReviewCard(review: review);
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
