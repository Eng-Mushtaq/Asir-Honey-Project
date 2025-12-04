import 'package:asal_asir/controllers/admin_controller.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';
import '../services/api_service.dart';
import '../app/routes/app_routes.dart';

class AuthController extends GetxController {
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
    // Initialize AdminController if user is admin
    ever(currentUser, (user) {
      if (user?.userType == 'admin' && !Get.isRegistered<AdminController>()) {
        Get.put(AdminController());
      }
    });
  }

  void checkLoginStatus() {
    final userData = StorageService.getUser();
    if (userData != null) {
      currentUser.value = UserModel.fromJson(userData);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      print('🔐 Login attempt: $email');

      final user = await ApiService.signIn(email: email, password: password);

      if (user != null) {
        print('✅ Login successful: ${user.name}');
        currentUser.value = user;
        StorageService.saveUser(user.toJson());

        if (user.userType == 'admin') {
          Get.offAllNamed(AppRoutes.adminDashboard);
        } else if (user.userType == 'consumer') {
          Get.offAllNamed(AppRoutes.consumerHome);
        } else {
          Get.offAllNamed(AppRoutes.beekeeperDashboard);
        }
      } else {
        print('❌ Login failed: Invalid credentials');
        Get.snackbar('Error', 'Invalid email or password');
      }
    } catch (e, stackTrace) {
      print('❌ Login exception: $e');
      print('📍 Stack trace: $stackTrace');
      Get.snackbar('Error', 'Login failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required Map<String, dynamic> userData,
  }) async {
    try {
      isLoading.value = true;
      print('📝 Registration attempt: $email');
      print('📝 User data: $userData');

      final user = await ApiService.signUp(
        email: email,
        password: password,
        userData: userData,
      );

      if (user != null) {
        print('✅ Registration successful: ${user.name}');
        currentUser.value = user;
        StorageService.saveUser(user.toJson());

        if (user.userType == 'consumer') {
          Get.offAllNamed(AppRoutes.consumerHome);
        } else {
          Get.offAllNamed(AppRoutes.beekeeperDashboard);
        }

        Get.snackbar(
          'Success',
          'Account created successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e, stackTrace) {
      print('❌ Registration exception: $e');
      print('📍 Stack trace: $stackTrace');
      String errorMsg = e.toString();
      if (errorMsg.contains('already registered')) {
        errorMsg = 'Email already registered';
      } else if (errorMsg.contains('invalid')) {
        errorMsg = 'Invalid email format';
      }
      Get.snackbar('Error', errorMsg, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      print('🚪 Logout attempt');
      await ApiService.signOut();
      currentUser.value = null;
      StorageService.removeUser();
      print('✅ Logout successful');
      Get.offAllNamed(AppRoutes.login);
    } catch (e, stackTrace) {
      print('❌ Logout exception: $e');
      print('📍 Stack trace: $stackTrace');
      currentUser.value = null;
      StorageService.removeUser();
      Get.offAllNamed(AppRoutes.login);
    }
  }

  bool get isConsumer => currentUser.value?.userType == 'consumer';
  bool get isBeekeeper => currentUser.value?.userType == 'beekeeper';
  bool get isAdmin => currentUser.value?.userType == 'admin';
}
