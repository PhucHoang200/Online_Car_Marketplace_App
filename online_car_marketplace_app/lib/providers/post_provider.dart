import 'package:flutter/material.dart';
import 'package:online_car_marketplace_app/models/post_model.dart';
import 'package:online_car_marketplace_app/repositories/post_repository.dart';
import 'package:online_car_marketplace_app/models/post_with_car_and_images.dart';
import 'package:online_car_marketplace_app/models/car_model.dart';

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
      _posts = rawData.map((item) {
        return PostWithCarAndImages(
          post: item['post'],
          car: item['car'],
          sellerName: item['sellerName'] as String?,
          sellerPhone: item['sellerPhone'] as String?,
          sellerAddress: item['sellerAddress'] as String?,
          carLocation: item['carLocation'] as String?,
          imageUrls: List<String>.from(item['images']),
          carModelName: item['carModelName'] as String?,
        );
      }).toList();
    } catch (error) {
      _errorMessage = error.toString();
      _posts = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addPostAutoIncrement(Post post) async {
    await _postRepository.addPostAutoIncrement(post);
    await fetchPosts();
  }

  void clearPosts() {
    _posts = [];
    notifyListeners();
  }

  Future<PostWithCarAndImages?> getPostWithDetailsById(String postId) async {
    try {
      final postWithDetails = await _postRepository.getPostWithCarAndImagesById(postId);
      return postWithDetails;
    } catch (error) {
      print('Error fetching post details by ID: $error');
      return null;
    }
  }

  // Phương thức để fetch tất cả bài đăng (ban đầu hoặc khi cần)
  void fetchPosts1() {
    _isLoading = true;
    notifyListeners();

    _postRepository.getAllPosts().listen((postList) {
      _posts = postList;
      _isLoading = false;
      notifyListeners();
    }, onError: (error) {
      _isLoading = false;
      print('Error fetching posts: $error');
      notifyListeners();
    });
  }

  // Phương thức mới để tìm kiếm
  void searchPosts(String query) {
    _isLoading = true;
    notifyListeners();

    _postRepository.searchPosts(query).listen((postList) {
      _posts = postList;
      _isLoading = false;
      notifyListeners();
    }, onError: (error) {
      _isLoading = false;
      print('Error searching posts: $error');
      notifyListeners();
    });
  }

}
