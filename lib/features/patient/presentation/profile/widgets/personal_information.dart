import 'package:flutter/material.dart';

class PersonalInformation extends StatelessWidget {
  final String email;
  final String phone;
  final String dob;
  final String address;

  const PersonalInformation({
    super.key,
    required this.email,
    required this.phone,
    required this.dob,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Personal Information",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1C1E),
            ),
          ),
          const SizedBox(height: 20),

          // Helper method use kar ke rows banayi hain (Professional Approach)
          _buildInfoRow(Icons.email_outlined, "Email", email),
          _buildInfoRow(Icons.phone_outlined, "Phone", phone),
          _buildInfoRow(Icons.calendar_today_outlined, "Date of Birth", dob),
          _buildInfoRow(Icons.location_on_outlined, "Address", address),
        ],
      ),
    );
  }

  // Ye private method code ko saaf rakhta hai aur repeat nahi hone deta
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey[600], size: 22),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF1A1C1E),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
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
