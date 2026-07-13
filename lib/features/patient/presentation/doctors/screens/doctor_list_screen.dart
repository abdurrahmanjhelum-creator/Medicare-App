import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/core/providers/providers.dart';
import 'package:medicare/core/widgets/common/patient_doctor_card.dart';
import 'package:medicare/core/widgets/common/header.dart';
import 'package:medicare/core/widgets/common/skeleton_loader.dart';

class DoctorScreen extends ConsumerWidget {
  const DoctorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctorState = ref.watch(doctorProvider);
    final notifier = ref.read(doctorProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),
      body: Column(
        children: [
          DoctorListHeader(
            title: "Our Doctors",
            hintText: "Search Doctors...",
            shortText: "Find the best doctors for your health.",
            showSearch: true,
            onSearchChanged: (value) => notifier.filterDoctors(value),
            firstColor: const Color(0xff089B73),
            secondColor: const Color(0xff28C7C0),
            leading: null,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => notifier.fetchAllDoctors(),
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                children: [
                  if (doctorState.isLoading) ...List.generate(
                    3,
                    (index) => const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: DoctorCardSkeleton(),
                    ),
                  ) else if (doctorState.error != null && doctorState.allDoctors.isEmpty) ...[
                    const SizedBox(height: 120),
                    const Icon(Icons.wifi_off, size: 60, color: Colors.grey),
                    const SizedBox(height: 12),
                    Text('Error: ${doctorState.error}', style: const TextStyle(fontSize: 14, color: Colors.grey), textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => notifier.fetchAllDoctors(),
                      child: const Text('Retry'),
                    ),
                  ] else if (doctorState.filteredDoctors.isEmpty) ...[
                    const SizedBox(height: 120),
                    const Center(
                      child: Text('No doctors found', style: TextStyle(color: Colors.grey)),
                    ),
                  ] else ...doctorState.filteredDoctors.map(
                    (doctor) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: DoctorCardWidget(doctor: doctor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
