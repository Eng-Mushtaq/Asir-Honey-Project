# 🔨 Build Instructions - Asir Honey Marketplace

## Prerequisites

### Required Software
- **Flutter SDK**: 3.8.1 or higher
- **Dart SDK**: Included with Flutter
- **Android Studio**: Latest version (for Android builds)
- **Xcode**: Latest version (for iOS builds - macOS only)
- **VS Code** or **Android Studio**: As IDE

### Verify Installation

```bash
flutter doctor
```

Expected output should show:
- ✅ Flutter (Channel stable, 3.8.1 or higher)
- ✅ Android toolchain
- ✅ Chrome (for web development)
- ✅ VS Code or Android Studio
- ✅ Connected device (optional)

## 📦 Installation Steps

### 1. Clone/Navigate to Project

```bash
cd d:\projects\asal_asir
```

### 2. Install Dependencies

```bash
flutter pub get
```

This will install all packages listed in `pubspec.yaml`:
- get
- get_storage
- google_fonts
- flutter_rating_bar
- shimmer
- smooth_page_indicator
- email_validator
- image_picker
- intl
- lottie
- cached_network_image
- flutter_svg

### 3. Verify Installation

```bash
flutter pub get
flutter analyze
```

## 🏃 Running the App

### Development Mode

#### Option 1: Using Command Line

```bash
# Run on connected device/emulator
flutter run

# Run on specific device
flutter devices  # List available devices
flutter run -d <device-id>

# Run with hot reload enabled (default)
flutter run --hot
```

#### Option 2: Using VS Code
1. Open project in VS Code
2. Press `F5` or click "Run > Start Debugging"
3. Select target device from bottom bar

#### Option 3: Using Android Studio
1. Open project in Android Studio
2. Select target device from dropdown
3. Click the green "Run" button

### Debug Mode Features
- Hot reload: Press `r` in terminal
- Hot restart: Press `R` in terminal
- Quit: Press `q` in terminal

## 📱 Building for Production

### Android APK

#### Build APK (for testing)
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

#### Build App Bundle (for Play Store)
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

#### Build Split APKs (smaller size)
```bash
flutter build apk --split-per-abi --release
```
Output: Multiple APKs in `build/app/outputs/flutter-apk/`

### iOS (macOS only)

#### Build iOS App
```bash
flutter build ios --release
```

#### Build IPA (for App Store)
```bash
flutter build ipa --release
```
Output: `build/ios/ipa/`

### Web

```bash
flutter build web --release
```
Output: `build/web/`

### Windows

```bash
flutter build windows --release
```
Output: `build/windows/runner/Release/`

## 🔧 Build Configuration

### Android Configuration

#### Update App Name
Edit `android/app/src/main/AndroidManifest.xml`:
```xml
<application
    android:label="Asir Honey"
    ...>
```

#### Update Package Name
Edit `android/app/build.gradle`:
```gradle
defaultConfig {
    applicationId "com.bisha.asal_asir"
    ...
}
```

#### Update App Icon
Replace files in:
- `android/app/src/main/res/mipmap-*/ic_launcher.png`

### iOS Configuration

#### Update App Name
Edit `ios/Runner/Info.plist`:
```xml
<key>CFBundleName</key>
<string>Asir Honey</string>
```

#### Update Bundle Identifier
Edit `ios/Runner.xcodeproj/project.pbxproj`:
```
PRODUCT_BUNDLE_IDENTIFIER = com.bisha.asalAsir;
```

## 🐛 Troubleshooting

### Common Issues

#### Issue: Dependencies not installing
```bash
flutter clean
flutter pub get
```

#### Issue: Build fails
```bash
flutter clean
flutter pub get
flutter pub upgrade
flutter run
```

#### Issue: Gradle build fails (Android)
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter build apk
```

#### Issue: Pod install fails (iOS)
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter build ios
```

#### Issue: Out of memory during build
Add to `android/gradle.properties`:
```properties
org.gradle.jvmargs=-Xmx4096m
```

### Clear Cache

```bash
flutter clean
flutter pub cache repair
flutter pub get
```

## 📊 Build Optimization

### Reduce APK Size

1. **Enable ProGuard** (Android)
   Edit `android/app/build.gradle`:
   ```gradle
   buildTypes {
       release {
           minifyEnabled true
           shrinkResources true
           proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
       }
   }
   ```

2. **Split APKs by ABI**
   ```bash
   flutter build apk --split-per-abi
   ```

3. **Remove unused resources**
   ```bash
   flutter build apk --release --tree-shake-icons
   ```

### Performance Optimization

1. **Enable Dart Obfuscation**
   ```bash
   flutter build apk --obfuscate --split-debug-info=/<project-name>/<directory>
   ```

2. **Profile Mode** (for testing performance)
   ```bash
   flutter run --profile
   ```

## 🧪 Testing Builds

### Test APK on Device

1. Build APK:
   ```bash
   flutter build apk --release
   ```

2. Install on device:
   ```bash
   flutter install
   ```
   Or manually:
   ```bash
   adb install build/app/outputs/flutter-apk/app-release.apk
   ```

### Test on Multiple Devices

```bash
# List devices
flutter devices

# Install on specific device
flutter install -d <device-id>
```

## 📋 Pre-Release Checklist

Before building for production:

- [ ] Update version in `pubspec.yaml`
- [ ] Update app name and icons
- [ ] Test on multiple devices
- [ ] Test both languages (EN/AR)
- [ ] Test all user flows
- [ ] Check for console errors
- [ ] Verify all images load
- [ ] Test form validations
- [ ] Check navigation flows
- [ ] Test on different screen sizes
- [ ] Review app permissions
- [ ] Test offline functionality
- [ ] Verify local storage works

## 🚀 Deployment

### Google Play Store (Android)

1. Build app bundle:
   ```bash
   flutter build appbundle --release
   ```

2. Upload to Play Console:
   - Go to Google Play Console
   - Create new release
   - Upload `app-release.aab`
   - Fill in release details
   - Submit for review

### Apple App Store (iOS)

1. Build IPA:
   ```bash
   flutter build ipa --release
   ```

2. Upload to App Store Connect:
   - Open Xcode
   - Archive the app
   - Upload to App Store Connect
   - Submit for review

## 📝 Version Management

### Update Version

Edit `pubspec.yaml`:
```yaml
version: 1.0.0+1
```

Format: `major.minor.patch+build`
- Major: Breaking changes
- Minor: New features
- Patch: Bug fixes
- Build: Build number (increment for each release)

### Build Number

Android: `versionCode` in `android/app/build.gradle`
iOS: `CFBundleVersion` in `ios/Runner/Info.plist`

## 🔐 Signing (Production)

### Android Signing

1. Create keystore:
   ```bash
   keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
   ```

2. Create `android/key.properties`:
   ```properties
   storePassword=<password>
   keyPassword=<password>
   keyAlias=key
   storeFile=<path-to-key.jks>
   ```

3. Update `android/app/build.gradle`

### iOS Signing

Configure in Xcode:
1. Open `ios/Runner.xcworkspace`
2. Select Runner target
3. Go to "Signing & Capabilities"
4. Select your team
5. Configure provisioning profile

## 📞 Support

For build issues:
1. Check Flutter documentation
2. Run `flutter doctor`
3. Check GitHub issues
4. Consult project documentation

---

**Happy Building! 🚀**
