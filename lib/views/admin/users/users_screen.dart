import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/admin_controller.dart';
import '../../../utils/constants.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final adminController = Get.find<AdminController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('manage_users'.tr),
      ),
      body: Column(
        children: [
          // Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            child: Obx(() => DropdownButtonFormField<String>(
                  value: adminController.userFilter.value,
                  decoration: InputDecoration(
                    labelText: 'filter_by_type'.tr,
                    prefixIcon: const Icon(Icons.filter_list),
                  ),
                  items: [
                    DropdownMenuItem(value: 'all', child: Text('all_users'.tr)),
                    DropdownMenuItem(value: 'consumer', child: Text('consumers'.tr)),
                    DropdownMenuItem(value: 'beekeeper', child: Text('beekeepers'.tr)),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      adminController.userFilter.value = value;
                    }
                  },
                )),
          ),

          // Users List
          Expanded(
            child: Obx(() {
              if (adminController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final users = adminController.filteredUsers;

              if (users.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline, size: 80, color: AppColors.textSecondary),
                      const SizedBox(height: 16),
                      Text('no_users_found'.tr, style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return _UserCard(user: user);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _UserCard extends StatefulWidget {
  final user;

  const _UserCard({required this.user});

  @override
  State<_UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<_UserCard> {
  late RxBool isActive;

  @override
  void initState() {
    super.initState();
    isActive = RxBool(widget.user.isActive ?? true);
  }

  @override
  Widget build(BuildContext context) {
    final adminController = Get.find<AdminController>();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: widget.user.userType == 'beekeeper'
                      ? AppColors.secondaryLight
                      : AppColors.primaryLight,
                  child: Icon(
                    widget.user.userType == 'beekeeper' ? Icons.store : Icons.person,
                    color: widget.user.userType == 'beekeeper'
                        ? AppColors.secondary
                        : AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        widget.user.email,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: widget.user.userType == 'beekeeper'
                        ? AppColors.secondaryLight
                        : AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.user.userType.toString().tr,
                    style: TextStyle(
                      color: widget.user.userType == 'beekeeper'
                          ? AppColors.secondary
                          : AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.phone, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  widget.user.phone,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (widget.user.userType == 'beekeeper' && widget.user.businessName != null) ...[
                  const SizedBox(width: 16),
                  Icon(Icons.business, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      widget.user.businessName!,
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'status'.tr + ':',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(width: 8),
                    Obx(() => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isActive.value
                                ? AppColors.success.withOpacity(0.1)
                                : AppColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isActive.value ? 'active'.tr : 'inactive'.tr,
                            style: TextStyle(
                              color: isActive.value ? AppColors.success : AppColors.error,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )),
                  ],
                ),
                Obx(() => Switch(
                      value: isActive.value,
                      onChanged: (value) {
                        isActive.value = value;
                        adminController.toggleUserStatus(widget.user.id, value);
                      },
                      activeColor: AppColors.success,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

