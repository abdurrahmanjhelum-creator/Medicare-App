import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/core/providers/providers.dart';
import 'package:medicare/core/widgets/common/back_button.dart';
import 'package:medicare/core/widgets/common/header.dart';
import '../widgets/emergency_contact_card.dart';

class EmergencyScreen extends ConsumerWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emergencyController = ref.watch(emergencyProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: Column(
        children: [
          DoctorListHeader(
            title: "Emergency",
            shortText: "Contact for help",
            showSearch: false,
            leading: BackToLoginButton(
              onTap: () => Navigator.pop(context),
              text: "Back",
            ),
            firstColor: Colors.redAccent,
            secondColor: const Color(0xFFE57373),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: emergencyController.contacts.length,
              itemBuilder: (context, index) {
                final contact = emergencyController.contacts[index];
                return EmergencyContactCard(
                  title: contact.title,
                  subtitle: contact.subtitle,
                  icon: contact.icon,
                  iconColor: contact.iconColor,
                  iconBackgroundColor: contact.iconBackgroundColor,
                  onCallPressed: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
