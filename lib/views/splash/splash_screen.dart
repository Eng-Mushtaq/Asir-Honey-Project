import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/storage_service.dart';
import '../../app/routes/app_routes.dart';
import '../../utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
    _navigate();
  }

  void _navigate() async {
    await Future.delayed(const Duration(seconds: 3));
    Get.offAllNamed(AppRoutes.onboarding);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.hive, size: 120, color: Colors.white),
              const SizedBox(height: 24),
              Text(AppStrings.appName, style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 48),
              const CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
