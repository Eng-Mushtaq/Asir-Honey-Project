class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String userType;
  final String? businessName;
  final String? businessLicense;
  final String? location;
  final String? description;
  final String? avatar;
  final double? rating;
  final bool? isActive;
  final bool? isVerified;
  final int? totalReviews;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
    this.businessName,
    this.businessLicense,
    this.location,
    this.description,
    this.avatar,
    this.rating,
    this.isActive,
    this.isVerified,
    this.totalReviews,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle both snake_case (from database) and camelCase (from app)
    return UserModel(
      id: json['id']?.toString() ?? json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      userType: json['user_type'] ?? json['userType'] ?? 'consumer',
      businessName: json['business_name'] ?? json['businessName'],
      businessLicense: json['business_license'] ?? json['businessLicense'],
      location: json['location'],
      description: json['description'],
      avatar: json['avatar'],
      rating: json['rating']?.toDouble(),
      isActive: json['is_active'] ?? json['isActive'] ?? true,
      isVerified: json['is_verified'] ?? json['isVerified'] ?? false,
      totalReviews: json['total_reviews'] ?? json['totalReviews'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    // Convert to snake_case for database
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'user_type': userType,
      'business_name': businessName,
      'business_license': businessLicense,
      'location': location,
      'description': description,
      'avatar': avatar,
      'rating': rating,
      'is_active': isActive ?? true,
      'is_verified': isVerified ?? false,
      'total_reviews': totalReviews ?? 0,
    };
  }

  // User type helpers
  bool get isAdmin => userType == 'admin';
  bool get isConsumer => userType == 'consumer';
  bool get isBeekeeper => userType == 'beekeeper';
}
