import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/widgets/common/back_button.dart';
import '../../../models/doctor_model.dart';
import '../widgets/doctor_detail_header.dart';
import '../widgets/about_doctor.dart';
import '../widgets/qualification_doctor.dart';
import '../widgets/patient_reviews_card.dart';
import '../widgets/available_slots_widget.dart';
import '../widgets/bottom_book_button.dart';
import '../widgets/doctor_fee.dart';

class DoctorDetailsScreen extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorDetailsScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            DoctorDetailHeader(
              title: doctor.name,
              field: doctor.specialization,
              imagePath: doctor.image,
              rating: double.tryParse(doctor.rating) ?? 0.0,
              reviews:
                  int.tryParse(
                    doctor.reviews.replaceAll(RegExp(r'[^0-9]'), ''),
                  ) ??
                  0,
              leading: BackToLoginButton(
                onTap: () => Navigator.pop(context),
                text: "Back",
              ),
              firstColor: AppColors.primaryGreen,
              secondColor: AppColors.secondaryGreen,
            ),

            const SizedBox(height: 10),

            // About Doctor Section
            AboutDoctor(bio: doctor.bio, branch: doctor.branch),

            DoctorFee(doctorFee: doctor.doctorFee),

            // Qualification Section
            QualificationDoctor(
              qualification: doctor.qualification,
              pmdcLicenceNumber: doctor.pmdcLicenceNumber,
              specialization: doctor.specialization,
            ),

            // Available Slots Section
            AvailableDaysWidget(days: doctor.availableDays),

            const SizedBox(height: 25),

            // Patient Reviews Section
            PatientReviewsCard(reviews: doctor.reviewsList),

            const SizedBox(height: 25),
          ],
        ),
      ),
      bottomNavigationBar: BottomBookButton(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.bookingScreen,
            arguments: doctor,
          );
        },
      ),
    );
  }
}
