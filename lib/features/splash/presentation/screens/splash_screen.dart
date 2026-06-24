import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:async';
import '../../../../core/constants/app_colors.dart';
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

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        // Professional way: Using named routes
        // For now, assuming splash goes to onboarding or login
        // I'll use a placeholder route or the first screen
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background using AppColors
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
          ),

          // Center Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Reusable Logo Widget
                const AppLogo(
                  height: 120,
                  width: 120,
                  iconcolor: AppColors.primaryGreen,
                  backgroundcolor: AppColors.white,
                  icon: Icons.add_rounded,
                ),

                const SizedBox(height: 24),

                // Title
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

                // Subtitle
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

          // Bottom Icon
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
