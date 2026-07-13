import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:medicare/core/providers/providers.dart';
import 'package:medicare/core/widgets/common/back_button.dart';
import 'package:medicare/core/widgets/common/header.dart';
import '../widgets/emergency_contact_card.dart';

class EmergencyScreen extends ConsumerWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emergencyState = ref.watch(emergencyProvider);
    final emergencyNotifier = ref.read(emergencyProvider.notifier);

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
            child: RefreshIndicator(
              onRefresh: () => emergencyNotifier.fetchContacts(),
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: emergencyState.isLoading ? 3 : emergencyState.contacts.length,
                itemBuilder: (context, index) {
                  if (emergencyState.isLoading) {
                    return const Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  
                  if (emergencyState.error != null && emergencyState.contacts.isEmpty) {
                    return Column(
                      children: [
                        const SizedBox(height: 60),
                        const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                        const SizedBox(height: 12),
                        Text('Failed to load contacts', style: TextStyle(color: Colors.grey[600])),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => emergencyNotifier.fetchContacts(),
                          child: const Text('Retry'),
                        ),
                      ],
                    );
                  }

                  if (emergencyState.contacts.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Text('No emergency contacts available', style: TextStyle(color: Colors.grey)),
                      ),
                    );
                  }

                  final contact = emergencyState.contacts[index];
                  return EmergencyContactCard(
                    title: contact.title,
                    subtitle: contact.subtitle,
                    icon: contact.icon,
                    iconColor: contact.iconColor,
                    iconBackgroundColor: contact.iconBackgroundColor,
                    onCallPressed: () async {
                      final Uri phoneUri = Uri(scheme: 'tel', path: contact.subtitle);
                      if (await canLaunchUrl(phoneUri)) {
                        await launchUrl(phoneUri);
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Could not launch phone call')),
                          );
                        }
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
