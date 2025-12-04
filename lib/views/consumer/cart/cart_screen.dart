import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/cart_controller.dart';
import '../../../controllers/order_controller.dart';
import '../../../controllers/auth_controller.dart';
import '../../../models/order_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/helpers.dart';
import '../../../app/routes/app_routes.dart';
import '../../common/widgets/empty_state_widget.dart';
import '../../common/widgets/custom_button.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(title: Text('cart'.tr)),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return EmptyStateWidget(icon: Icons.shopping_cart_outlined, message: 'empty_cart');
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartController.cartItems[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                            child: Image.network(item.product.images.first, width: 80, height: 80, fit: BoxFit.cover),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.product.name, style: Theme.of(context).textTheme.titleSmall),
                                const SizedBox(height: 4),
                                Text(Helpers.formatPrice(item.product.price), style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.primary)),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle_outline),
                                      onPressed: () => cartController.updateQuantity(item.product.id, item.quantity - 1),
                                      color: AppColors.primary,
                                    ),
                                    Text('${item.quantity}', style: Theme.of(context).textTheme.titleMedium),
                                    IconButton(
                                      icon: const Icon(Icons.add_circle_outline),
                                      onPressed: () => cartController.updateQuantity(item.product.id, item.quantity + 1),
                                      color: AppColors.primary,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: AppColors.error),
                            onPressed: () => cartController.removeFromCart(item.product.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -2))],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('subtotal'.tr, style: Theme.of(context).textTheme.bodyLarge),
                      Text(Helpers.formatPrice(cartController.subtotal), style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('delivery_fee'.tr, style: Theme.of(context).textTheme.bodyLarge),
                      Text(Helpers.formatPrice(cartController.deliveryFee.value), style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('total'.tr, style: Theme.of(context).textTheme.titleLarge),
                      Text(Helpers.formatPrice(cartController.total), style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'proceed_to_checkout',
                      onPressed: () => _checkout(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  void _checkout(BuildContext context) {
    final cartController = Get.find<CartController>();
    final orderController = Get.put(OrderController());
    final authController = Get.find<AuthController>();

    final order = OrderModel(
      id: 'ORD${DateTime.now().millisecondsSinceEpoch}',
      userId: authController.currentUser.value!.id,
      userName: authController.currentUser.value!.name,
      items: cartController.cartItems.toList(),
      subtotal: cartController.subtotal,
      deliveryFee: cartController.deliveryFee.value,
      discount: cartController.discount.value,
      total: cartController.total,
      status: 'pending',
      paymentMethod: 'Cash on Delivery',
      deliveryAddress: 'Abha, Asir Region',
      orderDate: DateTime.now(),
    );

    orderController.placeOrder(order);
    cartController.clearCart();
    Get.offAllNamed(AppRoutes.consumerHome);
    Get.snackbar('success'.tr, 'Order placed successfully!', backgroundColor: AppColors.success, colorText: Colors.white);
  }
}
