import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/admin_controller.dart';
import '../../../utils/constants.dart';
import '../../../utils/helpers.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final adminController = Get.find<AdminController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('manage_orders'.tr),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filter Chips Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.03),
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            child: Obx(() => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(
                    label: 'all'.tr,
                    value: 'all',
                    selectedValue: adminController.orderFilter.value,
                    onSelected: (value) => adminController.orderFilter.value = value,
                    color: AppColors.textSecondary,
                  ),
                  _FilterChip(
                    label: 'pending'.tr,
                    value: 'pending',
                    selectedValue: adminController.orderFilter.value,
                    onSelected: (value) => adminController.orderFilter.value = value,
                    color: AppColors.warning,
                  ),
                  _FilterChip(
                    label: 'confirmed'.tr,
                    value: 'confirmed',
                    selectedValue: adminController.orderFilter.value,
                    onSelected: (value) => adminController.orderFilter.value = value,
                    color: AppColors.info,
                  ),
                  _FilterChip(
                    label: 'processing'.tr,
                    value: 'processing',
                    selectedValue: adminController.orderFilter.value,
                    onSelected: (value) => adminController.orderFilter.value = value,
                    color: AppColors.info,
                  ),
                  _FilterChip(
                    label: 'shipped'.tr,
                    value: 'shipped',
                    selectedValue: adminController.orderFilter.value,
                    onSelected: (value) => adminController.orderFilter.value = value,
                    color: Colors.purple,
                  ),
                  _FilterChip(
                    label: 'delivered'.tr,
                    value: 'delivered',
                    selectedValue: adminController.orderFilter.value,
                    onSelected: (value) => adminController.orderFilter.value = value,
                    color: AppColors.success,
                  ),
                  _FilterChip(
                    label: 'cancelled'.tr,
                    value: 'cancelled',
                    selectedValue: adminController.orderFilter.value,
                    onSelected: (value) => adminController.orderFilter.value = value,
                    color: AppColors.error,
                  ),
                ],
              ),
            )),
          ),

          // Orders List
          Expanded(
            child: Obx(() {
              if (adminController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final orders = adminController.filteredOrders;

              if (orders.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_bag_outlined,
                          size: 80, color: AppColors.textSecondary),
                      const SizedBox(height: 16),
                      Text('no_orders_found'.tr,
                          style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return _OrderCard(order: order);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final order;

  const _OrderCard({required this.order});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.warning;
      case 'confirmed':
      case 'processing':
        return AppColors.info;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: _getStatusColor(order.status).withOpacity(0.15),
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: () => _showOrderDetails(context, order),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.receipt_long, color: AppColors.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        order.id,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _getStatusColor(order.status),
                          _getStatusColor(order.status).withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: _getStatusColor(order.status).withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      order.status.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    order.userName,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      order.deliveryAddress,
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    Helpers.formatDate(order.orderDate),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'total'.tr + ':',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    Helpers.formatPrice(order.total),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _showStatusUpdate(context, order),
                  icon: const Icon(Icons.edit),
                  label: Text('update_status'.tr),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOrderDetails(BuildContext context, order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'order_details'.tr,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _DetailRow(label: 'order_number'.tr, value: order.id),
            _DetailRow(label: 'customer'.tr, value: order.userName),
            _DetailRow(label: 'status'.tr, value: order.status.tr),
            _DetailRow(label: 'subtotal'.tr, value: Helpers.formatPrice(order.subtotal)),
            _DetailRow(label: 'delivery_fee'.tr, value: Helpers.formatPrice(order.deliveryFee)),
            _DetailRow(label: 'total'.tr, value: Helpers.formatPrice(order.total)),
            _DetailRow(label: 'payment_method'.tr, value: order.paymentMethod),
            _DetailRow(label: 'delivery_address'.tr, value: order.deliveryAddress),
            _DetailRow(label: 'order_date'.tr, value: Helpers.formatDate(order.orderDate)),
          ],
        ),
      ),
    );
  }

  void _showStatusUpdate(BuildContext context, order) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'update_order_status'.tr,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...[
              'pending',
              'confirmed',
              'processing',
              'shipped',
              'delivered',
              'cancelled',
            ].map((status) => ListTile(
                  leading: Icon(
                    Icons.circle,
                    color: _getStatusColor(status),
                  ),
                  title: Text(status.tr),
                  onTap: () {
                    Get.find<AdminController>().updateOrderStatus(order.id, status);
                    Get.back();
                  },
                )),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final String value;
  final String selectedValue;
  final Function(String) onSelected;
  final Color color;

  const _FilterChip({
    required this.label,
    required this.value,
    required this.selectedValue,
    required this.onSelected,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selectedValue;
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Material(
        elevation: isSelected ? 4 : 0,
        shadowColor: color.withOpacity(0.4),
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: () => onSelected(value),
          borderRadius: BorderRadius.circular(24),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [color, color.withOpacity(0.85)],
                    )
                  : null,
              color: isSelected ? null : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isSelected ? color : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    fontSize: 13,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

