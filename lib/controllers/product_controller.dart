import 'package:get/get.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductController extends GetxController {
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxList<ProductModel> featuredProducts = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      isLoading.value = true;
      print('\n📦 Loading products from Supabase...');
      products.value = await ApiService.getProducts();
      print('✅ Products loaded: ${products.length} items');
      featuredProducts.value = products.where((p) => p.isFeatured).take(6).toList();
      if (featuredProducts.isEmpty) {
        featuredProducts.value = products.take(6).toList();
      }
      print('⭐ Featured products: ${featuredProducts.length} items');
    } catch (e, stackTrace) {
      print('\n❌ ═══════════════════════════════════════════════════════');
      print('❌ PRODUCT CONTROLLER ERROR:');
      print('❌ Failed to load products: $e');
      print('📍 Stack Trace:\n$stackTrace');
      print('❌ ═══════════════════════════════════════════════════════\n');
      Get.snackbar('Error', 'Failed to load products: $e');
      // Fallback to dummy data
      _loadDummyProducts();
    } finally {
      isLoading.value = false;
    }
  }

  void _loadDummyProducts() {
    products.value = [
      ProductModel(
        id: '1',
        name: Get.locale?.languageCode == 'ar' ? 'عسل السدر الفاخر' : 'Premium Sidr Honey',
        description: Get.locale?.languageCode == 'ar' 
            ? 'عسل السدر النقي من جبال عسير، يتميز بجودته العالية وفوائده الصحية المتعددة. يتم حصاده من أشجار السدر البرية في المناطق الجبلية'
            : 'Pure Sidr honey from the mountains of Asir, known for its high quality and multiple health benefits. Harvested from wild Sidr trees in mountainous regions',
        price: 250.0,
        category: 'Sidr',
        images: [
          'https://www.arabnews.com/sites/default/files/styles/n_670_395/public/main-image/2024/11/23/4547877-165662866.jpg?itok=MnvPnKjb',
          'https://m.media-amazon.com/images/I/71C5EvAjtBL._AC_UF894%2C1000_QL80_.jpg',
        ],
        beekeeperId: '1',
        beekeeperName: Get.locale?.languageCode == 'ar' ? 'أحمد العسيري' : 'Ahmed Al-Asiri',
        rating: 4.8,
        reviewCount: 45,
        stock: 20,
        weight: '1kg',
        harvestDate: DateTime.now().subtract(const Duration(days: 30)),
      ),
      ProductModel(
        id: '2',
        name: Get.locale?.languageCode == 'ar' ? 'عسل السمر العضوي' : 'Organic Samar Honey',
        description: Get.locale?.languageCode == 'ar'
            ? 'عسل السمر الطبيعي بنكهته الغنية والمميزة، يتم إنتاجه من أشجار السمر في منطقة عسير. غني بالفيتامينات والمعادن الطبيعية'
            : 'Natural Samar honey with rich and distinctive flavor, produced from Samar trees in Asir region. Rich in natural vitamins and minerals',
        price: 180.0,
        category: 'Samar',
        images: [
          'https://www.alyaum.com/uploads/images/2024/11/21/2448011.jpg',
          'https://media.zid.store/thumbs/7a958907-6498-4eb2-b33b-7e48049f6af9/e969392a-ebf2-46b4-9d8a-5560b3a7cd18-thumbnail-1000x1000-70.jpeg',
        ],
        beekeeperId: '2',
        beekeeperName: Get.locale?.languageCode == 'ar' ? 'محمد القحطاني' : 'Mohammed Al-Qahtani',
        rating: 4.6,
        reviewCount: 32,
        stock: 15,
        weight: '1kg',
        harvestDate: DateTime.now().subtract(const Duration(days: 20)),
      ),
      ProductModel(
        id: '3',
        name: Get.locale?.languageCode == 'ar' ? 'عسل الطلح البري' : 'Wild Talah Honey',
        description: Get.locale?.languageCode == 'ar'
            ? 'عسل الطلح النادر من المصادر البرية، يتميز بلونه الداكن وطعمه القوي. يحتوي على مضادات أكسدة عالية وفوائد علاجية متعددة'
            : 'Rare Talah honey from wild sources, characterized by its dark color and strong taste. Contains high antioxidants and multiple therapeutic benefits',
        price: 220.0,
        category: 'Talah',
        images: [
          'https://m.media-amazon.com/images/I/71C5EvAjtBL._AC_UF894%2C1000_QL80_.jpg',
          'https://www.arabnews.com/sites/default/files/styles/n_670_395/public/main-image/2024/11/23/4547877-165662866.jpg?itok=MnvPnKjb',
        ],
        beekeeperId: '1',
        beekeeperName: Get.locale?.languageCode == 'ar' ? 'أحمد العسيري' : 'Ahmed Al-Asiri',
        rating: 4.9,
        reviewCount: 58,
        stock: 10,
        weight: '1kg',
        harvestDate: DateTime.now().subtract(const Duration(days: 15)),
      ),
    ];
    products.addAll([
      ProductModel(
        id: '4',
        name: Get.locale?.languageCode == 'ar' ? 'عسل الشوكة الجبلي' : 'Mountain Shoka Honey',
        description: Get.locale?.languageCode == 'ar'
            ? 'عسل الشوكة الطازج من الجبال العالية، يتميز بنكهته الخفيفة ولونه الذهبي الفاتح. مثالي للاستخدام اليومي'
            : 'Fresh Shoka honey from high mountains, characterized by its light flavor and golden color. Perfect for daily use',
        price: 200.0,
        category: 'Shoka',
        images: [
          'https://media.zid.store/thumbs/7a958907-6498-4eb2-b33b-7e48049f6af9/e969392a-ebf2-46b4-9d8a-5560b3a7cd18-thumbnail-1000x1000-70.jpeg',
          'https://www.alyaum.com/uploads/images/2024/11/21/2448011.jpg',
        ],
        beekeeperId: '2',
        beekeeperName: Get.locale?.languageCode == 'ar' ? 'محمد القحطاني' : 'Mohammed Al-Qahtani',
        rating: 4.7,
        reviewCount: 38,
        stock: 18,
        weight: '1kg',
        harvestDate: DateTime.now().subtract(const Duration(days: 25)),
      ),
      ProductModel(
        id: '5',
        name: Get.locale?.languageCode == 'ar' ? 'عسل الزهور المخلوط' : 'Mixed Flower Honey',
        description: Get.locale?.languageCode == 'ar'
            ? 'عسل مخلوط لذيذ من أزهار متنوعة، يجمع بين نكهات مختلفة من الأزهار البرية. غني بالعناصر الغذائية المتنوعة'
            : 'Delicious mixed honey from various flowers, combining different flavors from wild flowers. Rich in diverse nutrients',
        price: 150.0,
        category: 'Mixed',
        images: [
          'https://www.arabnews.com/sites/default/files/styles/n_670_395/public/main-image/2024/11/23/4547877-165662866.jpg?itok=MnvPnKjb',
          'https://media.zid.store/thumbs/7a958907-6498-4eb2-b33b-7e48049f6af9/e969392a-ebf2-46b4-9d8a-5560b3a7cd18-thumbnail-1000x1000-70.jpeg',
        ],
        beekeeperId: '1',
        beekeeperName: Get.locale?.languageCode == 'ar' ? 'أحمد العسيري' : 'Ahmed Al-Asiri',
        rating: 4.5,
        reviewCount: 42,
        stock: 25,
        weight: '1kg',
        harvestDate: DateTime.now().subtract(const Duration(days: 10)),
      ),
      ProductModel(
        id: '6',
        name: Get.locale?.languageCode == 'ar' ? 'عسل السدر الملكي' : 'Royal Sidr Honey',
        description: Get.locale?.languageCode == 'ar'
            ? 'عسل السدر الملكي بجودة فاخرة، يعتبر من أفضل أنواع العسل في العالم. يتميز بخصائصه العلاجية الفريدة وطعمه المميز'
            : 'Premium quality royal Sidr honey, considered one of the best honey types in the world. Distinguished by its unique therapeutic properties and distinctive taste',
        price: 300.0,
        category: 'Sidr',
        images: [
          'https://m.media-amazon.com/images/I/71C5EvAjtBL._AC_UF894%2C1000_QL80_.jpg',
          'https://www.alyaum.com/uploads/images/2024/11/21/2448011.jpg',
        ],
        beekeeperId: '2',
        beekeeperName: Get.locale?.languageCode == 'ar' ? 'محمد القحطاني' : 'Mohammed Al-Qahtani',
        rating: 5.0,
        reviewCount: 67,
        stock: 8,
        weight: '1kg',
        harvestDate: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ]);
    featuredProducts.value = products.take(6).toList();
  }

  List<ProductModel> getProductsByCategory(String category) {
    return products.where((p) => p.category == category).toList();
  }

  ProductModel? getProductById(String id) {
    return products.firstWhereOrNull((p) => p.id == id);
  }
}
