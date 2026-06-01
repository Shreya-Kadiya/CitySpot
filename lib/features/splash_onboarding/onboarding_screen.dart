import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Instant Discovery',
      'description':
          'Find open parking slots near you in real-time. Filter by vehicle type, location, and price instantly.',
      'image':
          'https://images.unsplash.com/photo-1506521788723-868151859b87?w=500',
    },
    {
      'title': 'IoT Real-Time Tracking',
      'description':
          'Never guess availability. Our smart parking sensors update status badges immediately so you park hassle-free.',
      'image':
          'https://images.unsplash.com/photo-1573348722427-f1d6819fdf98?w=500',
    },
    {
      'title': 'Seamless Booking',
      'description':
          'Pre-book your spot, navigate directly, and check in via automated passcodes. No approvals required.',
      'image':
          'https://images.unsplash.com/photo-1590674899484-d5640e854abe?w=500',
    },
    {
      'title': 'Earn from Empty Slots',
      'description':
          'List your residential, commercial, or public slots. Set your custom schedule, monitor occupancy, and withdraw earnings.',
      'image':
          'https://images.unsplash.com/photo-1542282088-fe8426682b8f?w=500',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  child: Text(
                    'Skip',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
            // Page slider
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  final item = _onboardingData[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Smooth rounded image container
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            height: 240,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.cardDark
                                  : Colors.grey.shade200,
                            ),
                            child: Image.network(
                              item['image']!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(Icons.image,
                                      size: 64, color: AppColors.primary),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          item['title']!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.textDarkPrimary
                                : AppColors.textLightPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          item['description']!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            height: 1.5,
                            color: isDark
                                ? AppColors.textDarkSecondary
                                : AppColors.textLightSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Indicators and buttons
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Indicators
                  Row(
                    children: List.generate(
                      _onboardingData.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 6),
                        width: _currentIndex == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? AppColors.primary
                              : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  // Next button
                  SizedBox(
                    width: 140,
                    child: CustomButton(
                      text: _currentIndex == _onboardingData.length - 1
                          ? 'Get Started'
                          : 'Next',
                      onPressed: () {
                        if (_currentIndex < _onboardingData.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        }
                      },
                      isFullWidth: true,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
