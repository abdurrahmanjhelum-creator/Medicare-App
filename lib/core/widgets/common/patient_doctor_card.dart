import 'package:flutter/material.dart';
import '../../../features/patient/models/doctor_model.dart';
import '../../routes/app_routes.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_dimensions.dart';
import '../../constants/app_strings.dart';
import 'cached_image_widget.dart';

class DoctorCardWidget extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorCardWidget({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacing8),
      padding: const EdgeInsets.all(AppDimensions.spacing8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radius5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: AppDimensions.shadowBlurLarge,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dynamic Image from Model
              DoctorProfileImage(
                imageUrl: doctor.image,
                size: AppDimensions.cardHeight65,
              ),
              const SizedBox(width: AppDimensions.spacing16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppDimensions.spacing4),
                    Text(
                      doctor.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacing4),
                    Text(
                      doctor.specialization,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacing8),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: AppDimensions.iconSize20,
                        ),
                        const SizedBox(width: AppDimensions.spacing2),
                        Text(
                          doctor.rating,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          " (${doctor.reviews})",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 9,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spacing8),
                        const Icon(
                          Icons.workspace_premium_outlined,
                          color: Colors.grey,
                          size: AppDimensions.iconSize16,
                        ),
                        const SizedBox(width: AppDimensions.spacing2),
                        Text(
                          doctor.experience,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.spacing8),
              Padding(
                padding: const EdgeInsets.only(
                  right: AppDimensions.spacing4,
                  top: AppDimensions.spacing4,
                ),
                child: Text(
                  doctor.doctorFee.toString(),
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing20),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: Colors.grey,
                      size: AppDimensions.iconSize20,
                    ),
                    const SizedBox(width: AppDimensions.spacing2),
                    Expanded(
                      child: Text(
                        doctor.branch,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacing12,
                  vertical: AppDimensions.spacing4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffE5F5EF),
                  borderRadius: BorderRadius.circular(AppDimensions.radius30),
                ),
                child: Text(
                  doctor.availability,
                  style: const TextStyle(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.doctorDetails,
                      arguments: doctor,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    minimumSize: const Size(
                      double.infinity,
                      AppDimensions.buttonHeight40,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radius10,
                      ),
                    ),
                  ),
                  child: const Text(
                    AppStrings.details,
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spacing16),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.bookingScreen,
                      arguments: doctor,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(
                      double.infinity,
                      AppDimensions.buttonHeight40,
                    ),
                    side: const BorderSide(
                      color: AppColors.primaryGreen,
                      width: AppDimensions.strokeWidth2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radius40,
                      ),
                    ),
                  ),
                  child: const Text(
                    AppStrings.bookNow,
                    style: TextStyle(
                      color: AppColors.primaryGreen,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
