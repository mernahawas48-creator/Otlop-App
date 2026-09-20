import 'package:easy_localization/easy_localization.dart';
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

  Future<void> _changeLanguage(Locale locale) async {
    if (context.locale.languageCode == locale.languageCode) return;

    await context.setLocale(locale);

    if (!mounted) return;
    setState(() {});
  }

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
      body: Stack(
        children: [
          Column(
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
                      title: 'onboarding.first_title'.tr(),
                      description: 'onboarding.first_description'.tr(),
                      buttonText: 'onboarding.next'.tr(),
                      onTap: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                    OnBoardingPage(
                      imagePath: 'assets/images/on_boarding_two.png',
                      title: 'onboarding.second_title'.tr(),
                      description: 'onboarding.second_description'.tr(),
                      buttonText: 'onboarding.get_started'.tr(),
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
          SafeArea(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(top: 12, end: 16),
              child: Align(
                alignment: AlignmentDirectional.topEnd,
                child: _LanguageSwitcher(
                  currentLocale: context.locale,
                  onChanged: _changeLanguage,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageSwitcher extends StatelessWidget {
  final Locale currentLocale;
  final ValueChanged<Locale> onChanged;

  const _LanguageSwitcher({
    required this.currentLocale,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isEnglish = currentLocale.languageCode == 'en';

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE50046).withValues(alpha: 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LanguageButton(
            text: 'EN',
            isSelected: isEnglish,
            onTap: () => onChanged(const Locale('en')),
          ),
          _LanguageButton(
            text: 'AR',
            isSelected: !isEnglish,
            onTap: () => onChanged(const Locale('ar')),
          ),
        ],
      ),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE50046) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFFE50046),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
