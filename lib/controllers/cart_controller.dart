import 'package:get/get.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import '../services/storage_service.dart';

class CartController extends GetxController {
  final RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  final RxDouble deliveryFee = 20.0.obs;
  final RxDouble discount = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  void loadCart() {
    final savedCart = StorageService.getCart();
    cartItems.value = savedCart.map((item) => CartItemModel.fromJson(item)).toList();
  }

  void addToCart(ProductModel product) {
    final existingItem = cartItems.firstWhereOrNull((item) => item.product.id == product.id);
    if (existingItem != null) {
      existingItem.quantity++;
    } else {
      cartItems.add(CartItemModel(product: product));
    }
    saveCart();
    Get.snackbar('success'.tr, 'product_added_to_cart'.tr, snackPosition: SnackPosition.BOTTOM);
  }

  void updateQuantity(String productId, int quantity) {
    final item = cartItems.firstWhereOrNull((item) => item.product.id == productId);
    if (item != null) {
      if (quantity > 0) {
        item.quantity = quantity;
      } else {
        cartItems.remove(item);
      }
      saveCart();
    }
  }

  void removeFromCart(String productId) {
    cartItems.removeWhere((item) => item.product.id == productId);
    saveCart();
  }

  void clearCart() {
    cartItems.clear();
    StorageService.clearCart();
  }

  void saveCart() {
    StorageService.saveCart(cartItems.map((item) => item.toJson()).toList());
  }

  double get subtotal => cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  double get total => subtotal + deliveryFee.value - discount.value;
  int get itemCount => cartItems.fold(0, (sum, item) => sum + item.quantity);
}
