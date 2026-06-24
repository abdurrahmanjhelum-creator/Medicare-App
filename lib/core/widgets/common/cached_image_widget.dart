import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_dimensions.dart';
import 'skeleton_loader.dart';

/// A highly reusable cached network image widget with skeleton loading
class CachedImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CachedImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = AppDimensions.radius8,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) =>
            placeholder ??
            SkeletonLoader(
              height: height ?? double.infinity,
              width: width ?? double.infinity,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
        errorWidget: (context, url, error) =>
            errorWidget ??
            Container(
              width: width,
              height: height,
              color: Colors.grey[100],
              child: const Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: AppColors.textSecondary,
                  size: 24,
                ),
              ),
            ),
      ),
    );
  }
}

/// Circular profile image widget for doctors or patients
class ProfileImage extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final bool isDoctor;

  const ProfileImage({
    super.key,
    this.imageUrl,
    this.size = AppDimensions.avatarSize56,
    this.isDoctor = false,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildFallback();
    }

    return CachedImageWidget(
      imageUrl: imageUrl!,
      width: size,
      height: size,
      borderRadius: size / 2,
      errorWidget: _buildFallback(),
    );
  }

  Widget _buildFallback() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isDoctor
            ? AppColors.primaryGreen.withValues(alpha: 0.1)
            : AppColors.secondaryGreen.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          isDoctor ? Icons.person_outline : Icons.person,
          color: isDoctor ? AppColors.primaryGreen : AppColors.secondaryGreen,
          size: size * 0.5,
        ),
      ),
    );
  }
}

/// Legacy support or specific doctor profile image with square-ish rounded corners
class DoctorProfileImage extends StatelessWidget {
  final String? imageUrl;
  final double size;

  const DoctorProfileImage({
    super.key,
    required this.imageUrl,
    this.size = AppDimensions.cardHeight65,
  });

  @override
  Widget build(BuildContext context) {
    return CachedImageWidget(
      imageUrl: imageUrl ?? '',
      width: size,
      height: size,
      borderRadius: AppDimensions.radius10,
      errorWidget: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.primaryGreen.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radius10),
        ),
        child: Center(
          child: Icon(
            Icons.medical_services_outlined,
            color: AppColors.primaryGreen,
            size: size * 0.4,
          ),
        ),
      ),
    );
  }
}
