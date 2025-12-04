import 'package:intl/intl.dart';

class Helpers {
  static String formatPrice(double price) {
    return '${price.toStringAsFixed(2)} SAR';
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  static String getOrderStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'order_status_pending';
      case 'processing':
        return 'order_status_processing';
      case 'shipped':
        return 'order_status_shipped';
      case 'delivered':
        return 'order_status_delivered';
      case 'cancelled':
        return 'order_status_cancelled';
      default:
        return status;
    }
  }
}
