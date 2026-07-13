import 'dart:async';
import 'package:flutter/material.dart';

class BannerItem {
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final IconData icon;
  final Color? iconColor;
  final String? buttonText;
  final VoidCallback? onTap;

  BannerItem({
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.icon,
    this.iconColor,
    this.buttonText,
    this.onTap,
  });
}

class HomeBanner extends StatefulWidget {
  final Color primaryColor;
  final VoidCallback? onBookNow;

  const HomeBanner({
    super.key,
    required this.primaryColor,
    this.onBookNow,
  });

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  late final List<BannerItem> _banners = [
    BannerItem(
      title: "Book Your Next Appointment",
      subtitle: "Schedule your consultation with trusted doctors in just a few taps.",
      gradientColors: [const Color(0xFF1976D2), const Color(0xFF64B5F6)], // Blue -> Light Blue
      icon: Icons.calendar_month_outlined,
      buttonText: "Book Now",
      onTap: widget.onBookNow,
    ),
    BannerItem(
      title: "Stay Healthy Every Day",
      subtitle: "Eat healthy, stay hydrated, exercise regularly, and prioritize your well-being.",
      gradientColors: [const Color(0xFF388E3C), const Color(0xFF4DB6AC)], // Green -> Teal
      icon: Icons.health_and_safety_outlined,
    ),
    BannerItem(
      title: "Daily Health Tip",
      subtitle: "Small healthy habits today lead to a healthier future.",
      gradientColors: [const Color(0xFFF57C00), const Color(0xFFFFB300)], // Orange -> Amber
      icon: Icons.lightbulb,
      iconColor: Colors.yellow,
    ),
    BannerItem(
      title: "Professional Healthcare Support",
      subtitle: "Our experienced doctors are ready to help you whenever you need medical guidance.",
      gradientColors: [const Color(0xFF7B1FA2), const Color(0xFF9575CD)], // Purple -> Deep Purple
      icon: Icons.medical_services_outlined,
    ),
    BannerItem(
      title: "Emergency Assistance",
      subtitle: "In case of an emergency, quickly access emergency services and medical support.",
      gradientColors: [const Color(0xFFD32F2F), const Color(0xFFFF7043)], // Red -> Deep Orange
      icon: Icons.emergency,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_pageController.hasClients) {
        int nextPage = _currentPage + 1;
        if (nextPage >= _banners.length) {
          nextPage = 0;
        }

        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 140, // Strict height requirement
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              return _buildBannerCard(_banners[index]);
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              width: _currentPage == index ? 20 : 6,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? widget.primaryColor
                    : widget.primaryColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBannerCard(BannerItem banner) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: banner.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: banner.gradientColors[0].withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    banner.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    banner.subtitle,
                    maxLines: banner.buttonText != null ? 1 : 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 11,
                      height: 1.2,
                    ),
                  ),
                  if (banner.buttonText != null) ...[
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 32, // Compact height for button to prevent overflow
                      child: ElevatedButton(
                        onPressed: banner.onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: banner.gradientColors[0],
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          banner.buttonText!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              flex: 2,
              child: Center(
                child: Icon(
                  banner.icon,
                  size: 80, // Consistent with original proportions
                  color: (banner.iconColor ?? Colors.white).withValues(alpha: 0.24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
