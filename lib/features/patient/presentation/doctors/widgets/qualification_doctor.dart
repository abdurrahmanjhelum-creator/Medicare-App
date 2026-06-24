import 'package:flutter/material.dart';

class QualificationDoctor extends StatelessWidget {
  final String qualification;
  final String pmdcLicenceNumber;
  final String specialization;

  const QualificationDoctor({
    super.key,
    required this.qualification,
    required this.pmdcLicenceNumber,
    required this.specialization,
  });

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with Icon
          const Row(
            children: [
              Icon(
                Icons.school_outlined,
                color: Color(0xff089B73),
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                "Qualification",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D1B3D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _infoRow(Icons.badge_outlined, "PMDC Code", pmdcLicenceNumber),
          const SizedBox(height: 12),
          _infoRow(Icons.workspace_premium_outlined, "Degree", qualification),
          const SizedBox(height: 12),
          _infoRow(Icons.star_outline, "Specialty", specialization),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black,),
        const SizedBox(width: 10),
        Text("$label: ", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
