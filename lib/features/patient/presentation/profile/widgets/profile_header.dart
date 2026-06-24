import 'package:flutter/material.dart';
import 'package:medicare/core/widgets/common/profile_image.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String role;
  final String medicalId;
  final String? imageUrl;
  final bool isEditable;
  final VoidCallback? onImageEdit;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.role,
    required this.medicalId,
    this.imageUrl,
    this.isEditable = false,
    this.onImageEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff089B73), Color(0xff28C7C0)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 15),
          ProfileImage(
            imageUrl: imageUrl,
            size: 100,
            isEditable: isEditable,
            onEdit: onImageEdit,
          ),
          const SizedBox(height: 15),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            role,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "ID: $medicalId",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
