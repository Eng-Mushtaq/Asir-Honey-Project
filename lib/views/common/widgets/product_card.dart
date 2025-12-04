import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../models/product_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/helpers.dart';
import '../../../controllers/cart_controller.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CartController());

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Image.network(
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
                      child: Icon(Icons.hive, size: 48, color: AppColors.primary),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.favorite_border, color: AppColors.primary, size: 20),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text(Helpers.formatPrice(product.price), style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: product.rating,
                          itemBuilder: (_, __) => const Icon(Icons.star, color: AppColors.warning),
                          itemCount: 5,
                          itemSize: 12,
                        ),
                        const SizedBox(width: 2),
                        Expanded(child: Text('(${product.reviewCount})', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10), overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(product.beekeeperName, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 28,
                      child: ElevatedButton(
                        onPressed: () => cartController.addToCart(product),
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 4)),
                        child: const Icon(Icons.add_shopping_cart, size: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
