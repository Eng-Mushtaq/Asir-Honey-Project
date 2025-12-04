import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/translations/app_translations.dart';
import 'app/themes/app_theme.dart';
import 'controllers/auth_controller.dart';
import 'controllers/language_controller.dart';
import 'controllers/theme_controller.dart';
import 'controllers/order_controller.dart';
import 'services/storage_service.dart';
import 'services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Global error handler
  FlutterError.onError = (FlutterErrorDetails details) {
    print('\n🔴 ═══════════════════════════════════════════════════════');
    print('🔴 FLUTTER ERROR CAUGHT:');
    print('🔴 ═══════════════════════════════════════════════════════');
    print('❌ Error: ${details.exception}');
    print('📍 Stack Trace:\n${details.stack}');
    print('🔴 ═══════════════════════════════════════════════════════\n');
    FlutterError.presentError(details);
  };

  // Initialize local storage
  await StorageService.init();

  // Initialize Supabase (Phase 2)
  try {
    await SupabaseService.initialize();
    print('✅ Supabase initialized successfully');
  } catch (e, stackTrace) {
    print('\n⚠️ ═══════════════════════════════════════════════════════');
    print('⚠️ SUPABASE INITIALIZATION ERROR:');
    print('⚠️ ═══════════════════════════════════════════════════════');
    print('❌ Error: $e');
    print('📍 Stack Trace:\n$stackTrace');
    print('⚠️ ═══════════════════════════════════════════════════════\n');
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const AsalAsirApp());
}

class AsalAsirApp extends StatelessWidget {
  const AsalAsirApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageController = Get.put(LanguageController());
    final themeController = Get.put(ThemeController());
    Get.put(AuthController());
    Get.put(OrderController());
    return Obx(
      () => GetMaterialApp(
        title: 'Asir Honey',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.getTheme(
          languageController.currentLanguage.value,
          themeController.currentTheme.value,
        ),
        translations: AppTranslations(),
        locale: languageController.currentLanguage.value == 'ar'
            ? const Locale('ar', 'SA')
            : const Locale('en', 'US'),
        fallbackLocale: const Locale('en', 'US'),
        initialRoute: AppRoutes.splash,
        getPages: AppPages.routes,
      ),
    );
  }
}
