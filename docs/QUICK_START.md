# 🚀 Quick Start Guide - Asir Honey Marketplace

## Step 1: Install Dependencies

Open terminal in the project directory and run:

```bash
flutter pub get
```

## Step 2: Run the Application

```bash
flutter run
```

Or press **F5** in VS Code / Android Studio

## Step 3: Test the App

### First Time Launch
1. **Splash Screen** - Wait 3 seconds
2. **Onboarding** - Swipe through 3 slides or tap "Skip"
3. **Account Type** - Choose "Consumer" or "Beekeeper"

### Test Consumer Flow
1. **Register** as Consumer
   - Name: John Doe
   - Email: john@example.com
   - Phone: 0512345678
   - Password: Test@123
   - Accept terms

2. **Home Screen**
   - Browse featured products
   - Tap on a product to view details
   - Add products to cart

3. **Cart**
   - Adjust quantities
   - Proceed to checkout
   - Place order

4. **Orders**
   - View your orders
   - Check order status

### Test Beekeeper Flow
1. **Logout** from consumer account
2. **Register** as Beekeeper
   - Name: Ahmed Al-Asiri
   - Email: ahmed@example.com
   - Phone: 0512345679
   - Password: Test@123
   - Business Name: Asiri Honey Farm
   - Business License: 123456789
   - Location: Abha
   - Accept terms

3. **Dashboard**
   - View statistics
   - Tap "Add Product"

4. **Add Product**
   - Product Name: Premium Sidr Honey
   - Description: Pure honey from Asir mountains
   - Category: Sidr
   - Price: 250
   - Stock: 20
   - Weight: 1kg
   - Save

5. **Manage Products**
   - View your products
   - Edit or delete products

### Test Language Switching
- Tap the language icon in the app bar
- Select "العربية" for Arabic
- Select "English" for English
- Notice RTL layout in Arabic

## Common Test Credentials

### Consumer Account
- Email: consumer@test.com
- Password: Test@123

### Beekeeper Account
- Email: beekeeper@test.com
- Password: Test@123

## Features to Test

### ✅ Authentication
- [x] Registration (Consumer)
- [x] Registration (Beekeeper)
- [x] Login
- [x] Logout
- [x] Session persistence

### ✅ Consumer Features
- [x] Browse products
- [x] View product details
- [x] Add to cart
- [x] Update cart quantities
- [x] Remove from cart
- [x] Place order
- [x] View orders
- [x] Profile management

### ✅ Beekeeper Features
- [x] View dashboard statistics
- [x] Add new product
- [x] View products list
- [x] Delete product
- [x] View orders
- [x] Profile management

### ✅ Localization
- [x] Switch to Arabic
- [x] Switch to English
- [x] RTL layout in Arabic
- [x] All text translated

### ✅ UI/UX
- [x] Smooth animations
- [x] Loading states
- [x] Empty states
- [x] Form validation
- [x] Error messages
- [x] Success messages

## Troubleshooting

### App won't start?
```bash
flutter clean
flutter pub get
flutter run
```

### Dependencies error?
Make sure you have Flutter 3.8.1 or higher:
```bash
flutter --version
flutter upgrade
```

### Emulator issues?
- Make sure an emulator is running
- Or connect a physical device with USB debugging enabled

## Next Steps

1. ✅ Test all features
2. ✅ Try both user types (Consumer & Beekeeper)
3. ✅ Test language switching
4. ✅ Test form validations
5. ✅ Check responsive design on different screen sizes

## Need Help?

Check the full documentation in `PROJECT_DOCUMENTATION.md`

---

**Happy Testing! 🍯**
