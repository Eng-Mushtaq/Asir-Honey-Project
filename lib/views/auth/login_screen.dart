import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/language_controller.dart';
import '../../utils/validators.dart';
import '../../utils/constants.dart';
import '../../app/routes/app_routes.dart';
import '../common/widgets/custom_text_field.dart';
import '../common/widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authController = Get.find<AuthController>();
  final _languageController = Get.find<LanguageController>();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('login'.tr),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (value) => _languageController.changeLanguage(value),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'en', child: Text('English')),
              const PopupMenuItem(value: 'ar', child: Text('العربية')),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.hive, size: 80, color: AppColors.primary),
                const SizedBox(height: 16),
                Text('welcome'.tr, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
                const SizedBox(height: 32),
                CustomTextField(
                  label: 'email',
                  controller: _emailController,
                  validator: Validators.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'password',
                  controller: _passwordController,
                  validator: Validators.validatePassword,
                  obscureText: _obscurePassword,
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(value: _rememberMe, onChanged: (value) => setState(() => _rememberMe = value!)),
                    Text('remember_me'.tr),
                    const Spacer(),
                    TextButton(onPressed: () {}, child: Text('forgot_password'.tr)),
                  ],
                ),
                const SizedBox(height: 24),
                Obx(() => CustomButton(
                      text: 'login',
                      onPressed: _login,
                      isLoading: _authController.isLoading.value,
                    )),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('dont_have_account'.tr),
                    TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.accountType),
                      child: Text('register'.tr),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Get.toNamed(AppRoutes.createAdmin),
                  child: const Text('Create Admin (TEMP)', style: TextStyle(fontSize: 10)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      _authController.login(_emailController.text, _passwordController.text);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
