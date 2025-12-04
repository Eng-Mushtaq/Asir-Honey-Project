import 'package:get/get.dart';
import 'app_routes.dart';
import '../../controllers/admin_controller.dart';
import '../../views/splash/splash_screen.dart';
import '../../views/onboarding/onboarding_screen.dart';
import '../../views/auth/account_type_screen.dart';
import '../../views/auth/login_screen.dart';
import '../../views/auth/register_screen.dart';
import '../../views/auth/create_admin_screen.dart';
import '../../views/consumer/home/home_screen.dart';
import '../../views/consumer/products/categories_screen.dart';
import '../../views/consumer/products/product_list_screen.dart';
import '../../views/consumer/products/product_detail_screen.dart';
import '../../views/consumer/cart/cart_screen.dart';
import '../../views/consumer/orders/orders_screen.dart';
import '../../views/consumer/profile/profile_screen.dart';
import '../../views/beekeeper/dashboard/dashboard_screen.dart';
import '../../views/beekeeper/products/manage_products_screen.dart';
import '../../views/beekeeper/products/add_product_screen.dart';
import '../../views/beekeeper/orders/beekeeper_orders_screen.dart';
import '../../views/beekeeper/profile/beekeeper_profile_screen.dart';
import '../../views/admin/dashboard/dashboard_screen.dart' as admin;
import '../../views/admin/users/users_screen.dart';
import '../../views/admin/products/products_screen.dart';
import '../../views/admin/orders/orders_screen.dart';
import '../../views/admin/beekeepers/beekeepers_screen.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
    GetPage(name: AppRoutes.onboarding, page: () => const OnboardingScreen()),
    GetPage(name: AppRoutes.accountType, page: () => const AccountTypeScreen()),
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(name: AppRoutes.register, page: () => const RegisterScreen()),
    GetPage(name: AppRoutes.createAdmin, page: () => const CreateAdminScreen()),
    
    // Consumer Routes
    GetPage(name: AppRoutes.consumerHome, page: () => const HomeScreen()),
    GetPage(name: AppRoutes.categories, page: () => const CategoriesScreen()),
    GetPage(name: AppRoutes.productList, page: () => const ProductListScreen()),
    GetPage(name: AppRoutes.productDetail, page: () => const ProductDetailScreen()),
    GetPage(name: AppRoutes.cart, page: () => const CartScreen()),
    GetPage(name: AppRoutes.orders, page: () => const OrdersScreen()),
    GetPage(name: AppRoutes.consumerProfile, page: () => const ProfileScreen()),
    
    // Beekeeper Routes
    GetPage(name: AppRoutes.beekeeperDashboard, page: () => const DashboardScreen()),
    GetPage(name: AppRoutes.manageProducts, page: () => const ManageProductsScreen()),
    GetPage(name: AppRoutes.addProduct, page: () => const AddProductScreen()),
    GetPage(name: AppRoutes.beekeeperOrders, page: () => const BeekeeperOrdersScreen()),
    GetPage(name: AppRoutes.beekeeperProfile, page: () => const BeekeeperProfileScreen()),
    
    // Admin Routes
    GetPage(
      name: AppRoutes.adminDashboard,
      page: () => const admin.AdminDashboardScreen(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<AdminController>()) {
          Get.put(AdminController());
        }
      }),
    ),
    GetPage(
      name: AppRoutes.adminUsers,
      page: () => const AdminUsersScreen(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<AdminController>()) {
          Get.put(AdminController());
        }
      }),
    ),
    GetPage(
      name: AppRoutes.adminProducts,
      page: () => const AdminProductsScreen(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<AdminController>()) {
          Get.put(AdminController());
        }
      }),
    ),
    GetPage(
      name: AppRoutes.adminOrders,
      page: () => const AdminOrdersScreen(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<AdminController>()) {
          Get.put(AdminController());
        }
      }),
    ),
    GetPage(
      name: AppRoutes.adminBeekeepers,
      page: () => const AdminBeekeepersScreen(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<AdminController>()) {
          Get.put(AdminController());
        }
      }),
    ),
  ];
}
