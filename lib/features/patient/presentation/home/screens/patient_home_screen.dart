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
import '../../bottom_layout/bottom_navbar.dart';

class PatientHomeScreen extends ConsumerWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeController = ref.watch(homeProvider);
    final doctorState = ref.watch(doctorProvider);
    
    // Fetch real-time data from specific providers for accuracy
    final appointmentState = ref.watch(appointmentProvider);
    final reportState = ref.watch(reportProvider);
    final recordState = ref.watch(patientMedicalRecordProvider);

    // Calculate real counts
    final totalAppointments = appointmentState.upcomingAppointments.length + 
                             appointmentState.completedAppointments.length;
    final totalReports = reportState.reports.length;
    final totalPrescriptions = recordState.records.length;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              ref.read(homeProvider).refreshData(),
              ref.read(doctorProvider.notifier).fetchAllDoctors(),
              ref.read(appointmentProvider.notifier).fetchAppointments(),
              ref.read(reportProvider.notifier).fetchReports(),
              ref.read(patientMedicalRecordProvider.notifier).fetchMyMedicalRecords(),
            ]);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                  SearchWidget(
                    hintText: AppStrings.searchHint,
                    readOnly: true,
                    onTap: () {
                      ref.read(doctorProvider.notifier).setSearchAutofocus(true);
                      MainLayout.of(context)?.setIndex(1);
                    },
                  ),
                  const SizedBox(height: AppDimensions.spacing24),
                  HomeBanner(
                    primaryColor: AppColors.primaryGreen,
                    onBookNow: () =>
                        MainLayout.of(context)?.setIndex(1),
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
                            MainLayout.of(context)?.setIndex(1),
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
                  SummarySection(
                    textColor: AppColors.textPrimary,
                    appointments: totalAppointments,
                    labReports: totalReports,
                    prescriptions: totalPrescriptions,
                  ),
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
                    height: 240, // Increased height to prevent overflow
                    child: doctorState.isLoading
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
                        : doctorState.topRatedDoctors.isEmpty
                            ? const Center(
                                child: Text(
                                  "No top rated doctors found",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            : ListView.builder(
                                controller: homeController.scrollController,
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemCount: doctorState.topRatedDoctors.length,
                                itemBuilder: (context, index) {
                                  final doctor =
                                      doctorState.topRatedDoctors[index];
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      right: index <
                                              doctorState
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
      ),
    );
  }
}
