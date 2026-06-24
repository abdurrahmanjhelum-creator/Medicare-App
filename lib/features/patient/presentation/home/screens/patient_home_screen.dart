import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/providers/providers.dart';
import '../../../../../core/widgets/common/patient_doctor_card.dart';
import '../../../../../core/widgets/common/search_widget.dart';
import '../../../../../core/widgets/common/skeleton_loader.dart';
import '../widgets/quick_patient_action.dart';
import '../widgets/home_banner.dart';
import '../widgets/summary_section.dart';
import '../widgets/home_header.dart';

class PatientHomeScreen extends ConsumerWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeController = ref.watch(homeProvider);
    final doctorController = ref.watch(doctorProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(
              AppDimensions.screenPaddingHorizontal,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeHeader(
                  patientName: homeController.patientName,
                  onNotificationTap: () =>
                      Navigator.pushNamed(context, AppRoutes.notifications),
                  onProfileTap: () =>
                      Navigator.pushNamed(context, AppRoutes.profile),
                ),
                const SizedBox(height: AppDimensions.spacing24),
                const SearchWidget(hintText: AppStrings.searchHint),
                const SizedBox(height: AppDimensions.spacing24),
                HomeBanner(
                  primaryColor: AppColors.primaryGreen,
                  onBookNow: () =>
                      Navigator.pushNamed(context, AppRoutes.doctor),
                ),
                const SizedBox(height: AppDimensions.spacing24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    QuickActionWidget(
                      icon: FontAwesomeIcons.stethoscope,
                      label: AppStrings.doctor,
                      color: AppColors.white,
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.doctor),
                    ),
                    QuickActionWidget(
                      icon: Icons.assignment,
                      label: AppStrings.reports,
                      color: AppColors.white,
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.reports),
                    ),
                    QuickActionWidget(
                      icon: Icons.emergency,
                      label: AppStrings.emergency,
                      color: AppColors.white,
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.emergency),
                    ),
                    QuickActionWidget(
                      icon: Icons.medication,
                      label: AppStrings.pharmacy,
                      color: AppColors.white,
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.pharmacy),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacing32),
                const SummarySection(textColor: AppColors.textPrimary),
                const SizedBox(height: AppDimensions.spacing32),
                const Text(
                  AppStrings.topRatedDoctors,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing16),
                SizedBox(
                  height: 230, // Increased height to prevent overflow
                  child: doctorController.topRatedDoctors.isEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: 3,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(
                              right: AppDimensions.spacing12,
                            ),
                            child: SizedBox(
                              width: AppDimensions.cardHeight320,
                              child: const DoctorCardSkeleton(),
                            ),
                          ),
                        )
                      : ListView.builder(
                          controller: homeController.scrollController,
                          scrollDirection: Axis.horizontal,
                          physics: const ClampingScrollPhysics(),
                          itemCount: doctorController.topRatedDoctors.length,
                          itemBuilder: (context, index) {
                            final doctor =
                                doctorController.topRatedDoctors[index];
                            return Padding(
                              padding: EdgeInsets.only(
                                right:
                                    index <
                                        doctorController
                                                .topRatedDoctors
                                                .length -
                                            1
                                    ? AppDimensions.spacing16
                                    : 0,
                              ),
                              child: SizedBox(
                                width: AppDimensions.cardHeight320,
                                child: DoctorCardWidget(doctor: doctor),
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: AppDimensions.spacing8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
