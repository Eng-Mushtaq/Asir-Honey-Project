import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/product_controller.dart';
import '../../../app/routes/app_routes.dart';
import '../../../utils/constants.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = Get.find<ProductController>();

    final categories = [
      {'name': 'sidr_honey', 'icon': Icons.hive, 'color': const Color(0xFFF4A460)},
      {'name': 'samar_honey', 'icon': Icons.hive, 'color': const Color(0xFFD2691E)},
      {'name': 'talah_honey', 'icon': Icons.hive, 'color': const Color(0xFF8B4513)},
      {'name': 'shoka_honey', 'icon': Icons.hive, 'color': const Color(0xFFDEB887)},
      {'name': 'mixed_honey', 'icon': Icons.hive, 'color': const Color(0xFFCD853F)},
    ];

    return Scaffold(
      appBar: AppBar(title: Text('categories'.tr)),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final categoryName = category['name'] as String;
          final products = productController.getProductsByCategory(categoryName.split('_')[0].capitalize!);
          
          return Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => Get.toNamed(AppRoutes.productList, arguments: categoryName),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      (category['color'] as Color).withOpacity(0.7),
                      (category['color'] as Color),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(category['icon'] as IconData, size: 48, color: Colors.white),
                    const SizedBox(height: 12),
                    Text(
                      categoryName.tr,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${products.length} ${'products'.tr}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
