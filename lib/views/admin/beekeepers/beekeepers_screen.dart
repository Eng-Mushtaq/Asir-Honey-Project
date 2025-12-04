import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/admin_controller.dart';
import '../../../utils/constants.dart';

class AdminBeekeepersScreen extends StatelessWidget {
  const AdminBeekeepersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final adminController = Get.find<AdminController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('manage_beekeepers'.tr),
      ),
      body: Column(
        children: [
          // Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            child: Obx(() => DropdownButtonFormField<String>(
                  value: adminController.beekeeperFilter.value,
                  decoration: InputDecoration(
                    labelText: 'filter_by_verification'.tr,
                    prefixIcon: const Icon(Icons.filter_list),
                  ),
                  items: [
                    DropdownMenuItem(value: 'all', child: Text('all_beekeepers'.tr)),
                    DropdownMenuItem(value: 'verified', child: Text('verified'.tr)),
                    DropdownMenuItem(value: 'unverified', child: Text('unverified'.tr)),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      adminController.beekeeperFilter.value = value;
                    }
                  },
                )),
          ),

          // Beekeepers List
          Expanded(
            child: Obx(() {
              if (adminController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final beekeepers = adminController.filteredBeekeepers;

              if (beekeepers.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.store_outlined,
                          size: 80, color: AppColors.textSecondary),
                      const SizedBox(height: 16),
                      Text('no_beekeepers_found'.tr,
                          style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: beekeepers.length,
                itemBuilder: (context, index) {
                  final beekeeper = beekeepers[index];
                  return _BeekeeperCard(beekeeper: beekeeper);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _BeekeeperCard extends StatefulWidget {
  final beekeeper;

  const _BeekeeperCard({required this.beekeeper});

  @override
  State<_BeekeeperCard> createState() => _BeekeeperCardState();
}

class _BeekeeperCardState extends State<_BeekeeperCard> {
  late RxBool isVerified;

  @override
  void initState() {
    super.initState();
    isVerified = RxBool(widget.beekeeper.isVerified ?? false);
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
                  radius: 30,
                  backgroundColor: AppColors.secondaryLight,
                  child: Icon(
                    Icons.store,
                    color: AppColors.secondary,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.beekeeper.name,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          Obx(() => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isVerified.value
                                      ? AppColors.success.withOpacity(0.1)
                                      : AppColors.warning.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isVerified.value
                                          ? Icons.verified
                                          : Icons.pending,
                                      size: 14,
                                      color: isVerified.value
                                          ? AppColors.success
                                          : AppColors.warning,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      isVerified.value ? 'verified'.tr : 'unverified'.tr,
                                      style: TextStyle(
                                        color: isVerified.value
                                            ? AppColors.success
                                            : AppColors.warning,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                      Text(
                        widget.beekeeper.email,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (widget.beekeeper.businessName != null) ...[
              Row(
                children: [
                  Icon(Icons.business, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    widget.beekeeper.businessName!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            if (widget.beekeeper.location != null) ...[
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    widget.beekeeper.location!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            Row(
              children: [
                Icon(Icons.phone, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  widget.beekeeper.phone,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (widget.beekeeper.rating != null) ...[
                  const SizedBox(width: 16),
                  Icon(Icons.star, size: 16, color: AppColors.warning),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.beekeeper.rating}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Obx(() => ElevatedButton.icon(
                        onPressed: () {
                          isVerified.value = !isVerified.value;
                          adminController.verifyBeekeeper(
                              widget.beekeeper.id, isVerified.value);
                        },
                        icon: Icon(isVerified.value ? Icons.verified : Icons.check_circle),
                        label: Text(isVerified.value ? 'verified'.tr : 'verify'.tr),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isVerified.value
                              ? AppColors.success
                              : AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                      )),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () => _showBeekeeperDetails(context, widget.beekeeper),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                  child: Text('details'.tr),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showBeekeeperDetails(BuildContext context, beekeeper) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.secondaryLight,
                  child: Icon(
                    Icons.store,
                    color: AppColors.secondary,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        beekeeper.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        beekeeper.email,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _DetailRow(label: 'business_name'.tr, value: beekeeper.businessName ?? 'N/A'),
            _DetailRow(label: 'phone'.tr, value: beekeeper.phone),
            _DetailRow(label: 'location'.tr, value: beekeeper.location ?? 'N/A'),
            if (beekeeper.description != null)
              _DetailRow(label: 'description'.tr, value: beekeeper.description!),
            if (beekeeper.rating != null)
              _DetailRow(label: 'rating'.tr, value: '${beekeeper.rating} / 5.0'),
            _DetailRow(label: 'verification_status'.tr, value: beekeeper.isVerified == true ? 'verified'.tr : 'unverified'.tr),
          ],
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

