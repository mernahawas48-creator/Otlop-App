import 'package:flutter/material.dart';
import 'package:otlopapp/core/storage/app_preferences.dart';
import 'package:otlopapp/on_boarding_page.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  Future<void> _finishOnboarding() async {
    await AppPreferences.setOnboardingCompleted();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/auth');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              children: [
                OnBoardingPage(
                  imagePath: 'assets/images/on_boarding_one.png',
                  title: 'Select the Favorites Menu',
                  description: 'Eat well without leaving home. Choose your favorite food with one click.',
                  buttonText: 'Next',
                  onTap: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
                OnBoardingPage(
                  imagePath: 'assets/images/on_boarding_two.png',
                  title: 'Good food at a good price',
                  description: 'Enjoy food from your favorite restaurants at affordable prices.',
                  buttonText: 'Get Started',
                  onTap: _finishOnboarding,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                2,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? const Color(0xFFE50046)
                        : Colors.black26,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
