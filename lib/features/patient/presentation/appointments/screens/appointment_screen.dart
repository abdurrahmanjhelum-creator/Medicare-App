import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/core/providers/providers.dart';
import 'package:medicare/core/widgets/common/header.dart';
import 'package:medicare/core/widgets/common/skeleton_loader.dart';
import 'package:medicare/features/patient/presentation/appointments/widgets/appointment_card.dart';

class AppointmentScreen extends ConsumerStatefulWidget {
  const AppointmentScreen({super.key});

  @override
  ConsumerState<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends ConsumerState<AppointmentScreen> {
  @override
  void initState() {
    super.initState();
    debugPrint("AppointmentScreen: initState");
  }

  @override
  Widget build(BuildContext context) {
    final appointmentState = ref.watch(appointmentProvider);
    final appointmentNotifier = ref.read(appointmentProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: Column(
        children: [
          const DoctorListHeader(
            title: "My Appointments",
            shortText: "Manage your scheduled visits",
            showSearch: false,
            leading: null,
            firstColor: Color(0xff089B73),
            secondColor: Color(0xff28C7C0),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => appointmentNotifier.selectTab(0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: appointmentState.selectedTab == 0
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: appointmentState.selectedTab == 0
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Upcoming",
                          style: TextStyle(
                            color: appointmentState.selectedTab == 0
                                ? const Color(0xff089B73)
                                : Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => appointmentNotifier.selectTab(1),
                      child: Container(
                        decoration: BoxDecoration(
                          color: appointmentState.selectedTab == 1
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: appointmentState.selectedTab == 1
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Completed",
                          style: TextStyle(
                            color: appointmentState.selectedTab == 1
                                ? const Color(0xff089B73)
                                : Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              physics: const BouncingScrollPhysics(),
              children: [
                if (appointmentState.selectedTab == 0) ...[
                  if (appointmentState.isLoading)
                    const ListSkeletonLoader(
                      skeleton: AppointmentCardSkeleton(),
                      itemCount: 2,
                      padding: EdgeInsets.zero,
                    )
                  else if (appointmentState.upcomingAppointments.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Text(
                          'Koi upcoming appointment nahi hai',
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      ),
                    )
                  else
                    ...appointmentState.upcomingAppointments.map(
                      (a) => AppointmentCard(appointment: a),
                    ),
                ],
                if (appointmentState.selectedTab == 1) ...[
                  if (appointmentState.isLoading)
                    const ListSkeletonLoader(
                      skeleton: AppointmentCardSkeleton(),
                      itemCount: 2,
                      padding: EdgeInsets.zero,
                    )
                  else if (appointmentState.completedAppointments.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Text(
                          'Koi completed appointment nahi hai',
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      ),
                    )
                  else
                    ...appointmentState.completedAppointments.map(
                      (a) => AppointmentCard(appointment: a),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
