import 'package:flutter/material.dart';

class ReceiptCard extends StatelessWidget {
  final String doctorName;
  final String specialization;

  final String time;
  final String fee;
  final String paymentMethod;

  const ReceiptCard({
    super.key,
    required this.doctorName,
    required this.specialization,
    required this.time,
    required this.fee,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          const Center(
            child: Text(
              "Appointment Details",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1C3D),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildInfoTile(
            icon: Icons.person_outline,
            label: "Doctor",
            value: doctorName,
            subValue: specialization,
            iconColor: const Color(0xFF00A78E),
            bgColor: const Color(0xFFE6F6F4),
          ),
          const SizedBox(height: 12),

          const SizedBox(height: 12),
          _buildInfoTile(
            icon: Icons.access_time,
            label: "Time",
            value: time,
            iconColor: Colors.orange,
            bgColor: const Color(0xFFFFF4E6),
          ),
          const SizedBox(height: 12),

          const SizedBox(height: 12),
          _buildInfoTile(
            icon: Icons.payments_outlined,
            label: "Fee & Method",
            value: "$fee ($paymentMethod)",
            iconColor: Colors.purple,
            bgColor: const Color(0xFFF3E5F5),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9E7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Color(0xFFFFA000), size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "A confirmation has been sent to your email and SMS",
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    String? subValue,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1C3D),
                  ),
                ),
                if (subValue != null)
                  Text(
                    subValue,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF00A78E),
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
