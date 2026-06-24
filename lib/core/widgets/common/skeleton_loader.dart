import 'package:flutter/material.dart';
import '../../constants/app_dimensions.dart';

/// Skeleton loader for showing placeholder content while loading
class SkeletonLoader extends StatelessWidget {
  final double height;
  final double width;
  final BorderRadius? borderRadius;
  final ShapeBorder shape;

  const SkeletonLoader({
    super.key,
    required this.height,
    this.width = double.infinity,
    this.borderRadius,
    this.shape = const RoundedRectangleBorder(),
  });

  factory SkeletonLoader.circle({required double size}) {
    return SkeletonLoader(
      height: size,
      width: size,
      shape: const CircleBorder(),
    );
  }

  factory SkeletonLoader.rounded({
    required double height,
    double width = double.infinity,
    double radius = AppDimensions.radius8,
  }) {
    return SkeletonLoader(
      height: height,
      width: width,
      borderRadius: BorderRadius.circular(radius),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Container(
        height: height,
        width: width,
        decoration: ShapeDecoration(
          color: Colors.grey[300],
          shape: borderRadius != null
              ? RoundedRectangleBorder(borderRadius: borderRadius!)
              : shape,
        ),
      ),
    );
  }
}

class Shimmer extends StatefulWidget {
  final Widget child;
  final LinearGradient? gradient;

  const Shimmer({super.key, required this.child, this.gradient});

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gradient = widget.gradient ??
        LinearGradient(
          colors: [Colors.grey[300]!, Colors.grey[100]!, Colors.grey[300]!],
          stops: const [0.1, 0.5, 0.9],
          begin: const Alignment(-1.0, -0.3),
          end: const Alignment(1.0, 0.3),
          tileMode: TileMode.clamp,
        );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return gradient.createShader(
              Rect.fromLTWH(
                -bounds.width + (bounds.width * 2 * _controller.value),
                0,
                bounds.width,
                bounds.height,
              ),
            );
          },
          child: widget.child,
        );
      },
    );
  }
}

class DoctorCardSkeleton extends StatelessWidget {
  const DoctorCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacing8),
      padding: const EdgeInsets.all(AppDimensions.spacing8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radius5),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonLoader.rounded(height: 65, width: 65, radius: 10),
              const SizedBox(width: AppDimensions.spacing16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppDimensions.spacing4),
                    SkeletonLoader.rounded(height: 16, width: 140),
                    const SizedBox(height: AppDimensions.spacing4),
                    SkeletonLoader.rounded(height: 12, width: 100),
                    const SizedBox(height: AppDimensions.spacing8),
                    SkeletonLoader.rounded(height: 12, width: 120),
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.spacing8),
              SkeletonLoader.rounded(height: 15, width: 40),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing20),
          Row(
            children: [
              Expanded(
                child: SkeletonLoader.rounded(height: 14, width: double.infinity),
              ),
              const SizedBox(width: 20),
              SkeletonLoader.rounded(height: 24, width: 70, radius: AppDimensions.radius30),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing20),
          Row(
            children: [
              Expanded(
                child: SkeletonLoader.rounded(
                  height: AppDimensions.buttonHeight40,
                  width: double.infinity,
                  radius: AppDimensions.radius10,
                ),
              ),
              const SizedBox(width: AppDimensions.spacing16),
              Expanded(
                child: SkeletonLoader.rounded(
                  height: AppDimensions.buttonHeight40,
                  width: double.infinity,
                  radius: AppDimensions.radius40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AppointmentCardSkeleton extends StatelessWidget {
  const AppointmentCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonLoader.rounded(height: 50, width: 50, radius: 12),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLoader.rounded(height: 16, width: 120),
                    const SizedBox(height: 4),
                    SkeletonLoader.rounded(height: 14, width: 80),
                  ],
                ),
              ),
              SkeletonLoader.rounded(height: 24, width: 60, radius: 10),
            ],
          ),
          const SizedBox(height: 16),
          SkeletonLoader.rounded(height: 14, width: 100),
          const SizedBox(height: 8),
          SkeletonLoader.rounded(height: 14, width: 180),
          const SizedBox(height: 8),
          SkeletonLoader.rounded(height: 14, width: 150),
          const SizedBox(height: 20),
          SkeletonLoader.rounded(height: 44, width: double.infinity, radius: 25),
        ],
      ),
    );
  }
}

/// A version of skeleton loader that uses a Column to avoid nested ScrollView issues
class ListSkeletonLoader extends StatelessWidget {
  final int itemCount;
  final Widget skeleton;
  final EdgeInsetsGeometry? padding;

  const ListSkeletonLoader({
    super.key,
    this.itemCount = 5,
    required this.skeleton,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(AppDimensions.spacing12),
      child: Column(
        children: List.generate(itemCount, (index) => skeleton),
      ),
    );
  }
}
