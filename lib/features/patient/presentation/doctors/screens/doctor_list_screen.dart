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
    final doctorController = ref.watch(doctorProvider);

    // Check if doctors list is empty (Simulating loading)
    final bool isLoading = doctorController.allDoctors.isEmpty;

    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),
      body: Column(
        children: [
          const DoctorListHeader(
            title: "Our Doctors",
            hintText: "Search Doctors.",
            shortText: "Find the best doctors..",
            showSearch: true,
            firstColor: Color(0xff089B73),
            secondColor: Color(0xff28C7C0),
            leading: null,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              physics: const BouncingScrollPhysics(),
              children: [
                if (isLoading)
                  const ListSkeletonLoader(
                    skeleton: DoctorCardSkeleton(),
                    itemCount: 3,
                    padding: EdgeInsets.zero,
                  )
                else
                  ...doctorController.allDoctors.map(
                    (doctor) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: DoctorCardWidget(doctor: doctor),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
