class ReviewModel {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final String userAvatar;
  final double rating;
  final String comment;
  final DateTime date;

  ReviewModel({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.comment,
    required this.date,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      productId: json['productId'],
      userId: json['userId'],
      userName: json['userName'],
      userAvatar: json['userAvatar'],
      rating: json['rating'].toDouble(),
      comment: json['comment'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
    };
  }
}
