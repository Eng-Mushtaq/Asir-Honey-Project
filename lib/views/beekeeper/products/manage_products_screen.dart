import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/beekeeper_controller.dart';
import '../../../utils/constants.dart';
import '../../../utils/helpers.dart';
import '../../../app/routes/app_routes.dart';
import '../../common/widgets/empty_state_widget.dart';
import 'product_detail_screen.dart';
import 'edit_product_screen.dart';

class ManageProductsScreen extends StatelessWidget {
  const ManageProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final beekeeperController = Get.find<BeekeeperController>();

    return Scaffold(
      appBar: AppBar(title: Text('manage_products'.tr)),
      body: Obx(() {
        if (beekeeperController.myProducts.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.inventory_outlined,
            message: 'empty_products',
            actionText: 'add_product',
            onAction: () => Get.toNamed(AppRoutes.addProduct),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.68,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: beekeeperController.myProducts.length,
          itemBuilder: (context, index) {
            final product = beekeeperController.myProducts[index];
            return Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => Get.to(
                  () => const ProductDetailScreen(),
                  arguments: product,
                ),
                child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: 1,
                            child: Image.network(
                              product.images.first,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: AppColors.primaryLight,
                                  child: const Center(child: CircularProgressIndicator()),
                                );
                              },
                              errorBuilder: (_, __, ___) => Container(
                                color: AppColors.primaryLight,
                                child: Icon(Icons.hive, size: 48, color: AppColors.primary),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: product.stock > 0 ? AppColors.success : AppColors.error,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                product.stock > 0 ? 'In Stock' : 'Out',
                                style: const TextStyle(color: Colors.white, fontSize: 9),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 1),
                              Text(
                                Helpers.formatPrice(product.price),
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                              Text(
                                'Stock: ${product.stock}',
                                style: const TextStyle(fontSize: 9, color: Colors.grey),
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () => Get.to(
                                        () => const EditProductScreen(),
                                        arguments: product,
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.all(2),
                                        minimumSize: const Size(0, 24),
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: const Icon(Icons.edit, size: 11),
                                    ),
                                  ),
                                  const SizedBox(width: 3),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () => _confirmDelete(product.id),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.error,
                                        padding: const EdgeInsets.all(2),
                                        minimumSize: const Size(0, 24),
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: const Icon(Icons.delete, size: 11),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
                ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.addProduct),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(String productId) {
    Get.dialog(
      AlertDialog(
        title: Text('delete_product'.tr),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.find<BeekeeperController>().deleteProduct(productId);
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
