import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/storage_service.dart';

class LanguageController extends GetxController {
  final RxString currentLanguage = 'en'.obs;

  @override
  void onInit() {
    super.onInit();
    currentLanguage.value = StorageService.getLanguage();
    updateLocale(currentLanguage.value);
  }

  void changeLanguage(String languageCode) {
    currentLanguage.value = languageCode;
    StorageService.saveLanguage(languageCode);
    updateLocale(languageCode);
  }

  void updateLocale(String languageCode) {
    final locale = languageCode == 'ar' ? const Locale('ar', 'SA') : const Locale('en', 'US');
    Get.updateLocale(locale);
  }

  bool get isArabic => currentLanguage.value == 'ar';
}
