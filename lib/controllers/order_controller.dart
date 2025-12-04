import 'package:get/get.dart';
import '../models/order_model.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';
import '../controllers/auth_controller.dart';

class OrderController extends GetxController {
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxList<OrderModel> beekeeperOrders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      isLoading.value = true;
      final authController = Get.find<AuthController>();
      final userId = authController.currentUser.value?.id;
      print('\n📦 Loading orders for user: $userId');
      if (userId != null) {
        orders.value = await ApiService.getUserOrders(userId);
        print('✅ Orders loaded: ${orders.length} items');
      }
    } catch (e, stackTrace) {
      print('\n❌ ═══════════════════════════════════════════════════════');
      print('❌ ORDER CONTROLLER ERROR (loadOrders):');
      print('❌ Failed to load orders: $e');
      print('📍 Stack Trace:\n$stackTrace');
      print('❌ ═══════════════════════════════════════════════════════\n');
      Get.snackbar('Error', 'Failed to load orders: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadBeekeeperOrders() async {
    try {
      isLoading.value = true;
      final authController = Get.find<AuthController>();
      final beekeeperId = authController.currentUser.value?.id;
      print('\n🐝 Loading beekeeper orders for: $beekeeperId');
      if (beekeeperId != null) {
        beekeeperOrders.value = await ApiService.getBeekeeperOrders(beekeeperId);
        print('✅ Beekeeper orders loaded: ${beekeeperOrders.length} items');
      }
    } catch (e, stackTrace) {
      print('\n❌ ═══════════════════════════════════════════════════════');
      print('❌ ORDER CONTROLLER ERROR (loadBeekeeperOrders):');
      print('❌ Failed to load beekeeper orders: $e');
      print('📍 Stack Trace:\n$stackTrace');
      print('❌ ═══════════════════════════════════════════════════════\n');
      Get.snackbar('Error', 'Failed to load orders: $e');
      // Fallback to dummy data
      _loadDummyBeekeeperOrders();
    } finally {
      isLoading.value = false;
    }
  }

  void _loadDummyBeekeeperOrders() {
    beekeeperOrders.value = [
      // New Orders
      OrderModel(
        id: 'BO001',
        userId: 'C001',
        userName: Get.locale?.languageCode == 'ar' ? 'خالد أحمد' : 'Khalid Ahmed',
        items: [
          CartItemModel(
            product: ProductModel(
              id: '1',
              name: Get.locale?.languageCode == 'ar' ? 'عسل السدر' : 'Sidr Honey',
              description: '',
              price: 250.0,
              category: 'Sidr',
              images: ['https://www.arabnews.com/sites/default/files/styles/n_670_395/public/main-image/2024/11/23/4547877-165662866.jpg?itok=MnvPnKjb'],
              beekeeperId: '1',
              beekeeperName: 'My Business',
              rating: 4.8,
              reviewCount: 45,
              stock: 20,
              weight: '1kg',
              harvestDate: DateTime.now(),
            ),
            quantity: 2,
          ),
        ],
        subtotal: 500.0,
        deliveryFee: 20.0,
        discount: 0.0,
        total: 520.0,
        status: 'pending',
        paymentMethod: 'Cash on Delivery',
        deliveryAddress: Get.locale?.languageCode == 'ar' ? 'أبها، منطقة عسير' : 'Abha, Asir Region',
        orderDate: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      OrderModel(
        id: 'BO002',
        userId: 'C002',
        userName: Get.locale?.languageCode == 'ar' ? 'فاطمة محمد' : 'Fatima Mohammed',
        items: [
          CartItemModel(
            product: ProductModel(
              id: '2',
              name: Get.locale?.languageCode == 'ar' ? 'عسل السمر' : 'Samar Honey',
              description: '',
              price: 180.0,
              category: 'Samar',
              images: ['https://www.alyaum.com/uploads/images/2024/11/21/2448011.jpg'],
              beekeeperId: '1',
              beekeeperName: 'My Business',
              rating: 4.6,
              reviewCount: 32,
              stock: 15,
              weight: '1kg',
              harvestDate: DateTime.now(),
            ),
            quantity: 1,
          ),
        ],
        subtotal: 180.0,
        deliveryFee: 20.0,
        discount: 0.0,
        total: 200.0,
        status: 'pending',
        paymentMethod: 'Cash on Delivery',
        deliveryAddress: Get.locale?.languageCode == 'ar' ? 'خميس مشيط، عسير' : 'Khamis Mushait, Asir',
        orderDate: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      // Processing Orders
      OrderModel(
        id: 'BO003',
        userId: 'C003',
        userName: Get.locale?.languageCode == 'ar' ? 'عبدالله سعيد' : 'Abdullah Saeed',
        items: [
          CartItemModel(
            product: ProductModel(
              id: '3',
              name: Get.locale?.languageCode == 'ar' ? 'عسل الطلح' : 'Talah Honey',
              description: '',
              price: 220.0,
              category: 'Talah',
              images: ['https://m.media-amazon.com/images/I/71C5EvAjtBL._AC_UF894%2C1000_QL80_.jpg'],
              beekeeperId: '1',
              beekeeperName: 'My Business',
              rating: 4.9,
              reviewCount: 58,
              stock: 10,
              weight: '1kg',
              harvestDate: DateTime.now(),
            ),
            quantity: 3,
          ),
        ],
        subtotal: 660.0,
        deliveryFee: 20.0,
        discount: 30.0,
        total: 650.0,
        status: 'processing',
        paymentMethod: 'Cash on Delivery',
        deliveryAddress: Get.locale?.languageCode == 'ar' ? 'النماص، عسير' : 'Al Namas, Asir',
        orderDate: DateTime.now().subtract(const Duration(days: 1)),
      ),
      OrderModel(
        id: 'BO004',
        userId: 'C004',
        userName: Get.locale?.languageCode == 'ar' ? 'نورة علي' : 'Noura Ali',
        items: [
          CartItemModel(
            product: ProductModel(
              id: '4',
              name: Get.locale?.languageCode == 'ar' ? 'عسل الشوكة' : 'Shoka Honey',
              description: '',
              price: 200.0,
              category: 'Shoka',
              images: ['https://media.zid.store/thumbs/7a958907-6498-4eb2-b33b-7e48049f6af9/e969392a-ebf2-46b4-9d8a-5560b3a7cd18-thumbnail-1000x1000-70.jpeg'],
              beekeeperId: '1',
              beekeeperName: 'My Business',
              rating: 4.7,
              reviewCount: 38,
              stock: 18,
              weight: '1kg',
              harvestDate: DateTime.now(),
            ),
            quantity: 1,
          ),
        ],
        subtotal: 200.0,
        deliveryFee: 20.0,
        discount: 0.0,
        total: 220.0,
        status: 'processing',
        paymentMethod: 'Credit Card',
        deliveryAddress: Get.locale?.languageCode == 'ar' ? 'رجال ألمع، عسير' : 'Rijal Almaa, Asir',
        orderDate: DateTime.now().subtract(const Duration(days: 1, hours: 12)),
      ),
      // Completed Orders
      OrderModel(
        id: 'BO005',
        userId: 'C005',
        userName: Get.locale?.languageCode == 'ar' ? 'سارة حسن' : 'Sara Hassan',
        items: [
          CartItemModel(
            product: ProductModel(
              id: '1',
              name: Get.locale?.languageCode == 'ar' ? 'عسل السدر' : 'Sidr Honey',
              description: '',
              price: 250.0,
              category: 'Sidr',
              images: ['https://www.arabnews.com/sites/default/files/styles/n_670_395/public/main-image/2024/11/23/4547877-165662866.jpg?itok=MnvPnKjb'],
              beekeeperId: '1',
              beekeeperName: 'My Business',
              rating: 4.8,
              reviewCount: 45,
              stock: 20,
              weight: '1kg',
              harvestDate: DateTime.now(),
            ),
            quantity: 2,
          ),
        ],
        subtotal: 500.0,
        deliveryFee: 20.0,
        discount: 50.0,
        total: 470.0,
        status: 'delivered',
        paymentMethod: 'Cash on Delivery',
        deliveryAddress: Get.locale?.languageCode == 'ar' ? 'أبها، منطقة عسير' : 'Abha, Asir Region',
        orderDate: DateTime.now().subtract(const Duration(days: 5)),
      ),
      OrderModel(
        id: 'BO006',
        userId: 'C006',
        userName: Get.locale?.languageCode == 'ar' ? 'محمد عبدالله' : 'Mohammed Abdullah',
        items: [
          CartItemModel(
            product: ProductModel(
              id: '5',
              name: Get.locale?.languageCode == 'ar' ? 'عسل مخلوط' : 'Mixed Honey',
              description: '',
              price: 150.0,
              category: 'Mixed',
              images: ['https://www.arabnews.com/sites/default/files/styles/n_670_395/public/main-image/2024/11/23/4547877-165662866.jpg?itok=MnvPnKjb'],
              beekeeperId: '1',
              beekeeperName: 'My Business',
              rating: 4.5,
              reviewCount: 42,
              stock: 25,
              weight: '1kg',
              harvestDate: DateTime.now(),
            ),
            quantity: 4,
          ),
        ],
        subtotal: 600.0,
        deliveryFee: 20.0,
        discount: 0.0,
        total: 620.0,
        status: 'delivered',
        paymentMethod: 'Cash on Delivery',
        deliveryAddress: Get.locale?.languageCode == 'ar' ? 'بيشة، عسير' : 'Bisha, Asir',
        orderDate: DateTime.now().subtract(const Duration(days: 7)),
      ),
      // Cancelled Order
      OrderModel(
        id: 'BO007',
        userId: 'C007',
        userName: Get.locale?.languageCode == 'ar' ? 'أحمد يوسف' : 'Ahmed Youssef',
        items: [
          CartItemModel(
            product: ProductModel(
              id: '2',
              name: Get.locale?.languageCode == 'ar' ? 'عسل السمر' : 'Samar Honey',
              description: '',
              price: 180.0,
              category: 'Samar',
              images: ['https://www.alyaum.com/uploads/images/2024/11/21/2448011.jpg'],
              beekeeperId: '1',
              beekeeperName: 'My Business',
              rating: 4.6,
              reviewCount: 32,
              stock: 15,
              weight: '1kg',
              harvestDate: DateTime.now(),
            ),
            quantity: 1,
          ),
        ],
        subtotal: 180.0,
        deliveryFee: 20.0,
        discount: 0.0,
        total: 200.0,
        status: 'cancelled',
        paymentMethod: 'Cash on Delivery',
        deliveryAddress: Get.locale?.languageCode == 'ar' ? 'محايل، عسير' : 'Muhayil, Asir',
        orderDate: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }

  Future<void> placeOrder(OrderModel order) async {
    try {
      print('\n📦 Placing order...');
      final createdOrder = await ApiService.createOrder(order);
      orders.insert(0, createdOrder);
      print('✅ Order placed successfully: ${createdOrder.id}');
      Get.snackbar('success'.tr, 'Order placed successfully', snackPosition: SnackPosition.BOTTOM);
    } catch (e, stackTrace) {
      print('\n❌ ═══════════════════════════════════════════════════════');
      print('❌ ORDER CONTROLLER ERROR (placeOrder):');
      print('❌ Failed to place order: $e');
      print('📍 Stack Trace:\n$stackTrace');
      print('❌ ═══════════════════════════════════════════════════════\n');
      Get.snackbar('Error', 'Failed to place order: $e');
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      print('\n🔄 Updating order status: $orderId -> $status');
      await ApiService.updateOrderStatus(orderId, status);
      await loadBeekeeperOrders();
      print('✅ Order status updated successfully');
      Get.snackbar('success'.tr, 'Order status updated', snackPosition: SnackPosition.BOTTOM);
    } catch (e, stackTrace) {
      print('\n❌ ═══════════════════════════════════════════════════════');
      print('❌ ORDER CONTROLLER ERROR (updateOrderStatus):');
      print('❌ Failed to update order: $e');
      print('📍 Stack Trace:\n$stackTrace');
      print('❌ ═══════════════════════════════════════════════════════\n');
      Get.snackbar('Error', 'Failed to update order: $e');
    }
  }

  List<OrderModel> get activeOrders => orders.where((o) => o.status != 'delivered' && o.status != 'cancelled').toList();
  List<OrderModel> get completedOrders => orders.where((o) => o.status == 'delivered').toList();
  List<OrderModel> get cancelledOrders => orders.where((o) => o.status == 'cancelled').toList();
}
