import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/order_controller.dart';
import '../../../utils/constants.dart';
import '../../../utils/helpers.dart';
import '../../common/widgets/empty_state_widget.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderController = Get.put(OrderController());

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('orders'.tr),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'active'.tr),
              Tab(text: 'completed'.tr),
              Tab(text: 'cancelled'.tr),
            ],
          ),
        ),
        body: Obx(() => TabBarView(
              children: [
                _buildOrderList(orderController.activeOrders),
                _buildOrderList(orderController.completedOrders),
                _buildOrderList(orderController.cancelledOrders),
              ],
            )),
      ),
    );
  }

  Widget _buildOrderList(List orders) {
    if (orders.isEmpty) {
      return const EmptyStateWidget(icon: Icons.receipt_long_outlined, message: 'empty_orders');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(backgroundColor: AppColors.primaryLight, child: Icon(Icons.receipt, color: AppColors.primary)),
            title: Text('${'order_number'.tr}: ${order.id}'),
            subtitle: Text(Helpers.formatDate(order.orderDate)),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(Helpers.formatPrice(order.total), style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: _getStatusColor(order.status), borderRadius: BorderRadius.circular(12)),
                  child: Text(Helpers.getOrderStatusText(order.status).tr, style: const TextStyle(color: Colors.white, fontSize: 10)),
                ),
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
