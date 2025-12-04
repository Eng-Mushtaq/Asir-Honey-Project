import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/language_controller.dart';
import '../../../controllers/theme_controller.dart';
import '../../../utils/constants.dart';

class BeekeeperProfileScreen extends StatelessWidget {
  const BeekeeperProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final languageController = Get.find<LanguageController>();
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(title: Text('profile'.tr)),
      body: Obx(() {
        final user = authController.currentUser.value;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CircleAvatar(radius: 40, backgroundColor: AppColors.primaryLight, child: Icon(Icons.store, size: 40, color: AppColors.primary)),
                    const SizedBox(height: 12),
                    Text(user?.businessName ?? user?.name ?? '', style: Theme.of(context).textTheme.titleLarge),
                    Text(user?.email ?? '', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 12),
                    ElevatedButton(onPressed: () {}, child: Text('edit_profile'.tr)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _MenuItem(icon: Icons.business, title: 'business_information', onTap: () {}),
            _MenuItem(icon: Icons.account_balance, title: 'bank_details', onTap: () {}),
            _MenuItem(icon: Icons.bar_chart, title: 'statistics', onTap: () {}),
            _MenuItem(icon: Icons.star, title: 'reviews', onTap: () {}),
            _MenuItem(
              icon: Icons.language,
              title: 'language',
              trailing: Text(languageController.isArabic ? 'العربية' : 'English'),
              onTap: () => languageController.changeLanguage(languageController.isArabic ? 'en' : 'ar'),
            ),
            _MenuItem(
              icon: Icons.palette,
              title: 'Theme',
              trailing: Text(_getThemeName(themeController.currentTheme.value)),
              onTap: () => _showThemeDialog(context, themeController),
            ),
            _MenuItem(icon: Icons.notifications, title: 'notifications', onTap: () {}),
            _MenuItem(icon: Icons.help, title: 'help_support', onTap: () {}),
            const SizedBox(height: 16),
            _MenuItem(icon: Icons.logout, title: 'logout', onTap: () => authController.logout(), color: AppColors.error),
          ],
        );
      }),
    );
  }

  String _getThemeName(String theme) {
    switch (theme) {
      case 'forest':
        return 'Forest';
      case 'ocean':
        return 'Ocean';
      case 'asir':
        return 'Asir';
      default:
        return 'Honey';
    }
  }

  void _showThemeDialog(BuildContext context, ThemeController controller) {
    Get.dialog(
      AlertDialog(
        title: Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ThemeOption(
              title: 'Honey Gold',
              color: AppColors.primary,
              isSelected: controller.isHoneyTheme,
              onTap: () {
                controller.changeTheme('honey');
                Get.back();
              },
            ),
            _ThemeOption(
              title: 'Forest Green',
              color: const Color(0xFF2E7D32),
              isSelected: controller.isForestTheme,
              onTap: () {
                controller.changeTheme('forest');
                Get.back();
              },
            ),
            _ThemeOption(
              title: 'Ocean Blue',
              color: const Color(0xFF0277BD),
              isSelected: controller.isOceanTheme,
              onTap: () {
                controller.changeTheme('ocean');
                Get.back();
              },
            ),
            _ThemeOption(
              title: 'Asir Brown',
              color: const Color(0xFF8B6F47),
              isSelected: controller.isAsirTheme,
              onTap: () {
                controller.changeTheme('asir');
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String title;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.title,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundColor: color, radius: 20),
      title: Text(title),
      trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
      onTap: onTap,
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback onTap;
  final Color? color;

  const _MenuItem({required this.icon, required this.title, this.trailing, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: color ?? AppColors.primary),
        title: Text(title.tr, style: TextStyle(color: color)),
        trailing: trailing ?? Icon(Icons.arrow_forward_ios, size: 16, color: color),
        onTap: onTap,
      ),
    );
  }
}
