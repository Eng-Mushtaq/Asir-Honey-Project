import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/admin_controller.dart';
import '../../../utils/constants.dart';
import '../../../utils/helpers.dart';

class AdminProductsScreen extends StatelessWidget {
  const AdminProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final adminController = Get.find<AdminController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('manage_products'.tr),
      ),
      body: Column(
        children: [
          // Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            child: Obx(() => DropdownButtonFormField<String>(
                  value: adminController.productFilter.value,
                  decoration: InputDecoration(
                    labelText: 'filter_by_status'.tr,
                    prefixIcon: const Icon(Icons.filter_list),
                  ),
                  items: [
                    DropdownMenuItem(value: 'all', child: Text('all_products'.tr)),
                    DropdownMenuItem(value: 'pending', child: Text('pending'.tr)),
                    DropdownMenuItem(value: 'approved', child: Text('approved'.tr)),
                    DropdownMenuItem(value: 'rejected', child: Text('rejected'.tr)),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      adminController.productFilter.value = value;
                    }
                  },
                )),
          ),

          // Products List
          Expanded(
            child: Obx(() {
              if (adminController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final products = adminController.filteredProducts;

              if (products.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inventory_2_outlined,
                          size: 80, color: AppColors.textSecondary),
                      const SizedBox(height: 16),
                      Text('no_products_found'.tr,
                          style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return _ProductCard(product: product);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final adminController = Get.find<AdminController>();
    final isFeatured = RxBool(false); // In real app, get from product.isFeatured

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product.images.first,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 80,
                      height: 80,
                      color: AppColors.primaryLight,
                      child: Icon(Icons.hive, color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Product Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.beekeeperName,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        Helpers.formatPrice(product.price),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.category, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  product.category,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 16),
                Icon(Icons.inventory, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  '${'stock'.tr}: ${product.stock}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 16),
                Icon(Icons.star, size: 16, color: AppColors.warning),
                const SizedBox(width: 4),
                Text(
                  '${product.rating} (${product.reviewCount})',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showProductActions(context, product),
                    icon: const Icon(Icons.more_vert),
                    label: Text('actions'.tr),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Obx(() => OutlinedButton.icon(
                      onPressed: () {
                        isFeatured.value = !isFeatured.value;
                        adminController.featureProduct(product.id, isFeatured.value);
                      },
                      icon: Icon(isFeatured.value ? Icons.star : Icons.star_border),
                      label: Text(isFeatured.value ? 'featured'.tr : 'feature'.tr),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isFeatured.value ? AppColors.warning : AppColors.textSecondary,
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showProductActions(BuildContext context, product) {
    final adminController = Get.find<AdminController>();

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.check_circle, color: AppColors.success),
              title: Text('approve'.tr),
              onTap: () {
                adminController.approveProduct(product.id);
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.cancel, color: AppColors.error),
              title: Text('reject'.tr),
              onTap: () {
                adminController.rejectProduct(product.id);
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.visibility_off, color: AppColors.textSecondary),
              title: Text('hide'.tr),
              onTap: () {
                Get.back();
                Get.snackbar('Info', 'Product hidden');
              },
            ),
          ],
        ),
      ),
    );
  }
}

