import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/product_controller.dart';
import '../../../controllers/cart_controller.dart';
import '../../../controllers/language_controller.dart';
import '../../../utils/constants.dart';
import '../../../app/routes/app_routes.dart';
import '../../common/widgets/product_card.dart';
import 'widgets/category_chip.dart';
import 'widgets/banner_carousel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = Get.put(ProductController());
    final cartController = Get.put(CartController());
    final languageController = Get.find<LanguageController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('app_name'.tr),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          Stack(
            children: [
              IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () => Get.toNamed(AppRoutes.cart)),
              Obx(() => cartController.itemCount > 0
                  ? Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                        child: Text('${cartController.itemCount}', style: const TextStyle(color: Colors.white, fontSize: 10)),
                      ),
                    )
                  : const SizedBox()),
            ],
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (value) => languageController.changeLanguage(value),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'en', child: Text('English')),
              const PopupMenuItem(value: 'ar', child: Text('العربية')),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => productController.loadProducts(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BannerCarousel(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('categories'.tr, style: Theme.of(context).textTheme.titleLarge),
                        TextButton(onPressed: () {}, child: Text('view_all'.tr)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          CategoryChip(label: 'sidr_honey', icon: Icons.hive, onTap: () {}),
                          CategoryChip(label: 'samar_honey', icon: Icons.hive, onTap: () {}),
                          CategoryChip(label: 'talah_honey', icon: Icons.hive, onTap: () {}),
                          CategoryChip(label: 'shoka_honey', icon: Icons.hive, onTap: () {}),
                          CategoryChip(label: 'mixed_honey', icon: Icons.hive, onTap: () {}),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('featured_products'.tr, style: Theme.of(context).textTheme.titleLarge),
                        TextButton(onPressed: () => Get.toNamed(AppRoutes.productList), child: Text('view_all'.tr)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Obx(() => GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.65,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: productController.featuredProducts.length,
                          itemBuilder: (context, index) {
                            final product = productController.featuredProducts[index];
                            return ProductCard(
                              product: product,
                              onTap: () => Get.toNamed(AppRoutes.productDetail, arguments: product),
                            );
                          },
                        )),
                  ],
                ),
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
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: 'home'.tr),
          BottomNavigationBarItem(icon: const Icon(Icons.category), label: 'categories'.tr),
          BottomNavigationBarItem(icon: const Icon(Icons.receipt_long), label: 'orders'.tr),
          BottomNavigationBarItem(icon: const Icon(Icons.person), label: 'profile'.tr),
        ],
        onTap: (index) {
          if (index == 1) Get.toNamed(AppRoutes.categories);
          if (index == 2) Get.toNamed(AppRoutes.orders);
          if (index == 3) Get.toNamed(AppRoutes.consumerProfile);
        },
      ),
    );
  }
}
