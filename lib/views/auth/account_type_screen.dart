import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../utils/constants.dart';

class AccountTypeScreen extends StatelessWidget {
  const AccountTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('select_account_type'.tr)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _AccountTypeCard(
              icon: Icons.shopping_bag,
              title: 'consumer'.tr,
              description: 'consumer_desc'.tr,
              color: AppColors.primary,
              onTap: () => Get.toNamed(AppRoutes.register, arguments: 'consumer'),
            ),
            const SizedBox(height: 24),
            _AccountTypeCard(
              icon: Icons.store,
              title: 'beekeeper'.tr,
              description: 'beekeeper_desc'.tr,
              color: AppColors.secondary,
              onTap: () => Get.toNamed(AppRoutes.register, arguments: 'beekeeper'),
            ),
            const SizedBox(height: 32),
            TextButton(
              onPressed: () => Get.toNamed(AppRoutes.login),
              child: Text('already_have_account'.tr),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountTypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _AccountTypeCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, size: 48, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
