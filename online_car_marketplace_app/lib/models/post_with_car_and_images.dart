import '../models/post_model.dart';
import '../models/car_model.dart';

class PostWithCarAndImages {
  final Post post;
  final Car? car;
  final List<String> imageUrls;

  PostWithCarAndImages({
    required this.post,
    required this.car,
    required this.imageUrls,
  });
}
