import 'cart_item_model.dart';
import 'product_model.dart';

class OrderModel {
  final String id;
  final String userId;
  final String userName;
  final List<CartItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;
  final String status;
  final String paymentMethod;
  final String deliveryAddress;
  final DateTime orderDate;
  final String? orderNumber;

  OrderModel({
    required this.id,
    required this.userId,
    this.userName = '',
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    required this.status,
    required this.paymentMethod,
    required this.deliveryAddress,
    required this.orderDate,
    this.orderNumber,
  });

  // Helper to extract delivery address from JSONB
  static String _extractDeliveryAddress(dynamic addressJsonb) {
    if (addressJsonb == null) return '';
    
    // If it's already a string, return it
    if (addressJsonb is String) return addressJsonb;
    
    // If it's a Map (JSONB), format it
    if (addressJsonb is Map) {
      final street = addressJsonb['street'] ?? '';
      final city = addressJsonb['city'] ?? '';
      final region = addressJsonb['region'] ?? '';
      final parts = [street, city, region].where((p) => p.isNotEmpty).toList();
      return parts.join(', ');
    }
    
    return '';
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // Handle both snake_case (from database) and camelCase (from app)
    final userId = json['user_id']?.toString() ?? json['userId']?.toString() ?? '';
    final userName = json['user_name'] ?? json['userName'] ?? json['user']?['name'] ?? '';
    
    // Handle delivery_address (JSONB) or deliveryAddress (string)
    final deliveryAddress = _extractDeliveryAddress(
      json['delivery_address'] ?? json['deliveryAddress'],
    );
    
    // Handle order_date (created_at) or orderDate
    DateTime orderDate;
    if (json['created_at'] != null) {
      orderDate = DateTime.parse(json['created_at'].toString());
    } else if (json['orderDate'] != null) {
      orderDate = json['orderDate'] is String 
          ? DateTime.parse(json['orderDate'])
          : json['orderDate'];
    } else {
      orderDate = DateTime.now();
    }
    
    // Handle order_items or items
    List<CartItemModel> itemsList = [];
    if (json['order_items'] != null) {
      // From database: order_items is an array
      final orderItems = json['order_items'];
      if (orderItems is List) {
        itemsList = orderItems.map((item) {
          // Convert order_item to CartItemModel format
          final productName = item['product_name'] is Map
              ? (item['product_name']['en'] ?? item['product_name']['ar'] ?? '')
              : item['product_name'];
          
          return CartItemModel(
            product: ProductModel(
              id: item['product_id']?.toString() ?? '',
              name: productName,
              description: '',
              price: (item['price'] ?? 0.0).toDouble(),
              category: 'other',
              images: [item['product_image'] ?? ''],
              beekeeperId: item['beekeeper_id']?.toString() ?? '',
              stock: 0,
              weight: '1kg',
              harvestDate: DateTime.now(),
            ),
            quantity: item['quantity'] ?? 1,
          );
        }).toList();
      }
    } else if (json['items'] != null) {
      // From app: items is an array
      itemsList = (json['items'] as List)
          .map((item) => CartItemModel.fromJson(item))
          .toList();
    }
    
    return OrderModel(
      id: json['id']?.toString() ?? '',
      userId: userId,
      userName: userName,
      items: itemsList,
      subtotal: (json['subtotal'] ?? 0.0).toDouble(),
      deliveryFee: (json['delivery_fee'] ?? json['deliveryFee'] ?? 0.0).toDouble(),
      discount: (json['discount'] ?? 0.0).toDouble(),
      total: (json['total'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'pending',
      paymentMethod: json['payment_method'] ?? json['paymentMethod'] ?? 'cash',
      deliveryAddress: deliveryAddress,
      orderDate: orderDate,
      orderNumber: json['order_number'] ?? json['orderNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    // Convert to snake_case for database
    return {
      'id': id,
      'user_id': userId,
      'order_number': orderNumber,
      'subtotal': subtotal,
      'delivery_fee': deliveryFee,
      'discount': discount,
      'total': total,
      'status': status,
      'payment_method': paymentMethod,
      'delivery_address': deliveryAddress is Map
          ? deliveryAddress
          : {
              'street': deliveryAddress,
              'city': '',
              'region': '',
            },
      'created_at': orderDate.toIso8601String(),
    };
  }
}
