import 'package:get/get.dart';
import '../models/user_model.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';
import '../services/api_service.dart';

class AdminController extends GetxController {
  final RxBool isLoading = false.obs;
  
  // Dashboard Stats
  final RxInt totalUsers = 0.obs;
  final RxInt totalProducts = 0.obs;
  final RxInt totalOrders = 0.obs;
  final RxDouble totalRevenue = 0.0.obs;
  
  // Users Management
  final RxList<UserModel> allUsers = <UserModel>[].obs;
  final RxString userFilter = 'all'.obs;
  
  // Products Management
  final RxList<ProductModel> allProducts = <ProductModel>[].obs;
  final RxString productFilter = 'all'.obs;
  
  // Orders Management
  final RxList<OrderModel> allOrders = <OrderModel>[].obs;
  final RxString orderFilter = 'all'.obs;
  
  // Beekeepers Management
  final RxList<UserModel> allBeekeepers = <UserModel>[].obs;
  final RxString beekeeperFilter = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardStats();
    loadAllUsers();
    loadAllProducts();
    loadAllOrders();
    loadAllBeekeepers();
  }

  // Dashboard Stats
  Future<void> loadDashboardStats() async {
    try {
      isLoading.value = true;
      
      // Fetch real stats from Supabase
      final stats = await ApiService.getDashboardStats();
      
      totalUsers.value = stats['totalUsers'] ?? 0;
      totalProducts.value = stats['totalProducts'] ?? 0;
      totalOrders.value = stats['totalOrders'] ?? 0;
      totalRevenue.value = (stats['totalRevenue'] ?? 0.0).toDouble();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load dashboard stats: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Users Management
  Future<void> loadAllUsers() async {
    try {
      isLoading.value = true;
      
      // Fetch real users from Supabase
      allUsers.value = await ApiService.getAllUsers();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load users: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  List<UserModel> get filteredUsers {
    if (userFilter.value == 'all') return allUsers;
    return allUsers.where((user) => user.userType == userFilter.value).toList();
  }

  Future<void> toggleUserStatus(String userId, bool isActive) async {
    try {
      await ApiService.updateUserStatus(userId, isActive);
      // Reload users to reflect changes
      await loadAllUsers();
      Get.snackbar('Success', 'User status updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update user status: ${e.toString()}');
    }
  }

  // Products Management
  Future<void> loadAllProducts() async {
    try {
      isLoading.value = true;
      
      // Fetch real products from Supabase
      allProducts.value = await ApiService.getAllProducts();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load products: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  List<ProductModel> get filteredProducts {
    if (productFilter.value == 'all') return allProducts;
    // Filter logic can be added for pending/approved/rejected status
    return allProducts;
  }

  Future<void> approveProduct(String productId) async {
    try {
      await ApiService.updateProductStatus(productId, true);
      // Reload products to reflect changes
      await loadAllProducts();
      Get.snackbar('Success', 'Product approved successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to approve product: ${e.toString()}');
    }
  }

  Future<void> rejectProduct(String productId) async {
    try {
      await ApiService.updateProductStatus(productId, false);
      // Reload products to reflect changes
      await loadAllProducts();
      Get.snackbar('Success', 'Product rejected');
    } catch (e) {
      Get.snackbar('Error', 'Failed to reject product: ${e.toString()}');
    }
  }

  Future<void> featureProduct(String productId, bool isFeatured) async {
    try {
      await ApiService.featureProduct(productId, isFeatured);
      // Reload products to reflect changes
      await loadAllProducts();
      Get.snackbar('Success', isFeatured ? 'Product featured' : 'Product unfeatured');
    } catch (e) {
      Get.snackbar('Error', 'Failed to feature product: ${e.toString()}');
    }
  }

  // Orders Management
  Future<void> loadAllOrders() async {
    try {
      isLoading.value = true;
      
      // Fetch real orders from Supabase
      allOrders.value = await ApiService.getAllOrders();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load orders: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  List<OrderModel> get filteredOrders {
    if (orderFilter.value == 'all') return allOrders;
    return allOrders.where((order) => order.status == orderFilter.value).toList();
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await ApiService.updateOrderStatusAdmin(orderId, newStatus);
      // Reload orders to reflect changes
      await loadAllOrders();
      Get.snackbar('Success', 'Order status updated to $newStatus');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update order status: ${e.toString()}');
    }
  }

  // Beekeepers Management
  Future<void> loadAllBeekeepers() async {
    try {
      isLoading.value = true;
      
      // Fetch real beekeepers from Supabase
      allBeekeepers.value = await ApiService.getAllBeekeepers();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load beekeepers: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  List<UserModel> get filteredBeekeepers {
    if (beekeeperFilter.value == 'all') return allBeekeepers;
    // Filter by verification status can be added here
    return allBeekeepers;
  }

  Future<void> verifyBeekeeper(String beekeeperId, bool isVerified) async {
    try {
      await ApiService.verifyBeekeeper(beekeeperId, isVerified);
      // Reload beekeepers to reflect changes
      await loadAllBeekeepers();
      Get.snackbar('Success', isVerified ? 'Beekeeper verified' : 'Beekeeper unverified');
    } catch (e) {
      Get.snackbar('Error', 'Failed to verify beekeeper: ${e.toString()}');
    }
  }
}

