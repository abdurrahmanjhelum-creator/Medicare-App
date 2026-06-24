import 'package:flutter/material.dart';

// Onboarding slide ka data model — onboarding_screen se alag folder mein
class OnboardingModel {
  final String title;
  final String subtitle;
  final IconData icon;

  OnboardingModel({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
