import 'package:get_storage/get_storage.dart';

class StorageService {
  static final _box = GetStorage();

  static Future<void> init() async {
    await GetStorage.init();
  }

  static void saveUser(Map<String, dynamic> user) {
    _box.write('user', user);
  }

  static Map<String, dynamic>? getUser() {
    return _box.read('user');
  }

  static void removeUser() {
    _box.remove('user');
  }

  static void saveLanguage(String languageCode) {
    _box.write('language', languageCode);
  }

  static String getLanguage() {
    return _box.read('language') ?? 'en';
  }

  static void saveOnboardingStatus(bool completed) {
    _box.write('onboarding_completed', completed);
  }

  static bool getOnboardingStatus() {
    return _box.read('onboarding_completed') ?? false;
  }

  static void saveCart(List<Map<String, dynamic>> cart) {
    _box.write('cart', cart);
  }

  static List<Map<String, dynamic>> getCart() {
    final cart = _box.read('cart');
    if (cart == null) return [];
    return List<Map<String, dynamic>>.from(cart);
  }

  static void clearCart() {
    _box.remove('cart');
  }

  static void saveTheme(String theme) {
    _box.write('theme', theme);
  }

  static String getTheme() {
    return _box.read('theme') ?? 'honey';
  }
}
