# 📁 Project Structure - Asir Honey Marketplace

## Complete Directory Tree

```
asal_asir/
│
├── android/                          # Android native code
├── ios/                              # iOS native code
├── web/                              # Web platform files
├── windows/                          # Windows platform files
├── linux/                            # Linux platform files
├── macos/                            # macOS platform files
│
├── assets/                           # App assets
│   ├── images/                       # Image files
│   ├── icons/                        # Icon files
│   └── animations/                   # Lottie animations
│
├── lib/                              # Main application code
│   │
│   ├── app/                          # App-level configuration
│   │   ├── routes/
│   │   │   ├── app_routes.dart       # Route constants
│   │   │   └── app_pages.dart        # Route configuration
│   │   ├── translations/
│   │   │   ├── en_US.dart            # English translations
│   │   │   ├── ar_SA.dart            # Arabic translations
│   │   │   └── app_translations.dart # Translation setup
│   │   └── themes/
│   │       └── app_theme.dart        # App theme configuration
│   │
│   ├── models/                       # Data models
│   │   ├── user_model.dart           # User data structure
│   │   ├── product_model.dart        # Product data structure
│   │   ├── cart_item_model.dart      # Cart item structure
│   │   ├── order_model.dart          # Order data structure
│   │   └── review_model.dart         # Review data structure
│   │
│   ├── controllers/                  # Business logic (GetX)
│   │   ├── auth_controller.dart      # Authentication logic
│   │   ├── language_controller.dart  # Language switching
│   │   ├── product_controller.dart   # Product management
│   │   ├── cart_controller.dart      # Cart operations
│   │   ├── order_controller.dart     # Order management
│   │   └── beekeeper_controller.dart # Beekeeper operations
│   │
│   ├── views/                        # UI screens
│   │   │
│   │   ├── splash/
│   │   │   └── splash_screen.dart    # App splash screen
│   │   │
│   │   ├── onboarding/
│   │   │   └── onboarding_screen.dart # Onboarding slides
│   │   │
│   │   ├── auth/
│   │   │   ├── account_type_screen.dart # Account selection
│   │   │   ├── login_screen.dart        # Login form
│   │   │   ├── register_screen.dart     # Registration form
│   │   │   └── widgets/                 # Auth-specific widgets
│   │   │
│   │   ├── consumer/                 # Consumer-specific screens
│   │   │   ├── home/
│   │   │   │   ├── home_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── banner_carousel.dart
│   │   │   │       └── category_chip.dart
│   │   │   ├── products/
│   │   │   │   ├── product_list_screen.dart
│   │   │   │   ├── product_detail_screen.dart
│   │   │   │   └── widgets/
│   │   │   ├── cart/
│   │   │   │   ├── cart_screen.dart
│   │   │   │   └── widgets/
│   │   │   ├── checkout/
│   │   │   │   └── widgets/
│   │   │   ├── orders/
│   │   │   │   ├── orders_screen.dart
│   │   │   │   └── widgets/
│   │   │   └── profile/
│   │   │       ├── profile_screen.dart
│   │   │       └── widgets/
│   │   │
│   │   ├── beekeeper/                # Beekeeper-specific screens
│   │   │   ├── dashboard/
│   │   │   │   ├── dashboard_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       └── stat_card.dart
│   │   │   ├── products/
│   │   │   │   ├── manage_products_screen.dart
│   │   │   │   ├── add_product_screen.dart
│   │   │   │   └── widgets/
│   │   │   ├── orders/
│   │   │   │   ├── beekeeper_orders_screen.dart
│   │   │   │   └── widgets/
│   │   │   └── profile/
│   │   │       ├── beekeeper_profile_screen.dart
│   │   │       └── widgets/
│   │   │
│   │   └── common/                   # Shared widgets
│   │       └── widgets/
│   │           ├── custom_button.dart
│   │           ├── custom_text_field.dart
│   │           ├── product_card.dart
│   │           ├── loading_widget.dart
│   │           └── empty_state_widget.dart
│   │
│   ├── utils/                        # Utility functions
│   │   ├── constants.dart            # App constants
│   │   ├── validators.dart           # Form validators
│   │   └── helpers.dart              # Helper functions
│   │
│   ├── services/                     # Services
│   │   └── storage_service.dart      # Local storage
│   │
│   └── main.dart                     # App entry point
│
├── test/                             # Test files
│   └── widget_test.dart
│
├── pubspec.yaml                      # Dependencies
├── pubspec.lock                      # Locked dependencies
├── analysis_options.yaml             # Linter rules
│
├── README.md                         # Project overview
├── PROJECT_DOCUMENTATION.md          # Technical docs
├── QUICK_START.md                    # Quick guide
├── FEATURES_CHECKLIST.md             # Features list
├── SUMMARY.md                        # Project summary
├── BUILD_INSTRUCTIONS.md             # Build guide
├── INSTALLATION_COMPLETE.md          # Installation summary
├── PROJECT_STRUCTURE.md              # This file
└── run_app.bat                       # Windows launcher
```

## 📊 File Count by Category

### Core Application Files
- **Models**: 5 files
- **Controllers**: 6 files
- **Screens**: 25+ files
- **Widgets**: 15+ files
- **Utilities**: 3 files
- **Services**: 1 file
- **Configuration**: 6 files

