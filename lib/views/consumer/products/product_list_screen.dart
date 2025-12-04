import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/product_controller.dart';
import '../../../app/routes/app_routes.dart';
import '../../common/widgets/product_card.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = Get.find<ProductController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('products'.tr),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
          IconButton(icon: const Icon(Icons.sort), onPressed: () {}),
        ],
      ),
      body: Obx(() => GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: productController.products.length,
            itemBuilder: (context, index) {
              final product = productController.products[index];
              return ProductCard(
                product: product,
                onTap: () => Get.toNamed(AppRoutes.productDetail, arguments: product),
              );
            },
          )),
    );
  }
}
