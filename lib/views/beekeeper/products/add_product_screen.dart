import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../controllers/beekeeper_controller.dart';
import '../../../controllers/auth_controller.dart';
import '../../../models/product_model.dart';
import '../../../utils/validators.dart';
import '../../../utils/constants.dart';
import '../../common/widgets/custom_text_field.dart';
import '../../common/widgets/custom_button.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final beekeeperController = Get.find<BeekeeperController>();
  final ImagePicker _picker = ImagePicker();
  
  String _selectedCategory = 'sidr';
  String _selectedWeight = '1kg';
  final List<File> _selectedImages = [];
  bool _isUploading = false;
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('add_product'.tr)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImagePicker(),
              const SizedBox(height: 16),
              CustomTextField(label: 'product_name', controller: _nameController, validator: (v) => Validators.validateRequired(v, 'product_name')),
              const SizedBox(height: 16),
              CustomTextField(label: 'description', controller: _descriptionController, maxLines: 3),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(labelText: 'honey_type'.tr),
                items: [
                  DropdownMenuItem(value: 'sidr', child: Text('Sidr')),
                  DropdownMenuItem(value: 'acacia', child: Text('Acacia')),
                  DropdownMenuItem(value: 'wildflower', child: Text('Wildflower')),
                  DropdownMenuItem(value: 'mixed', child: Text('Mixed')),
                  DropdownMenuItem(value: 'other', child: Text('Other')),
                ],
                onChanged: (value) => setState(() => _selectedCategory = value!),
              ),
              const SizedBox(height: 16),
              CustomTextField(label: 'price', controller: _priceController, validator: Validators.validatePrice, keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              CustomTextField(label: 'stock', controller: _stockController, validator: Validators.validateStock, keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedWeight,
                decoration: InputDecoration(labelText: 'weight'.tr),
                items: ['250g', '500g', '1kg', '2kg'].map((w) => DropdownMenuItem(value: w, child: Text(w))).toList(),
                onChanged: (value) => setState(() => _selectedWeight = value!),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'save_product',
                onPressed: _isSaving ? null : () => _saveProduct(),
                isLoading: _isSaving,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('product_images'.tr, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ..._selectedImages.map((file) => _buildImageCard(file)),
              if (_selectedImages.length < 5) _buildAddImageButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageCard(File file) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(image: FileImage(file), fit: BoxFit.cover),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 4,
            right: 4,
            child: CircleAvatar(
              radius: 12,
              backgroundColor: Colors.red,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.close, size: 16, color: Colors.white),
                onPressed: () => setState(() => _selectedImages.remove(file)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddImageButton() {
    return InkWell(
      onTap: _isUploading ? null : _pickImage,
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.primary, width: 2, style: BorderStyle.solid),
        ),
        child: _isUploading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate, size: 40, color: AppColors.primary),
                  const SizedBox(height: 4),
                  Text('add_image'.tr, style: TextStyle(color: AppColors.primary)),
                ],
              ),
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImages.add(File(image.path));
        });
        Get.snackbar('success'.tr, 'image_added'.tr, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('error'.tr, '${'failed_to_add_image'.tr}: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> _saveProduct() async {
    if (_selectedImages.isEmpty) {
      Get.snackbar('error'.tr, 'please_add_image'.tr);
      return;
    }
    if (_formKey.currentState!.validate()) {
      final authController = Get.find<AuthController>();
      final currentUser = authController.currentUser.value;
      
      if (currentUser == null) {
        Get.snackbar('error'.tr, 'user_not_logged_in'.tr);
        return;
      }
      
      setState(() => _isSaving = true);
      
      try {
        // Upload images to Supabase
        final List<String> uploadedUrls = [];
        for (int i = 0; i < _selectedImages.length; i++) {
          final file = _selectedImages[i];
          final fileName = '${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
          final url = await beekeeperController.uploadProductImage(file.path, fileName);
          uploadedUrls.add(url);
        }
        
        final product = ProductModel(
          id: '', // Will be generated by database
          name: _nameController.text,
          description: _descriptionController.text,
          price: double.parse(_priceController.text),
          category: _selectedCategory,
          images: uploadedUrls,
          beekeeperId: currentUser.id,
          beekeeperName: currentUser.businessName ?? currentUser.name,
          rating: 0,
          reviewCount: 0,
          stock: int.parse(_stockController.text),
          weight: _selectedWeight,
          harvestDate: DateTime.now(),
        );
        
        await beekeeperController.addProduct(product);
      } catch (e) {
        Get.snackbar('error'.tr, '${'failed_to_save_product'.tr}: $e');
      } finally {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }
}
