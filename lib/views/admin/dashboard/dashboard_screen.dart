import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/admin_controller.dart';
import '../../../controllers/auth_controller.dart';
import '../../../app/routes/app_routes.dart';
import '../../../utils/constants.dart';
import '../../../utils/helpers.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final adminController = Get.find<AdminController>();
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('admin_dashboard'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authController.logout(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => adminController.loadDashboardStats(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.primaryLight,
                        child: Icon(
                          Icons.admin_panel_settings,
                          size: 24,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${'welcome'.tr}, ${authController.currentUser.value?.name ?? "Admin"}',
                              style: Theme.of(context).textTheme.titleMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'admin_role'.tr,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Statistics Cards
              Text(
                'statistics'.tr,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Obx(() {
                if (adminController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.5,
                  children: [
                    _StatCard(
                      icon: Icons.people,
                      title: 'total_users'.tr,
                      value: '${adminController.totalUsers.value}',
                      color: AppColors.primary,
                      onTap: () => Get.toNamed(AppRoutes.adminUsers),
                    ),
                    _StatCard(
                      icon: Icons.inventory,
                      title: 'total_products'.tr,
                      value: '${adminController.totalProducts.value}',
                      color: AppColors.secondary,
                      onTap: () => Get.toNamed(AppRoutes.adminProducts),
                    ),
                    _StatCard(
                      icon: Icons.shopping_bag,
                      title: 'total_orders'.tr,
                      value: '${adminController.totalOrders.value}',
                      color: AppColors.warning,
                      onTap: () => Get.toNamed(AppRoutes.adminOrders),
                    ),
                    _StatCard(
                      icon: Icons.attach_money,
                      title: 'total_revenue'.tr,
                      value: Helpers.formatPrice(adminController.totalRevenue.value),
                      color: AppColors.success,
                      onTap: () {},
                    ),
                  ],
                );
              }),
              const SizedBox(height: 16),

              // Quick Actions
              Text(
                'quick_actions'.tr,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _QuickActionCard(
                icon: Icons.people_outline,
                title: 'manage_users'.tr,
                subtitle: 'view_all_users'.tr,
                onTap: () => Get.toNamed(AppRoutes.adminUsers),
              ),
              const SizedBox(height: 8),
              _QuickActionCard(
                icon: Icons.inventory_2_outlined,
                title: 'manage_products'.tr,
                subtitle: 'moderate_products'.tr,
                onTap: () => Get.toNamed(AppRoutes.adminProducts),
              ),
              const SizedBox(height: 8),
              _QuickActionCard(
                icon: Icons.shopping_cart_outlined,
                title: 'manage_orders'.tr,
                subtitle: 'view_all_orders'.tr,
                onTap: () => Get.toNamed(AppRoutes.adminOrders),
              ),
              const SizedBox(height: 8),
              _QuickActionCard(
                icon: Icons.store_outlined,
                title: 'manage_beekeepers'.tr,
                subtitle: 'verify_beekeepers'.tr,
                onTap: () => Get.toNamed(AppRoutes.adminBeekeepers),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final VoidCallback onTap;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 2),
              Flexible(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: onTap,
      ),
    );
  }
}

