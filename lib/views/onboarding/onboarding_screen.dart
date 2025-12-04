import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../services/storage_service.dart';
import '../../app/routes/app_routes.dart';
import '../../utils/constants.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {'title': 'onboarding_title_1', 'desc': 'onboarding_desc_1', 'icon': 'people'},
    {'title': 'onboarding_title_2', 'desc': 'onboarding_desc_2', 'icon': 'hive'},
    {'title': 'onboarding_title_3', 'desc': 'onboarding_desc_3', 'icon': 'shopping_cart'},
  ];

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
  }

  void _skip() {
    StorageService.saveOnboardingStatus(true);
    Get.offAllNamed(AppRoutes.accountType);
  }

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      _skip();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 60),
                  Text('app_name'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primary)),
                  if (_currentPage < _pages.length - 1)
                    TextButton(onPressed: _skip, child: Text('skip'.tr))
                  else
                    const SizedBox(width: 60),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_getIcon(page['icon']!), size: 150, color: AppColors.primary),
                        const SizedBox(height: 48),
                        Text(page['title']!.tr, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        Text(page['desc']!.tr, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _pages.length,
                    effect: WormEffect(
                      dotColor: AppColors.divider,
                      activeDotColor: AppColors.primary,
                      dotHeight: 12,
                      dotWidth: 12,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _next,
                      child: Text(_currentPage < _pages.length - 1 ? 'next'.tr : 'get_started'.tr),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String name) {
    switch (name) {
      case 'people':
        return Icons.people;
      case 'hive':
        return Icons.hive;
      case 'shopping_cart':
        return Icons.shopping_cart;
      default:
        return Icons.info;
    }
  }
}
