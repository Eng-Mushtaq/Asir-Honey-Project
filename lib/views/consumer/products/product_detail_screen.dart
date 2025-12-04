import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../models/product_model.dart';
import '../../../controllers/cart_controller.dart';
import '../../../utils/constants.dart';
import '../../../utils/helpers.dart';
import '../../common/widgets/custom_button.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Get.arguments as ProductModel;
    final cartController = Get.put(CartController());

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                product.images.first,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: AppColors.primaryLight,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.primaryLight,
                  child: Center(child: Icon(Icons.hive, size: 100, color: AppColors.primary)),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(Helpers.formatPrice(product.price), style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: product.rating,
                        itemBuilder: (_, __) => const Icon(Icons.star, color: AppColors.warning),
                        itemCount: 5,
                        itemSize: 24,
                      ),
                      const SizedBox(width: 8),
                      Text('${product.rating} (${product.reviewCount} ${'reviews'.tr})', style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: ListTile(
                      leading: CircleAvatar(backgroundColor: AppColors.primaryLight, child: Icon(Icons.store, color: AppColors.primary)),
                      title: Text(product.beekeeperName),
                      subtitle: Text('beekeeper'.tr),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('product_details'.tr, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(product.description, style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 24),
                  Text('specifications'.tr, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  _SpecRow(label: 'honey_type', value: product.category),
                  _SpecRow(label: 'weight', value: product.weight),
                  _SpecRow(label: 'harvest_date', value: Helpers.formatDate(product.harvestDate)),
                  _SpecRow(label: 'stock', value: '${product.stock} units'),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -2))],
        ),
        child: SafeArea(
          child: CustomButton(
            text: 'add_to_cart',
            icon: Icons.add_shopping_cart,
            onPressed: () {
              cartController.addToCart(product);
              Get.back();
            },
          ),
        ),
      ),
    );
  }
}

class _SpecRow extends StatelessWidget {
  final String label;
  final String value;

  const _SpecRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label.tr, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary)),
          Text(value, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
