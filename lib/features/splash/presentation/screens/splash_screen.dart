import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:async';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/token_service.dart';
import '../../../../core/widgets/common/logo_widget.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    if (await TokenService.isLoggedIn()) {
      final role = await TokenService.getUserRole();
      if (!mounted) return;
      Navigator.pushReplacementNamed(
        context,
        role == 'doctor' ? AppRoutes.doctorMainLayout : AppRoutes.mainLayout,
      );
      return;
    }

    Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppLogo(
                  height: 120,
                  width: 120,
                  iconcolor: AppColors.primaryGreen,
                  backgroundcolor: AppColors.white,
                  icon: Icons.add_rounded,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Medicare Hospital',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Your Health, Our Priority',
                  style: TextStyle(
                    color: AppColors.white.withValues(alpha: 0.9),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Icon(MdiIcons.heartPulse, color: AppColors.white, size: 42),
          ),
        ],
      ),
    );
  }
}
