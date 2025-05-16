import '../models/post_model.dart';
import '../models/car_model.dart';

class PostWithCarAndImages {
  final Post post;
  final Car? car;
  final List<String> imageUrls;
  final String? sellerName;
  final String? sellerPhone;
  final String? carLocation;

  PostWithCarAndImages({
    required this.post,
    required this.car,
    required this.imageUrls,
    this.sellerName,
    this.sellerPhone,
    this.carLocation,
  });

  factory PostWithCarAndImages.fromJson(Map<String, dynamic> map) {
    return PostWithCarAndImages(
      post: Post.fromMap(map['post'] as Map<String, dynamic>),
      car: map['car'] != null ? Car.fromMap(map['car'] as Map<String, dynamic>) : null,
      imageUrls: (map['imageUrls'] as List<dynamic>?)?.cast<String>() ?? [],
      sellerName: map['sellerName'] as String?,
      sellerPhone: map['sellerPhone'] as String?,
      carLocation: map['carLocation'] as String?,
    );
  }
}