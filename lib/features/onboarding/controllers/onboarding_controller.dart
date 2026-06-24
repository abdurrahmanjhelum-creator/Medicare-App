import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/onboarding_model.dart';

class OnboardingState {
  final int currentPage;

  OnboardingState({this.currentPage = 0});

  OnboardingState copyWith({int? currentPage}) {
    return OnboardingState(currentPage: currentPage ?? this.currentPage);
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(OnboardingState());

  final PageController pageController = PageController();

  final List<OnboardingModel> onboardingData = [
    OnboardingModel(
      title: 'Book Appointments Easily',
      subtitle: 'Find doctors and schedule appointments instantly.',
      icon: Icons.calendar_today_outlined,
    ),
    OnboardingModel(
      title: 'Track Reports & Prescriptions',
      subtitle: 'View medical reports and prescriptions anytime.',
      icon: Icons.description_outlined,
    ),
    OnboardingModel(
      title: 'Emergency Support 24/7',
      subtitle: 'Get ambulance and emergency help quickly.',
      icon: Icons.local_hospital_outlined,
    ),
  ];

  void setPage(int page) {
    state = state.copyWith(currentPage: page);
  }

  void disposeControllers() {
    pageController.dispose();
  }
}
