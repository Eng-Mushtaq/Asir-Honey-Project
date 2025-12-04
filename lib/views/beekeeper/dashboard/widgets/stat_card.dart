import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const StatCard({super.key, required this.icon, required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: color, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 2),
            Flexible(
              child: Text(
                title.tr,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
