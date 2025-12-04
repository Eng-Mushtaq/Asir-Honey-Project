import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/product_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/helpers.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductModel product = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('product_details'.tr),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Gallery
            SizedBox(
              height: 300,
              child: PageView.builder(
                itemCount: product.images.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    product.images[index],
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.primaryLight,
                      child: Icon(Icons.hive, size: 80, color: AppColors.primary),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),

                  // Price
                  Text(
                    Helpers.formatPrice(product.price),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),

                  // Info Cards
                  Row(
                    children: [
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.inventory,
                          label: 'stock'.tr,
                          value: '${product.stock}',
                          color: product.stock > 0 ? AppColors.success : AppColors.error,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.scale,
                          label: 'weight'.tr,
                          value: product.weight,
                          color: AppColors.info,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.category,
                          label: 'category'.tr,
                          value: product.category,
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.star,
                          label: 'rating'.tr,
                          value: '${product.rating} (${product.reviewCount})',
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    'description'.tr,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description.isNotEmpty
                        ? product.description
                        : 'No description available',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),

                  // Harvest Date
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.calendar_today, color: AppColors.primary),
                    title: Text('harvest_date'.tr),
                    subtitle: Text(Helpers.formatDate(product.harvestDate)),
                  ),

                  // Status
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      product.isActive ? Icons.check_circle : Icons.cancel,
                      color: product.isActive ? AppColors.success : AppColors.error,
                    ),
                    title: Text('status'.tr),
                    subtitle: Text(
                      product.isActive ? 'Active' : 'Inactive',
                      style: TextStyle(
                        color: product.isActive ? AppColors.success : AppColors.error,
                      ),
                    ),
                  ),

                  // Featured
                  if (product.isFeatured)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.star, color: AppColors.warning),
                      title: Text('Featured Product'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
