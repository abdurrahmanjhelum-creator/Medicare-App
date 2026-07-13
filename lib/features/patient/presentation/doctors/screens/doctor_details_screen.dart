import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/providers/patient_providers.dart';
import '../../../../../core/widgets/common/back_button.dart';
import '../../../models/doctor_model.dart';
import '../widgets/doctor_detail_header.dart';
import '../widgets/about_doctor.dart';
import '../widgets/qualification_doctor.dart';
import '../widgets/patient_reviews_card.dart';
import '../widgets/available_slots_widget.dart';
import '../widgets/bottom_book_button.dart';
import '../widgets/doctor_fee.dart';

class DoctorDetailsScreen extends ConsumerStatefulWidget {
  final DoctorModel doctor;

  const DoctorDetailsScreen({super.key, required this.doctor});

  @override
  ConsumerState<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends ConsumerState<DoctorDetailsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(reviewProvider.notifier).fetchReviewsByDoctorId(widget.doctor.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final reviewState = ref.watch(reviewProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            DoctorDetailHeader(
              title: widget.doctor.name,
              field: widget.doctor.specialization,
              imagePath: widget.doctor.image,
              rating: reviewState.averageRating > 0 
                  ? reviewState.averageRating 
                  : (double.tryParse(widget.doctor.rating) ?? 0.0),
              reviews: reviewState.totalReviews > 0
                  ? reviewState.totalReviews
                  : (int.tryParse(widget.doctor.reviews.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0),
              leading: BackToLoginButton(
                onTap: () => Navigator.pop(context),
                text: "Back",
              ),
              firstColor: AppColors.primaryGreen,
              secondColor: AppColors.secondaryGreen,
            ),

            const SizedBox(height: 10),

            // About Doctor Section
            AboutDoctor(bio: widget.doctor.bio, branch: widget.doctor.branch),

            DoctorFee(doctorFee: widget.doctor.doctorFee),

            // Qualification Section
            QualificationDoctor(
              qualification: widget.doctor.qualification,
              pmdcLicenceNumber: widget.doctor.pmdcLicenceNumber,
              specialization: widget.doctor.specialization,
            ),

            // Available Slots Section
            AvailableDaysWidget(days: widget.doctor.availableDays),

            const SizedBox(height: 25),

            // Patient Reviews Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Patient Reviews",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D1B3D),
                    ),
                  ),
                ],
              ),
            ),
            
            if (reviewState.isLoading)
              const Center(child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ))
            else
              PatientReviewsCard(reviews: reviewState.reviews),

            const SizedBox(height: 25),
          ],
        ),
      ),
      bottomNavigationBar: BottomBookButton(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.bookingScreen,
            arguments: widget.doctor,
          );
        },
      ),
    );
  }
}
