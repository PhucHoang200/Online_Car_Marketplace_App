import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../repositories/post_repository.dart';
import 'package:online_car_marketplace_app/models/post_with_car_and_images.dart';

class PostProvider with ChangeNotifier {
  final PostRepository _postRepository = PostRepository();
  List<PostWithCarAndImages> _posts = [];
  List<PostWithCarAndImages> get posts => _posts;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchPosts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final rawData = await _postRepository.getPostsWithCarAndImages();
      print("--- Dữ liệu thô từ Repository (Post Provider) ---");
      print(rawData);
      _posts = rawData.map((item) {
        print("--- Xử lý một item (Post Provider) ---");
        print("Tên người bán (Provider): ${item['sellerName']}");
        print("Số điện thoại người bán (Provider): ${item['sellerPhone']}");
        print("Địa chỉ người bán (Provider): ${item['sellerAddress']}");
        return PostWithCarAndImages(
          post: item['post'],
          car: item['car'],
          sellerName: item['sellerName'] as String?,
          sellerPhone: item['sellerPhone'] as String?,
          carLocation: item['carLocation'] as String?,
          imageUrls: List<String>.from(item['images']),
        );
      }).toList();
    } catch (error) {
      _errorMessage = error.toString();
      _posts = [];
      print("--- Lỗi trong Post Provider ---");
      print(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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
