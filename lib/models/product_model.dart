import 'package:get/get.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final List<String> images;
  final String beekeeperId;
  final String beekeeperName;
  final double rating;
  final int reviewCount;
  final int stock;
  final String weight;
  final DateTime harvestDate;
  final bool isActive;
  final bool isFeatured;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.images,
    required this.beekeeperId,
    this.beekeeperName = '',
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.stock,
    required this.weight,
    required this.harvestDate,
    this.isActive = true,
    this.isFeatured = false,
  });

  // Helper to extract text from JSONB
  static String _extractFromJsonb(dynamic jsonb, String defaultText) {
    if (jsonb == null) return defaultText;
    
    // If it's already a string, return it
    if (jsonb is String) return jsonb;
    
    // If it's a Map (JSONB), extract based on current locale
    if (jsonb is Map<String, dynamic>) {
      try {
        final lang = Get.locale?.languageCode ?? 'en';
        return jsonb[lang] ?? jsonb['en'] ?? jsonb['ar'] ?? defaultText;
      } catch (e) {
        // Fallback if Get.locale is not available
        return jsonb['en'] ?? jsonb['ar'] ?? defaultText;
      }
    }
    
    return defaultText;
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Handle both snake_case (from database) and camelCase (from app)
    // Extract name and description from JSONB or use as string
    final name = _extractFromJsonb(json['name'], 'Product');
    final description = _extractFromJsonb(json['description'], '');
    
    // Handle harvest_date (snake_case) or harvestDate (camelCase)
    DateTime harvestDate;
    if (json['harvest_date'] != null) {
      harvestDate = DateTime.parse(json['harvest_date'].toString());
    } else if (json['harvestDate'] != null) {
      harvestDate = json['harvestDate'] is String 
          ? DateTime.parse(json['harvestDate'])
          : json['harvestDate'];
    } else {
      harvestDate = DateTime.now();
    }
    
    // Handle images (array)
    List<String> imagesList = [];
    if (json['images'] != null) {
      if (json['images'] is List) {
        imagesList = List<String>.from(json['images']);
      } else if (json['images'] is String) {
        imagesList = [json['images']];
      }
    }
    
    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: name,
      description: description,
      price: (json['price'] ?? 0.0).toDouble(),
      category: json['category'] ?? 'other',
      images: imagesList.isNotEmpty ? imagesList : [''],
      beekeeperId: json['beekeeper_id']?.toString() ?? json['beekeeperId']?.toString() ?? '',
      beekeeperName: json['beekeeper_name'] ?? json['beekeeperName'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['review_count'] ?? json['reviewCount'] ?? 0,
      stock: json['stock'] ?? 0,
      weight: json['weight'] ?? '1kg',
      harvestDate: harvestDate,
      isActive: json['is_active'] ?? json['isActive'] ?? true,
      isFeatured: json['is_featured'] ?? json['isFeatured'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    // Convert to snake_case for database
    final json = {
      'name': {
        'en': name,
        'ar': name, // In real app, should have separate translations
      },
      'description': {
        'en': description,
        'ar': description, // In real app, should have separate translations
      },
      'price': price,
      'category': category,
      'images': images,
      'beekeeper_id': beekeeperId,
      'rating': rating,
      'review_count': reviewCount,
      'stock': stock,
      'weight': weight,
      'harvest_date': harvestDate.toIso8601String().split('T')[0], // DATE format
      'is_active': isActive,
      'is_featured': isFeatured,
    };
    // Only include id if it's a valid UUID (for updates)
    if (id.isNotEmpty && id.length > 10) {
      json['id'] = id;
    }
    return json;
  }
}
