import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/validators.dart';
import '../../utils/constants.dart';
import '../../app/routes/app_routes.dart';
import '../common/widgets/custom_text_field.dart';
import '../common/widgets/custom_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _businessLicenseController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _authController = Get.find<AuthController>();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  late String _userType;

  @override
  void initState() {
    super.initState();
    _userType = Get.arguments ?? 'consumer';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('register'.tr)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                  ),
                  child: Row(
                    children: [
                      Icon(_userType == 'consumer' ? Icons.shopping_bag : Icons.store, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(_userType.tr, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.primary)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                CustomTextField(label: 'full_name', controller: _nameController, validator: (v) => Validators.validateRequired(v, 'full_name'), prefixIcon: const Icon(Icons.person)),
                const SizedBox(height: 16),
                CustomTextField(label: 'email', controller: _emailController, validator: Validators.validateEmail, keyboardType: TextInputType.emailAddress, prefixIcon: const Icon(Icons.email)),
                const SizedBox(height: 16),
                CustomTextField(label: 'phone', controller: _phoneController, validator: Validators.validatePhone, keyboardType: TextInputType.phone, prefixIcon: const Icon(Icons.phone)),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'password',
                  controller: _passwordController,
                  validator: Validators.validatePassword,
                  obscureText: _obscurePassword,
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off), onPressed: () => setState(() => _obscurePassword = !_obscurePassword)),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'confirm_password',
                  controller: _confirmPasswordController,
                  validator: (v) => v != _passwordController.text ? 'passwords_not_match'.tr : null,
                  obscureText: _obscureConfirmPassword,
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off), onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword)),
                ),
                if (_userType == 'beekeeper') ...[
                  const SizedBox(height: 16),
                  CustomTextField(label: 'business_name', controller: _businessNameController, validator: (v) => Validators.validateRequired(v, 'business_name'), prefixIcon: const Icon(Icons.business)),
                  const SizedBox(height: 16),
                  CustomTextField(label: 'business_license', controller: _businessLicenseController, validator: (v) => Validators.validateRequired(v, 'business_license'), prefixIcon: const Icon(Icons.badge)),
                  const SizedBox(height: 16),
                  CustomTextField(label: 'location', controller: _locationController, validator: (v) => Validators.validateRequired(v, 'location'), prefixIcon: const Icon(Icons.location_on)),
                  const SizedBox(height: 16),
                  CustomTextField(label: 'description', controller: _descriptionController, maxLines: 3, prefixIcon: const Icon(Icons.description)),
                ],
                const SizedBox(height: 24),
                Obx(() => CustomButton(text: 'register', onPressed: _register, isLoading: _authController.isLoading.value)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('already_have_account'.tr),
                    TextButton(onPressed: () => Get.offNamed(AppRoutes.login), child: Text('login'.tr)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      final userData = {
        'email': _emailController.text,
        'name': _nameController.text,
        'phone': _phoneController.text,
        'user_type': _userType,
        if (_userType == 'beekeeper') ...{
          'business_name': _businessNameController.text,
          'business_license': _businessLicenseController.text,
          'location': _locationController.text,
          'description': _descriptionController.text,
        },
      };
      _authController.register(
        email: _emailController.text,
        password: _passwordController.text,
        userData: userData,
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _businessNameController.dispose();
    _businessLicenseController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
