import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/beekeeper_controller.dart';
import '../../../controllers/auth_controller.dart';
import '../../../utils/constants.dart';
import '../../../utils/helpers.dart';
import '../../../app/routes/app_routes.dart';
import 'widgets/stat_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final beekeeperController = Get.put(BeekeeperController());
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('dashboard'.tr),
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => beekeeperController.loadDashboardData(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: AppColors.primary,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(radius: 30, backgroundColor: Colors.white, child: Icon(Icons.store, size: 30, color: AppColors.primary)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${'welcome'.tr}, ${authController.currentUser.value?.name ?? ''}', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
                            Text(authController.currentUser.value?.businessName ?? '', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('statistics'.tr, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Obx(() => GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.3,
                    children: [
                      StatCard(icon: Icons.inventory, title: 'total_products', value: '${beekeeperController.totalProducts.value}', color: AppColors.primary),
                      StatCard(icon: Icons.shopping_bag, title: 'active_orders', value: '${beekeeperController.activeOrders.value}', color: AppColors.info),
                      StatCard(icon: Icons.attach_money, title: 'total_revenue', value: Helpers.formatPrice(beekeeperController.totalRevenue.value), color: AppColors.success),
                      StatCard(icon: Icons.visibility, title: 'product_views', value: '${beekeeperController.productViews.value}', color: AppColors.warning),
                    ],
                  )),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('quick_actions'.tr, style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Get.toNamed(AppRoutes.addProduct),
                  icon: const Icon(Icons.add),
                  label: Text('add_product'.tr),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Get.toNamed(AppRoutes.manageProducts),
                      icon: const Icon(Icons.inventory),
                      label: Text('manage_products'.tr),
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Get.toNamed(AppRoutes.beekeeperOrders),
                      icon: const Icon(Icons.receipt_long),
                      label: Text('orders'.tr),
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.dashboard), label: 'dashboard'.tr),
          BottomNavigationBarItem(icon: const Icon(Icons.inventory), label: 'products'.tr),
          BottomNavigationBarItem(icon: const Icon(Icons.receipt_long), label: 'orders'.tr),
          BottomNavigationBarItem(icon: const Icon(Icons.person), label: 'profile'.tr),
        ],
        onTap: (index) {
          if (index == 1) Get.toNamed(AppRoutes.manageProducts);
          if (index == 2) Get.toNamed(AppRoutes.beekeeperOrders);
          if (index == 3) Get.toNamed(AppRoutes.beekeeperProfile);
        },
      ),
    );
  }
}
