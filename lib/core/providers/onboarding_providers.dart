import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/onboarding/controllers/onboarding_controller.dart';

// Onboarding Provider
final onboardingProvider = StateNotifierProvider.autoDispose<OnboardingNotifier, OnboardingState>((ref) {
  final notifier = OnboardingNotifier();
  ref.onDispose(() => notifier.disposeControllers());
  return notifier;
});
