import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/storage_service.dart';

class ThemeController extends GetxController {
  final RxString currentTheme = 'honey'.obs;

  @override
  void onInit() {
    super.onInit();
    currentTheme.value = StorageService.getTheme();
  }

  void changeTheme(String theme) {
    currentTheme.value = theme;
    StorageService.saveTheme(theme);
  }

  bool get isHoneyTheme => currentTheme.value == 'honey';
  bool get isForestTheme => currentTheme.value == 'forest';
  bool get isOceanTheme => currentTheme.value == 'ocean';
  bool get isAsirTheme => currentTheme.value == 'asir';
}
