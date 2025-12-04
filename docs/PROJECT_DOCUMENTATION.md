# Asir Honey Marketplace - Flutter Application

## 🍯 Project Overview
A modern Flutter e-commerce application connecting beekeepers in the Asir region with consumers, enabling direct sales of authentic Asir honey. This is a graduation project from Computer Science at Bisha University.

## ✨ Features Implemented (Phase 1)

### Authentication & Onboarding
- ✅ Splash screen with animation
- ✅ 3-slide onboarding experience
- ✅ Account type selection (Consumer/Beekeeper)
- ✅ Login screen with validation
- ✅ Registration with conditional fields for beekeepers
- ✅ Language switcher (English/Arabic)

### Consumer Features
- ✅ Home screen with banner carousel
- ✅ Category chips for honey types
- ✅ Featured products grid
- ✅ Product list with grid view
- ✅ Product detail with image carousel
- ✅ Shopping cart with quantity management
- ✅ Checkout flow
- ✅ Orders screen with tabs (Active/Completed/Cancelled)
- ✅ Profile screen with settings
- ✅ Bottom navigation

### Beekeeper Features
- ✅ Dashboard with statistics cards
- ✅ Quick actions for product management
- ✅ Manage products screen
- ✅ Add product form with validation
- ✅ Orders management with tabs
- ✅ Profile screen
- ✅ Bottom navigation

### Technical Features
- ✅ GetX state management
- ✅ MVC architecture
- ✅ Bilingual support (EN/AR) with RTL
- ✅ Local storage with GetStorage
- ✅ Form validation
- ✅ Custom reusable widgets
- ✅ Material Design 3 theme
- ✅ Responsive design
- ✅ Smooth animations

## 🏗️ Architecture

### MVC Pattern
```
Models (Data Layer)
├── user_model.dart
├── product_model.dart
├── cart_item_model.dart
├── order_model.dart
└── review_model.dart

Controllers (Business Logic)
├── auth_controller.dart
├── language_controller.dart
├── product_controller.dart
├── cart_controller.dart
├── order_controller.dart
└── beekeeper_controller.dart

Views (UI Layer)
├── splash/
├── onboarding/
├── auth/
├── consumer/
├── beekeeper/
└── common/widgets/
```

## 🎨 Design System

### Color Palette
- **Primary**: #F4A460 (Honey Gold)
- **Primary Dark**: #D2691E (Deep Honey)
- **Secondary**: #8B4513 (Natural Wood)
- **Accent**: #228B22 (Forest Green)
- **Success**: #4CAF50
- **Error**: #F44336

### Typography
- **Arabic**: Cairo (Google Fonts)
- **English**: Poppins (Google Fonts)

## 📦 Dependencies

```yaml
dependencies:
  get: ^4.6.6                      # State management
  get_storage: ^2.1.1              # Local storage
  google_fonts: ^6.1.0             # Typography
  flutter_svg: ^2.0.9              # SVG support
  cached_network_image: ^3.3.0     # Image caching
  shimmer: ^3.0.0                  # Loading effects
  flutter_rating_bar: ^4.0.1       # Rating display
  smooth_page_indicator: ^1.1.0    # Page indicators
  email_validator: ^2.1.17         # Email validation
  image_picker: ^1.0.5             # Image selection
  intl: ^0.18.1                    # Internationalization
  lottie: ^2.7.0                   # Animations
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code
- Android Emulator or iOS Simulator

### Installation

1. **Clone the repository**
```bash
cd d:\projects\asal_asir
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

### Build for Production

**Android APK**
```bash
flutter build apk --release
```

**iOS**
```bash
flutter build ios --release
```

## 📱 App Navigation Flow

### Consumer Flow
```
Splash → Onboarding → Account Type → Register → Home
Home → Products → Product Detail → Cart → Checkout → Orders
```