### Documentation Files
- **README.md**: Project overview
- **PROJECT_DOCUMENTATION.md**: Complete technical documentation
- **QUICK_START.md**: Quick testing guide
- **FEATURES_CHECKLIST.md**: Detailed features list
- **SUMMARY.md**: Project summary
- **BUILD_INSTRUCTIONS.md**: Build and deployment guide
- **INSTALLATION_COMPLETE.md**: Installation verification
- **PROJECT_STRUCTURE.md**: This file

### Total Files Created
- **Dart Files**: 45+
- **Documentation**: 8
- **Configuration**: 2
- **Total**: 55+ files

## 🎯 Key Directories Explained

### `/lib/app/`
Contains app-level configuration including routes, themes, and translations. This is where global app settings are defined.

### `/lib/models/`
Data models representing the structure of data used throughout the app. Each model has `fromJson` and `toJson` methods for serialization.

### `/lib/controllers/`
Business logic layer using GetX state management. Controllers handle data manipulation, API calls (future), and state updates.

### `/lib/views/`
UI layer containing all screens and widgets. Organized by feature (auth, consumer, beekeeper) for better maintainability.

### `/lib/views/common/widgets/`
Reusable widgets used across multiple screens. These are the building blocks of the UI.

### `/lib/utils/`
Utility functions, constants, validators, and helpers used throughout the app.

### `/lib/services/`
Services for external operations like storage, API calls (future), etc.

## 🔄 Data Flow (MVC Pattern)

```
View (UI)
    ↓
Controller (Business Logic)
    ↓
Model (Data Structure)
    ↓
Service (Data Source)
```

### Example Flow: Adding to Cart

1. **View**: User taps "Add to Cart" button
2. **Controller**: `CartController.addToCart(product)`
3. **Model**: Creates `CartItemModel` instance
4. **Service**: `StorageService.saveCart()`
5. **View**: UI updates via `Obx()` reactive widget

## 📱 Screen Organization

### Authentication Flow
```
Splash → Onboarding → Account Type → Register/Login
```

### Consumer Flow
```
Home → Products → Product Detail → Cart → Checkout → Orders
```

### Beekeeper Flow
```
Dashboard → Manage Products → Add/Edit Product
Dashboard → Orders → Order Details
```

## 🎨 Widget Hierarchy

### Common Widgets (Reusable)
- CustomButton
- CustomTextField
- ProductCard
- LoadingWidget
- EmptyStateWidget

### Screen-Specific Widgets
- BannerCarousel (Home)
- CategoryChip (Home)
- StatCard (Dashboard)

## 🔧 Configuration Files

### `pubspec.yaml`
- Dependencies
- Assets
- Fonts
- App metadata

### `analysis_options.yaml`
- Linter rules
- Code style enforcement

### `main.dart`
- App initialization
- GetX setup
- Theme configuration
- Route configuration

## 📦 Dependencies Organization

### State Management
- get (GetX)
- get_storage

### UI Components
- google_fonts
- flutter_rating_bar
- shimmer
- smooth_page_indicator

### Utilities
- email_validator
- intl
- image_picker

### Media
- cached_network_image
- flutter_svg
- lottie

## 🌍 Localization Structure

```
app/translations/
├── en_US.dart          # English translations
├── ar_SA.dart          # Arabic translations
└── app_translations.dart # Translation setup
```

Each translation file contains 100+ key-value pairs for complete app localization.

## 🎯 Best Practices Followed

1. **Separation of Concerns**: MVC pattern
2. **Reusability**: Common widgets
3. **Modularity**: Feature-based organization
4. **Scalability**: Easy to add new features
5. **Maintainability**: Clear structure
6. **Documentation**: Comprehensive docs
7. **Naming**: Consistent conventions
8. **Organization**: Logical grouping

## 📈 Growth Path

### Current Structure (Phase 1)
- Local storage
- Dummy data
- Frontend only

### Future Structure (Phase 2)
```
lib/
├── api/                # API integration
├── repositories/       # Data repositories
├── providers/          # Data providers
└── middleware/         # Auth middleware
```

## 🔍 Finding Files

### Need to modify...

**Colors/Theme?**
→ `lib/utils/constants.dart`
→ `lib/app/themes/app_theme.dart`

**Translations?**
→ `lib/app/translations/en_US.dart`
→ `lib/app/translations/ar_SA.dart`

**Routes?**
→ `lib/app/routes/app_routes.dart`
→ `lib/app/routes/app_pages.dart`

**Business Logic?**
→ `lib/controllers/`

**UI Screens?**
→ `lib/views/`

**Data Models?**
→ `lib/models/`

**Reusable Widgets?**
→ `lib/views/common/widgets/`

## 📝 Notes

- All screens follow consistent naming: `*_screen.dart`
- All controllers follow pattern: `*_controller.dart`
- All models follow pattern: `*_model.dart`
- Widgets are organized by feature
- Common widgets are in `views/common/widgets/`
- Each major feature has its own widgets folder

---

**This structure supports:**
- ✅ Easy navigation
- ✅ Quick file location
- ✅ Scalable growth
- ✅ Team collaboration
- ✅ Code maintenance
- ✅ Feature additions

---

<div align="center">
  <p><strong>Well-Organized Structure for a Professional App</strong></p>
</div>
