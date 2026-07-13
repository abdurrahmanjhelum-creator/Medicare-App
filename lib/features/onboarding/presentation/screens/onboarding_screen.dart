import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';

import '../../../../core/routes/app_routes.dart';

import '../../../../core/providers/providers.dart';

import '../../models/onboarding_model.dart';

class OnboardingCarousel extends ConsumerWidget {
  const OnboardingCarousel({super.key});

  void _handleNext(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(onboardingProvider.notifier);

    final state = ref.read(onboardingProvider);

    if (state.currentPage < notifier.onboardingData.length - 1) {
      notifier.pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);

    final notifier = ref.read(onboardingProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenHeight = constraints.maxHeight;

          final screenWidth = constraints.maxWidth;

          final bool isMobile = screenWidth < 500;

          double contentWidth =
              isMobile ? screenWidth : (screenWidth < 1024 ? 500 : 650);

          return Center(
            child: SizedBox(
              width: contentWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: screenHeight * 0.04),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () => notifier.pageController.jumpToPage(
                          notifier.onboardingData.length - 1,
                        ),
                        child: const Text(
                          "Skip",
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: notifier.pageController,
                      itemCount: notifier.onboardingData.length,
                      onPageChanged: (index) => notifier.setPage(index),
                      itemBuilder: (context, index) {
                        return _OnboardingBody(
                          data: notifier.onboardingData[index],
                          screenWidth: contentWidth,
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      notifier.onboardingData.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 6,
                        width: state.currentPage == index ? 24 : 6,
                        decoration: BoxDecoration(
                          color: state.currentPage == index
                              ? AppColors.primaryGreen
                              : const Color(0xFFE0E2E8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => _handleNext(context, ref),
                        child: Text(
                          state.currentPage ==
                                  notifier.onboardingData.length - 1
                              ? "Get Started"
                              : "Next",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _OnboardingBody extends StatelessWidget {
  final OnboardingModel data;

  final double screenWidth;

  const _OnboardingBody({required this.data, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compactHeight = constraints.maxHeight < 360;
        final maxCardSize = compactHeight ? 140.0 : 220.0;
        final cardSize = (screenWidth * (compactHeight ? 0.42 : 0.65)).clamp(
          120.0,
          maxCardSize,
        );

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: cardSize,
                    height: cardSize,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius:
                          BorderRadius.circular(compactHeight ? 24 : 32),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryGreen.withValues(alpha: 0.25),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      data.icon,
                      color: Colors.white,
                      size: compactHeight ? 64 : 100,
                    ),
                  ),
                  SizedBox(height: compactHeight ? 20 : 35),
                  Text(
                    data.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: compactHeight ? 22 : 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    data.subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: compactHeight ? 14 : 16,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
