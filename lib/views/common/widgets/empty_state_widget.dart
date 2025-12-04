import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.message,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 100, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(message.tr, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[600]), textAlign: TextAlign.center),
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(onPressed: onAction, child: Text(actionText!.tr)),
            ],
          ],
        ),
      ),
    );
  }
}
