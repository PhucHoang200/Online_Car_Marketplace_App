import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../repositories/post_repository.dart';

class PostProvider with ChangeNotifier {
  final PostRepository _postRepository = PostRepository();
  List<Post> _posts = [];

  List<Post> get posts => _posts;

  Future<void> fetchPosts() async {
    _posts = await _postRepository.getPosts();
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
