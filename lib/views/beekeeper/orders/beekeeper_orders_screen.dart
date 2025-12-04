import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/order_controller.dart';
import '../../../utils/constants.dart';
import '../../../utils/helpers.dart';
import '../../common/widgets/empty_state_widget.dart';

class BeekeeperOrdersScreen extends StatelessWidget {
  const BeekeeperOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderController = Get.isRegistered<OrderController>()
        ? Get.find<OrderController>()
        : Get.put(OrderController());

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('orders'.tr),
          bottom: TabBar(
            indicatorColor: Colors.white,
            isScrollable: true,
            tabs: [
              Tab(text: 'new_orders'.tr),
              Tab(text: 'processing'.tr),
              Tab(text: 'completed'.tr),
              Tab(text: 'cancelled'.tr),
            ],
          ),
        ),
        body: Obx(() {
          print(
            'Beekeeper orders count: ${orderController.beekeeperOrders.length}',
          );
          return TabBarView(
            children: [
              _buildOrderList(
                orderController.beekeeperOrders
                    .where((o) => o.status == 'pending')
                    .toList(),
                'pending',
              ),
              _buildOrderList(
                orderController.beekeeperOrders
                    .where((o) => o.status == 'processing')
                    .toList(),
                'processing',
              ),
              _buildOrderList(
                orderController.beekeeperOrders
                    .where((o) => o.status == 'delivered')
                    .toList(),
                'delivered',
              ),
              _buildOrderList(
                orderController.beekeeperOrders
                    .where((o) => o.status == 'cancelled')
                    .toList(),
                'cancelled',
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildOrderList(List orders, String status) {
    print('Orders for $status: ${orders.length}');
    if (orders.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.receipt_long_outlined,
        message: 'No $status orders',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${'order_number'.tr}: ${order.id}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(order.status),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        Helpers.getOrderStatusText(order.status).tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      order.userName,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      Helpers.formatDateTime(order.orderDate),
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${order.items.length} ${'products'.tr}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      Helpers.formatPrice(order.total),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                if (order.status == 'pending') ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                          ),
                          child: Text('accept'.tr),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.error),
                          ),
                          child: Text(
                            'reject'.tr,
                            style: TextStyle(color: AppColors.error),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return AppColors.warning;
      case 'processing':
        return AppColors.info;
      case 'delivered':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }
}
