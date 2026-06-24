import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/token_service.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/widgets/common/appointment_time_checker.dart';
import '../home/screens/patient_home_screen.dart';
import '../doctors/screens/doctor_list_screen.dart';
import '../appointments/screens/appointment_screen.dart';
import '../profile/screens/profile_screen.dart';

class MainLayout extends ConsumerStatefulWidget {
  final int initialIndex;
  const MainLayout({super.key, this.initialIndex = 0});

  static MainLayoutState? of(BuildContext context) =>
      context.findAncestorStateOfType<MainLayoutState>();

  @override
  ConsumerState<MainLayout> createState() => MainLayoutState();
}

class MainLayoutState extends ConsumerState<MainLayout> {
  late int currentIndex;

  // Check role on init and redirect if not a patient
  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    // Delay role check to after build
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final role = await TokenService.getUserRole();
        if (role != null && role != 'patient' && mounted) {
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, AppRoutes.doctorMainLayout);
          }
        }
      } catch (_) {}
    });
  }


  void setIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  final List<Widget> pages = [
    const PatientHomeScreen(),
    const DoctorScreen(),
    const AppointmentScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final upcomingAppointments = ref
        .watch(appointmentProvider)
        .upcomingAppointments;

    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(index: currentIndex, children: pages),
          // Time checker - Sirf Appointment screen (index 2) par chalega
          if (currentIndex == 2)
            AppointmentTimeChecker(appointments: upcomingAppointments),
        ],
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          elevation: 0,
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: AppColors.primaryGreen,
          unselectedItemColor: AppColors.textSecondary,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.stethoscope, size: 20),
              label: "Doctor",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              activeIcon: Icon(Icons.calendar_month),
              label: "Appointment",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
