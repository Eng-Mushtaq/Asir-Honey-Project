import 'dart:io';
import 'supabase_service.dart';
import '../models/user_model.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';

class ApiService {
  static final _client = SupabaseService.client;

  // ==================== AUTH ====================
  
  static Future<UserModel?> signUp({
    required String email,
    required String password,
    required Map<String, dynamic> userData,
  }) async {
    try {
      print('🔑 API: Signing up user...');
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: null,
      );

      if (response.user != null) {
        print('✅ API: Auth user created: ${response.user!.id}');
        
        // Ensure email is in userData
        if (!userData.containsKey('email')) {
          userData['email'] = email;
        }
        userData['id'] = response.user!.id;
        
        print('💾 API: Inserting user data to database...');
        print('📝 API: User data: $userData');
        
        try {
          await _client.from('users').insert(userData);
          print('✅ API: User data inserted successfully');
        } catch (dbError, dbStackTrace) {
          print('❌ API: Database insert failed: $dbError');
          print('📍 API: DB Stack trace: $dbStackTrace');
          throw Exception('Failed to create user profile: $dbError');
        }
        
        return UserModel.fromJson(userData);
      }
      throw Exception('Registration failed: No user returned');
    } catch (e, stackTrace) {
      print('❌ API: SignUp exception: $e');
      print('📍 API: Stack trace: $stackTrace');
      rethrow;
    }
  }

  static Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      print('🔑 API: Signing in user...');
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        print('✅ API: Auth successful: ${response.user!.id}');
        print('💾 API: Fetching user data from database...');
        
        try {
          final userData = await _client
              .from('users')
              .select()
              .eq('id', response.user!.id)
              .single();
          print('✅ API: User data fetched successfully');
          return UserModel.fromJson(userData);
        } catch (dbError) {
          print('⚠️ API: User not found in database, user may need to complete registration');
          print('❌ API: Database error: $dbError');
          throw Exception('User profile not found. Please contact support.');
        }
      }
      print('❌ API: SignIn failed: No user returned');
      return null;
    } catch (e, stackTrace) {
      print('❌ API: SignIn exception: $e');
      print('📍 API: Stack trace: $stackTrace');
      rethrow;
    }
  }

  static Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // ==================== PRODUCTS ====================
  
  static Future<List<ProductModel>> getProducts() async {
    try {
      // Fetch products with beekeeper info using simple join
      final response = await _client
          .from('products')
          .select('*, users!beekeeper_id(name, business_name)')
          .eq('is_active', true)
          .order('created_at', ascending: false);
      
      return (response as List).map((json) {
        // Extract beekeeper name from joined data
        if (json['users'] != null) {
          final beekeeper = json['users'];
          if (beekeeper is Map) {
            json['beekeeper_name'] = beekeeper['business_name'] ?? beekeeper['name'] ?? '';
          }
          // Remove users key to avoid confusion
          json.remove('users');
        }
        return ProductModel.fromJson(json);
      }).toList();
    } catch (e) {
      // Fallback: fetch products without join
      final response = await _client
          .from('products')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: false);
      
      return (response as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    }
  }

  static Future<List<ProductModel>> getBeekeeperProducts(String beekeeperId) async {
    try {
      // Fetch products with beekeeper info
      final response = await _client
          .from('products')
          .select('*, users!beekeeper_id(name, business_name)')
          .eq('beekeeper_id', beekeeperId)
          .order('created_at', ascending: false);
      
      return (response as List).map((json) {
        // Extract beekeeper name from joined data
        if (json['users'] != null) {
          final beekeeper = json['users'];
          if (beekeeper is Map) {
            json['beekeeper_name'] = beekeeper['business_name'] ?? beekeeper['name'] ?? '';
          }
          json.remove('users');
        }
        return ProductModel.fromJson(json);
      }).toList();
    } catch (e) {
      // Fallback: fetch products without join
      final response = await _client
          .from('products')
          .select()
          .eq('beekeeper_id', beekeeperId)
          .order('created_at', ascending: false);
      
      return (response as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    }
  }

  static Future<ProductModel> addProduct(ProductModel product) async {
    final response = await _client
        .from('products')
        .insert(product.toJson())
        .select()
        .single();
    
    return ProductModel.fromJson(response);
  }

  static Future<void> updateProduct(ProductModel product) async {
    await _client
        .from('products')
        .update(product.toJson())
        .eq('id', product.id);
  }

  static Future<void> deleteProduct(String productId) async {
    await _client
        .from('products')
        .delete()
        .eq('id', productId);
  }

  // ==================== ORDERS ====================
  
  static Future<OrderModel> createOrder(OrderModel order) async {
    final response = await _client
        .from('orders')
        .insert(order.toJson())
        .select()
        .single();
    
    return OrderModel.fromJson(response);
  }

  static Future<List<OrderModel>> getUserOrders(String userId) async {
    try {
      // Fetch orders with user and order_items
      final response = await _client
          .from('orders')
          .select('*, users!user_id(name), order_items(*)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      
      return (response as List).map((json) {
        // Extract user name from joined data
        if (json['users'] != null) {
          final user = json['users'];
          if (user is Map) {
            json['user_name'] = user['name'] ?? '';
          }
          json.remove('users');
        }
        return OrderModel.fromJson(json);
      }).toList();
    } catch (e) {
      // Fallback: fetch orders without join
      final response = await _client
          .from('orders')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      
      return (response as List)
          .map((json) => OrderModel.fromJson(json))
          .toList();
    }
  }

  static Future<List<OrderModel>> getBeekeeperOrders(String beekeeperId) async {
    try {
      // Fetch order_items for this beekeeper, then get orders
      final orderItems = await _client
          .from('order_items')
          .select('order_id')
          .eq('beekeeper_id', beekeeperId);
      
      if (orderItems.isEmpty) return [];
      
      final orderIds = (orderItems as List)
          .map((item) => item['order_id'])
          .toSet()
          .toList();
      
      // Fetch orders - filter by order IDs in Dart code
      final allOrders = await _client
          .from('orders')
          .select('*, users!user_id(name), order_items(*)')
          .order('created_at', ascending: false);
      
      // Filter orders by IDs in Dart
      final response = (allOrders as List)
          .where((order) => orderIds.contains(order['id']))
          .toList();
      
      return response.map((json) {
        // Extract user name from joined data
        if (json['users'] != null) {
          final user = json['users'];
          if (user is Map) {
            json['user_name'] = user['name'] ?? '';
          }
          json.remove('users');
        }
        // Filter order_items by beekeeper_id
        if (json['order_items'] != null && json['order_items'] is List) {
          final items = json['order_items'] as List;
          json['order_items'] = items
              .where((item) => item['beekeeper_id'] == beekeeperId)
              .toList();
        }
        return OrderModel.fromJson(json);
      }).toList();
    } catch (e) {
      // Fallback: return empty list
      return [];
    }
  }

  static Future<void> updateOrderStatus(String orderId, String status) async {
    await _client
        .from('orders')
        .update({'status': status})
        .eq('id', orderId);
  }

  // ==================== IMAGE UPLOAD ====================
  
  static Future<String> uploadImage(String filePath, String fileName) async {
    final file = File(filePath);
    await _client.storage
        .from('products')
        .uploadBinary('${SupabaseService.currentUser!.id}/$fileName', await file.readAsBytes());
    
    return _client.storage
        .from('products')
        .getPublicUrl('${SupabaseService.currentUser!.id}/$fileName');
  }

  static Future<void> deleteImage(String imageUrl) async {
    final path = imageUrl.split('/products/').last;
    await _client.storage.from('products').remove([path]);
  }

  // ==================== ADMIN ====================
  
  // Get all users
  static Future<List<UserModel>> getAllUsers() async {
    final response = await _client
        .from('users')
        .select()
        .order('created_at', ascending: false);
    
    return (response as List)
        .map((json) => UserModel.fromJson(json))
        .toList();
  }

  // Update user status
  static Future<void> updateUserStatus(String userId, bool isActive) async {
    await _client
        .from('users')
        .update({'is_active': isActive})
        .eq('id', userId);
  }

  // Get all products (admin view - includes inactive)
  static Future<List<ProductModel>> getAllProducts() async {
    try {
      // Fetch products with beekeeper info
      final response = await _client
          .from('products')
          .select('*, users!beekeeper_id(name, business_name)')
          .order('created_at', ascending: false);
      
      return (response as List).map((json) {
        // Extract beekeeper name from joined data
        if (json['users'] != null) {
          final beekeeper = json['users'];
          if (beekeeper is Map) {
            json['beekeeper_name'] = beekeeper['business_name'] ?? beekeeper['name'] ?? '';
          }
          json.remove('users');
        }
        return ProductModel.fromJson(json);
      }).toList();
    } catch (e) {
      // Fallback: fetch products without join
      final response = await _client
          .from('products')
          .select()
          .order('created_at', ascending: false);
      
      return (response as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    }
  }

  // Update product status (approve/reject)
  static Future<void> updateProductStatus(String productId, bool isActive) async {
    await _client
        .from('products')
        .update({'is_active': isActive})
        .eq('id', productId);
  }

  // Feature product
  static Future<void> featureProduct(String productId, bool isFeatured) async {
    await _client
        .from('products')
        .update({'is_featured': isFeatured})
        .eq('id', productId);
  }

  // Get all orders
  static Future<List<OrderModel>> getAllOrders() async {
    try {
      // Fetch orders with user and order_items
      final response = await _client
          .from('orders')
          .select('*, users!user_id(name), order_items(*)')
          .order('created_at', ascending: false);
      
      return (response as List).map((json) {
        // Extract user name from joined data
        if (json['users'] != null) {
          final user = json['users'];
          if (user is Map) {
            json['user_name'] = user['name'] ?? '';
          }
          json.remove('users');
        }
        // Rename order_items to order_items for consistency
        if (json['order_items'] != null) {
          // Already in correct format
        }
        return OrderModel.fromJson(json);
      }).toList();
    } catch (e) {
      // Fallback: fetch orders without join
      final response = await _client
          .from('orders')
          .select()
          .order('created_at', ascending: false);
      
      return (response as List)
          .map((json) => OrderModel.fromJson(json))
          .toList();
    }
  }

  // Update order status
  static Future<void> updateOrderStatusAdmin(String orderId, String status) async {
    await _client
        .from('orders')
        .update({'status': status})
        .eq('id', orderId);
  }

  // Get all beekeepers
  static Future<List<UserModel>> getAllBeekeepers() async {
    final response = await _client
        .from('users')
        .select()
        .eq('user_type', 'beekeeper')
        .order('created_at', ascending: false);
    
    return (response as List)
        .map((json) => UserModel.fromJson(json))
        .toList();
  }

  // Verify beekeeper
  static Future<void> verifyBeekeeper(String beekeeperId, bool isVerified) async {
    await _client
        .from('users')
        .update({'is_verified': isVerified})
        .eq('id', beekeeperId);
  }

  // Get dashboard stats
  static Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      // Get all data and count
      final users = await _client.from('users').select('id');
      final products = await _client.from('products').select('id');
      final orders = await _client.from('orders').select('total');
      
      // Calculate total revenue
      double totalRevenue = 0.0;
      final ordersList = orders as List;
      for (var order in ordersList) {
        if (order['total'] != null) {
          totalRevenue += (order['total'] as num).toDouble();
        }
      }
      
      return {
        'totalUsers': (users as List).length,
        'totalProducts': (products as List).length,
        'totalOrders': (orders as List).length,
        'totalRevenue': totalRevenue,
      };
    } catch (e) {
      // Return zeros if query fails
      return {
        'totalUsers': 0,
        'totalProducts': 0,
        'totalOrders': 0,
        'totalRevenue': 0.0,
      };
    }
  }
}
