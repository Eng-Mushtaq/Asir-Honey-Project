import 'package:email_validator/email_validator.dart';

class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'email_required';
    }
    if (!EmailValidator.validate(value)) {
      return 'email_invalid';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'phone_required';
    }
    final phoneRegex = RegExp(r'^05[0-9]{8}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'phone_invalid';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'password_required';
    }
    if (value.length < 8) {
      return 'password_min_length';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'password_uppercase';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'password_number';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'password_special';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '${fieldName}_required';
    }
    return null;
  }

  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'price_required';
    }
    final price = double.tryParse(value);
    if (price == null || price <= 0) {
      return 'price_invalid';
    }
    return null;
  }

  static String? validateStock(String? value) {
    if (value == null || value.isEmpty) {
      return 'stock_required';
    }
    final stock = int.tryParse(value);
    if (stock == null || stock < 0) {
      return 'stock_invalid';
    }
    return null;
  }
}