### Beekeeper Flow
```
Splash → Onboarding → Account Type → Register → Dashboard
Dashboard → Manage Products → Add/Edit Product
Dashboard → Orders → Order Details
```

## 🔐 Authentication

Currently using dummy authentication for Phase 1:
- Any email/password combination will work
- User data is stored locally using GetStorage
- Session persists across app restarts

## 🌍 Localization

### Supported Languages
- English (en_US)
- Arabic (ar_SA) with full RTL support

### Adding New Translations
1. Add keys to `lib/app/translations/en_US.dart`
2. Add Arabic translations to `lib/app/translations/ar_SA.dart`
3. Use in code: `'key'.tr`

## 🎯 Key Features Explained

### State Management (GetX)
```dart
// Controller
final RxList<Product> products = <Product>[].obs;

// View
Obx(() => Text('${controller.products.length}'))
```

### Navigation
```dart
Get.toNamed(AppRoutes.productDetail, arguments: product);
```

### Form Validation
```dart
CustomTextField(
  label: 'email',
  validator: Validators.validateEmail,
)
```

### Local Storage
```dart
StorageService.saveUser(userData);
final user = StorageService.getUser();
```

## 🧪 Testing

### Manual Testing Checklist
- [ ] Registration flow (Consumer & Beekeeper)
- [ ] Login flow
- [ ] Language switching (EN ↔ AR)
- [ ] Add products to cart
- [ ] Update cart quantities
- [ ] Place order
- [ ] View orders
- [ ] Add product (Beekeeper)
- [ ] Form validations
- [ ] Navigation flows

## 📊 Dummy Data

The app includes dummy data for:
- 3 sample products (Sidr, Samar, Talah honey)
- Placeholder images
- Sample beekeepers
- Dashboard statistics

## 🔮 Phase 2 Roadmap

### Backend Integration (Supabase)
- [ ] User authentication with Supabase Auth
- [ ] Product CRUD operations
- [ ] Order management
- [ ] Real-time updates
- [ ] Image upload to Supabase Storage
- [ ] Push notifications

### Additional Features
- [ ] Payment gateway integration
- [ ] Order tracking
- [ ] Reviews and ratings
- [ ] Favorites/Wishlist
- [ ] Search functionality
- [ ] Advanced filters
- [ ] Chat between users
- [ ] Analytics dashboard

## 🐛 Known Issues

1. Product images use placeholder URLs
2. No actual payment processing
3. Orders are stored locally only
4. No real-time updates

## 📝 Code Quality

### Best Practices Followed
- ✅ Const constructors where possible
- ✅ Meaningful variable names
- ✅ Extracted reusable widgets
- ✅ Proper error handling
- ✅ Null safety enabled
- ✅ Organized imports
- ✅ Comments for complex logic

## 🎓 Academic Context

**University**: Bisha University  
**Department**: Computer Science  
**Project Type**: Graduation Project  
**Focus**: Mobile Application Development, E-commerce, Local Business Support

## 👥 User Roles

### Consumer
- Browse honey products
- Add to cart and checkout
- Track orders
- Rate and review products
- Manage profile

### Beekeeper
- Manage product inventory
- Process orders
- View sales statistics
- Update business profile
- Communicate with customers

## 🔧 Troubleshooting

### Common Issues

**Issue**: Dependencies not installing
```bash
flutter clean
flutter pub get
```

**Issue**: Build errors
```bash
flutter clean
flutter pub get
flutter run
```

**Issue**: Language not switching
- Check that GetStorage is initialized in main.dart
- Verify translations exist in both language files

## 📄 License

This project is created for academic purposes as part of a graduation project at Bisha University.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- GetX package for state management
- Google Fonts for typography
- Asir region beekeepers for inspiration

## 📞 Support

For questions or issues related to this graduation project, please contact the development team through the university.

---

**Built with ❤️ for Asir Honey Marketplace**  
**Version**: 1.0.0 (Phase 1)  
**Last Updated**: 2024
