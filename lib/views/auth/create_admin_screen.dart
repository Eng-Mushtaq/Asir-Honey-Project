import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/validators.dart';
import '../../utils/constants.dart';
import '../common/widgets/custom_text_field.dart';
import '../common/widgets/custom_button.dart';

class CreateAdminScreen extends StatefulWidget {
  const CreateAdminScreen({super.key});

  @override
  State<CreateAdminScreen> createState() => _CreateAdminScreenState();
}

class _CreateAdminScreenState extends State<CreateAdminScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authController = Get.find<AuthController>();
  
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Admin User')),
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
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.admin_panel_settings, color: Colors.red.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'TEMPORARY: Create Admin User\nDelete this screen after use',
                          style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: 'full_name',
                  controller: _nameController,
                  validator: (v) => Validators.validateRequired(v, 'full_name'),
                  prefixIcon: const Icon(Icons.person),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'email',
                  controller: _emailController,
                  validator: Validators.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'phone',
                  controller: _phoneController,
                  validator: Validators.validatePhone,
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone),
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
                const SizedBox(height: 24),
                Obx(() => CustomButton(
                  text: 'Create Admin',
                  onPressed: _createAdmin,
                  isLoading: _authController.isLoading.value,
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _createAdmin() {
    if (_formKey.currentState!.validate()) {
      final userData = {
        'email': _emailController.text,
        'name': _nameController.text,
        'phone': _phoneController.text,
        'user_type': 'admin',
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
    super.dispose();
  }
}
