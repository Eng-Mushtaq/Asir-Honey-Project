import 'package:get/get.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';
import '../controllers/auth_controller.dart';

class BeekeeperController extends GetxController {
  final RxList<ProductModel> myProducts = <ProductModel>[].obs;
  final RxInt totalProducts = 0.obs;
  final RxInt activeOrders = 0.obs;
  final RxDouble totalRevenue = 0.0.obs;
  final RxInt productViews = 0.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMyProducts();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    try {
      final authController = Get.find<AuthController>();
      final beekeeperId = authController.currentUser.value?.id;
      if (beekeeperId != null) {
        final orders = await ApiService.getBeekeeperOrders(beekeeperId);
        activeOrders.value = orders.where((o) => o.status != 'delivered' && o.status != 'cancelled').length;
        totalRevenue.value = orders.where((o) => o.status == 'delivered').fold(0.0, (sum, o) => sum + o.total);
      }
      totalProducts.value = myProducts.length;
      productViews.value = myProducts.fold(0, (sum, p) => sum + p.reviewCount);
    } catch (e) {
      // Use default values
      totalProducts.value = myProducts.length;
      activeOrders.value = 0;
      totalRevenue.value = 0.0;
      productViews.value = 0;
    }
  }

  Future<void> loadMyProducts() async {
    try {
      isLoading.value = true;
      final authController = Get.find<AuthController>();
      final beekeeperId = authController.currentUser.value?.id;
      print('\n🐝 Loading beekeeper products for: $beekeeperId');
      if (beekeeperId != null) {
        myProducts.value = await ApiService.getBeekeeperProducts(beekeeperId);
        print('✅ Beekeeper products loaded: ${myProducts.length} items');
      }
    } catch (e, stackTrace) {
      print('\n❌ ═══════════════════════════════════════════════════════');
      print('❌ BEEKEEPER CONTROLLER ERROR (loadMyProducts):');
      print('❌ Failed to load products: $e');
      print('📍 Stack Trace:\n$stackTrace');
      print('❌ ═══════════════════════════════════════════════════════\n');
      Get.snackbar('error'.tr, '${'failed_to_load_products'.tr}: $e');
      // Fallback to dummy data
      _loadDummyProducts();
    } finally {
      isLoading.value = false;
    }
  }

  void _loadDummyProducts() {
    myProducts.value = [
      ProductModel(
        id: 'bp1',
        name: Get.locale?.languageCode == 'ar' ? 'عسل السدر الملكي' : 'Royal Sidr Honey',
        description: Get.locale?.languageCode == 'ar' ? 'عسل سدر فاخر من مزرعتي' : 'Premium Sidr honey from my farm',
        price: 280.0,
        category: 'Sidr',
        images: ['https://www.arabnews.com/sites/default/files/styles/n_670_395/public/main-image/2024/11/23/4547877-165662866.jpg?itok=MnvPnKjb'],
        beekeeperId: '1',
        beekeeperName: 'My Business',
        rating: 4.9,
        reviewCount: 23,
        stock: 15,
        weight: '1kg',
        harvestDate: DateTime.now().subtract(const Duration(days: 10)),
      ),
      ProductModel(
        id: 'bp2',
        name: Get.locale?.languageCode == 'ar' ? 'عسل السمر الطبيعي' : 'Natural Samar Honey',
        description: Get.locale?.languageCode == 'ar' ? 'عسل سمر طبيعي 100%' : '100% natural Samar honey',
        price: 190.0,
        category: 'Samar',
        images: ['https://www.alyaum.com/uploads/images/2024/11/21/2448011.jpg'],
        beekeeperId: '1',
        beekeeperName: 'My Business',
        rating: 4.7,
        reviewCount: 18,
        stock: 22,
        weight: '1kg',
        harvestDate: DateTime.now().subtract(const Duration(days: 15)),
      ),
      ProductModel(
        id: 'bp3',
        name: Get.locale?.languageCode == 'ar' ? 'عسل الطلح الجبلي' : 'Mountain Talah Honey',
        description: Get.locale?.languageCode == 'ar' ? 'عسل طلح من الجبال' : 'Talah honey from mountains',
        price: 210.0,
        category: 'Talah',
        images: ['https://m.media-amazon.com/images/I/71C5EvAjtBL._AC_UF894%2C1000_QL80_.jpg'],
        beekeeperId: '1',
        beekeeperName: 'My Business',
        rating: 4.8,
        reviewCount: 31,
        stock: 18,
        weight: '1kg',
        harvestDate: DateTime.now().subtract(const Duration(days: 20)),
      ),
      ProductModel(
        id: 'bp4',
        name: Get.locale?.languageCode == 'ar' ? 'عسل الشوكة' : 'Shoka Honey',
        description: Get.locale?.languageCode == 'ar' ? 'عسل شوكة طازج' : 'Fresh Shoka honey',
        price: 170.0,
        category: 'Shoka',
        images: ['https://media.zid.store/thumbs/7a958907-6498-4eb2-b33b-7e48049f6af9/e969392a-ebf2-46b4-9d8a-5560b3a7cd18-thumbnail-1000x1000-70.jpeg'],
        beekeeperId: '1',
        beekeeperName: 'My Business',
        rating: 4.6,
        reviewCount: 15,
        stock: 25,
        weight: '500g',
        harvestDate: DateTime.now().subtract(const Duration(days: 5)),
      ),
      ProductModel(
        id: 'bp5',
        name: Get.locale?.languageCode == 'ar' ? 'عسل مخلوط' : 'Mixed Honey',
        description: Get.locale?.languageCode == 'ar' ? 'عسل مخلوط من أزهار متنوعة' : 'Mixed honey from various flowers',
        price: 140.0,
        category: 'Mixed',
        images: ['https://www.arabnews.com/sites/default/files/styles/n_670_395/public/main-image/2024/11/23/4547877-165662866.jpg?itok=MnvPnKjb'],
        beekeeperId: '1',
        beekeeperName: 'My Business',
        rating: 4.5,
        reviewCount: 12,
        stock: 30,
        weight: '500g',
        harvestDate: DateTime.now().subtract(const Duration(days: 8)),
      ),
      ProductModel(
        id: 'bp6',
        name: Get.locale?.languageCode == 'ar' ? 'عسل السدر الخاص' : 'Special Sidr Honey',
        description: Get.locale?.languageCode == 'ar' ? 'عسل سدر خاص للمناسبات' : 'Special Sidr honey for occasions',
        price: 320.0,
        category: 'Sidr',
        images: ['https://m.media-amazon.com/images/I/71C5EvAjtBL._AC_UF894%2C1000_QL80_.jpg'],
        beekeeperId: '1',
        beekeeperName: 'My Business',
        rating: 5.0,
        reviewCount: 28,
        stock: 8,
        weight: '1kg',
        harvestDate: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
    totalProducts.value = myProducts.length;
  }

  Future<void> addProduct(ProductModel product) async {
    try {
      print('\n➕ Adding new product: ${product.name}');
      final createdProduct = await ApiService.addProduct(product);
      myProducts.add(createdProduct);
      totalProducts.value++;
      print('✅ Product added successfully: ${createdProduct.id}');
      Get.back();
      Get.snackbar('success'.tr, 'product_added_successfully'.tr, snackPosition: SnackPosition.BOTTOM);
    } catch (e, stackTrace) {
      print('\n❌ ═══════════════════════════════════════════════════════');
      print('❌ BEEKEEPER CONTROLLER ERROR (addProduct):');
      print('❌ Failed to add product: $e');
      print('📍 Stack Trace:\n$stackTrace');
      print('❌ ═══════════════════════════════════════════════════════\n');
      Get.snackbar('error'.tr, '${'failed_to_add_product'.tr}: $e');
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    try {
      print('\n🔄 Updating product: ${product.id}');
      await ApiService.updateProduct(product);
      final index = myProducts.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        myProducts[index] = product;
      }
      print('✅ Product updated successfully');
      Get.back();
      Get.snackbar('success'.tr, 'product_updated_successfully'.tr, snackPosition: SnackPosition.BOTTOM);
    } catch (e, stackTrace) {
      print('\n❌ ═══════════════════════════════════════════════════════');
      print('❌ BEEKEEPER CONTROLLER ERROR (updateProduct):');
      print('❌ Failed to update product: $e');
      print('📍 Stack Trace:\n$stackTrace');
      print('❌ ═══════════════════════════════════════════════════════\n');
      Get.snackbar('error'.tr, '${'failed_to_update_product'.tr}: $e');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      print('\n🗑️ Deleting product: $productId');
      await ApiService.deleteProduct(productId);
      myProducts.removeWhere((p) => p.id == productId);
      totalProducts.value--;
      print('✅ Product deleted successfully');
      Get.snackbar('success'.tr, 'product_deleted_successfully'.tr, snackPosition: SnackPosition.BOTTOM);
    } catch (e, stackTrace) {
      print('\n❌ ═══════════════════════════════════════════════════════');
      print('❌ BEEKEEPER CONTROLLER ERROR (deleteProduct):');
      print('❌ Failed to delete product: $e');
      print('📍 Stack Trace:\n$stackTrace');
      print('❌ ═══════════════════════════════════════════════════════\n');
      Get.snackbar('error'.tr, '${'failed_to_delete_product'.tr}: $e');
    }
  }

  Future<String> uploadProductImage(String filePath, String fileName) async {
    try {
      print('\n📤 Uploading image: $fileName');
      final imageUrl = await ApiService.uploadImage(filePath, fileName);
      print('✅ Image uploaded: $imageUrl');
      return imageUrl;
    } catch (e, stackTrace) {
      print('\n❌ ═══════════════════════════════════════════════════════');
      print('❌ BEEKEEPER CONTROLLER ERROR (uploadProductImage):');
      print('❌ Failed to upload image: $e');
      print('📍 Stack Trace:\n$stackTrace');
      print('❌ ═══════════════════════════════════════════════════════\n');
      rethrow;
    }
  }
}
