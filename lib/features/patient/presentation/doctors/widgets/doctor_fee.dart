import 'package:flutter/material.dart';

class DoctorFee extends StatelessWidget {
  final double doctorFee;

  const DoctorFee({super.key, required this.doctorFee});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Text(
        "Fee:  ${doctorFee.toStringAsFixed(0)}Rs per hour",
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: Color(0xFF0D1B3D),
        ),
      ),
    );
  }
}
