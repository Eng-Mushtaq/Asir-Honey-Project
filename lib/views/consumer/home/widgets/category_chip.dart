import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const CategoryChip({super.key, required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(label.tr, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.primary)),
            ],
          ),
        ),
      ),
    );
  }
}
