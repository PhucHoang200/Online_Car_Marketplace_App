import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../repositories/post_repository.dart';
import 'package:online_car_marketplace_app/models/post_with_car_and_images.dart';

class PostProvider with ChangeNotifier {
  final PostRepository _postRepository = PostRepository();
  List<PostWithCarAndImages> _posts = [];

  List<PostWithCarAndImages> get posts => _posts;

  Future<void> fetchPosts() async {
    final rawData = await _postRepository.getPostsWithCarAndImages();

    _posts = rawData.map((item) {
      return PostWithCarAndImages(
        post: item['post'],
        car: item['car'],
        imageUrls: List<String>.from(item['images']),
      );
    }).toList();

    notifyListeners();
  }

  Future<void> addPostAutoIncrement(Post post) async {
    await _postRepository.addPostAutoIncrement(post);
    await fetchPosts(); // Cập nhật lại danh sách sau khi thêm
  }

  void clearPosts() {
    _posts = [];
    notifyListeners();
  }
}
