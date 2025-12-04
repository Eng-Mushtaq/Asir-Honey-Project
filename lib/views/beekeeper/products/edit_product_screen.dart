import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../controllers/beekeeper_controller.dart';
import '../../../models/product_model.dart';
import '../../../utils/validators.dart';
import '../../../utils/constants.dart';
import '../../common/widgets/custom_text_field.dart';
import '../../common/widgets/custom_button.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final beekeeperController = Get.find<BeekeeperController>();
  final ImagePicker _picker = ImagePicker();
  
  late ProductModel product;
  late String _selectedCategory;
  late String _selectedWeight;
  final List<String> _existingImageUrls = [];
  final List<File> _newImages = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    product = Get.arguments as ProductModel;
    
    _nameController.text = product.name;
    _descriptionController.text = product.description;
    _priceController.text = product.price.toString();
    _stockController.text = product.stock.toString();
    _selectedCategory = product.category;
    _selectedWeight = product.weight;
    _existingImageUrls.addAll(product.images);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('edit_product'.tr)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImagePicker(),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'product_name',
                controller: _nameController,
                validator: (v) => Validators.validateRequired(v, 'product_name'),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'description',
                controller: _descriptionController,
                maxLines: 3,
              ),
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
              CustomTextField(
                label: 'price',
                controller: _priceController,
                validator: Validators.validatePrice,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'stock',
                controller: _stockController,
                validator: Validators.validateStock,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedWeight,
                decoration: InputDecoration(labelText: 'weight'.tr),
                items: ['250g', '500g', '1kg', '2kg']
                    .map((w) => DropdownMenuItem(value: w, child: Text(w)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedWeight = value!),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'update_product',
                onPressed: _isSaving ? null : () => _updateProduct(),
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
              ..._existingImageUrls.map((url) => _buildExistingImageCard(url)),
              ..._newImages.map((file) => _buildNewImageCard(file)),
              if (_existingImageUrls.length + _newImages.length < 5)
                _buildAddImageButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExistingImageCard(String url) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
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
                onPressed: () => setState(() => _existingImageUrls.remove(url)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewImageCard(File file) {
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
                onPressed: () => setState(() => _newImages.remove(file)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddImageButton() {
    return InkWell(
      onTap: _pickImage,
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.primary, width: 2),
        ),
        child: Column(
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
        setState(() => _newImages.add(File(image.path)));
        Get.snackbar('success'.tr, 'image_added'.tr, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('error'.tr, '${'failed_to_add_image'.tr}: $e');
    }
  }

  Future<void> _updateProduct() async {
    if (_existingImageUrls.isEmpty && _newImages.isEmpty) {
      Get.snackbar('error'.tr, 'please_add_image'.tr);
      return;
    }
    
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      
      try {
        // Upload new images
        final List<String> newUploadedUrls = [];
        for (int i = 0; i < _newImages.length; i++) {
          final file = _newImages[i];
          final fileName = '${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
          final url = await beekeeperController.uploadProductImage(file.path, fileName);
          newUploadedUrls.add(url);
        }
        
        // Combine existing and new image URLs
        final allImageUrls = [..._existingImageUrls, ...newUploadedUrls];
        
        final updatedProduct = ProductModel(
          id: product.id,
          name: _nameController.text,
          description: _descriptionController.text,
          price: double.parse(_priceController.text),
          category: _selectedCategory,
          images: allImageUrls,
          beekeeperId: product.beekeeperId,
          beekeeperName: product.beekeeperName,
          rating: product.rating,
          reviewCount: product.reviewCount,
          stock: int.parse(_stockController.text),
          weight: _selectedWeight,
          harvestDate: product.harvestDate,
          isActive: product.isActive,
          isFeatured: product.isFeatured,
        );
        
        await beekeeperController.updateProduct(updatedProduct);
      } catch (e) {
        Get.snackbar('error'.tr, '${'failed_to_update_product'.tr}: $e');
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
