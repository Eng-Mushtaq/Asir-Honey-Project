class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const accountType = '/account-type';
  static const login = '/login';
  static const register = '/register';
  static const createAdmin = '/create-admin'; // TEMPORARY
  
  // Consumer Routes
  static const consumerHome = '/consumer/home';
  static const categories = '/consumer/categories';
  static const productList = '/consumer/products';
  static const productDetail = '/consumer/product-detail';
  static const cart = '/consumer/cart';
  static const checkout = '/consumer/checkout';
  static const orders = '/consumer/orders';
  static const orderDetail = '/consumer/order-detail';
  static const consumerProfile = '/consumer/profile';
  
  // Beekeeper Routes
  static const beekeeperDashboard = '/beekeeper/dashboard';
  static const manageProducts = '/beekeeper/products';
  static const addProduct = '/beekeeper/add-product';
  static const editProduct = '/beekeeper/edit-product';
  static const beekeeperOrders = '/beekeeper/orders';
  static const beekeeperOrderDetail = '/beekeeper/order-detail';
  static const beekeeperProfile = '/beekeeper/profile';
  
  // Admin Routes
  static const adminDashboard = '/admin/dashboard';
  static const adminUsers = '/admin/users';
  static const adminProducts = '/admin/products';
  static const adminOrders = '/admin/orders';
  static const adminBeekeepers = '/admin/beekeepers';
}
