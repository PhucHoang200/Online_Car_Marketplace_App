  import 'package:flutter/material.dart';
import '../models/favorite_model.dart';
import '../models/post_with_car_and_images.dart';
import '../repositories/favorite_repository.dart';

class FavoriteProvider extends ChangeNotifier {
  final FavoriteRepository _favoriteRepository = FavoriteRepository();

  List<Favorite> _favorites = [];
  List<Favorite> get favorites => _favorites;
  List<PostWithCarAndImages> _favoritePostsWithDetails = [];
  List<PostWithCarAndImages> get favoritePostsWithDetails => _favoritePostsWithDetails;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      _favorites = await _favoriteRepository.getFavorites();
    } catch (e) {
      print('Error fetching favorites: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchFavoritePosts(String userId) async {
    _isLoading = true;
    notifyListeners();
    _favoritePostsWithDetails.clear(); // Clear danh sách cũ trước khi tải mới
    try {
      final favoriteList = await _favoriteRepository.getFavoritesByUserId(userId);
      for (final favorite in favoriteList) {
        final postSnapshot = await _favoriteRepository.getPostDetails(favorite.postId as String);
        if (postSnapshot.exists) {
          final postData = postSnapshot.data()!;
          final carData = postData['car'] as Map<String, dynamic>?;
          final imageUrls = await _favoriteRepository.getPostImageUrls(favorite.postId as String);
          final sellerName = postData['sellerName'] as String?;
          final sellerPhone = postData['sellerPhone'] as String?;
          final carLocation = postData['location'] as String?; // Đảm bảo tên trường đúng

          if (carData != null) {
            final postWithDetails = PostWithCarAndImages.fromJson({
              'post': postData,
              'car': carData,
              'imageUrls': imageUrls,
              'sellerName': sellerName,
              'sellerPhone': sellerPhone,
              'carLocation': carLocation,
            });
            _favoritePostsWithDetails.add(postWithDetails);
          }
        }
      }
    } catch (e) {
      print('Error fetching favorite posts with details: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addFavorite(Favorite favorite) async {
    try {
      await _favoriteRepository.addFavorite(favorite);
      _favorites.add(favorite);
      notifyListeners();
    } catch (e) {
      print('Error adding favorite: $e');
    }
  }

  // Gọi phương thức addFavoriteAutoIncrement từ repository
  Future<void> addFavoriteAutoIncrement(Favorite favorite) async {
    try {
      await _favoriteRepository.addFavoriteAutoIncrement(favorite);
      _favorites.add(favorite);
      notifyListeners();
    } catch (e) {
      print('Error adding favorite with auto-increment ID: $e');
    }
  }

  Future<void> removeFavorite(String userId, int postId) async { // Changed postId to int
    try {
      // Tìm item yêu thích để xóa dựa trên userId và postId
      final favoriteToRemove = _favorites.firstWhere((fav) => fav.userId == userId && fav.postId == postId, orElse: () => Favorite(id: 0, userId: '', postId: 0)); // Changed default values to match int
      if (favoriteToRemove.id != 0) { // Changed comparison to int
        await _favoriteRepository.removeFavorite(favoriteToRemove.id); // Assuming you have a removeFavorite method in your repository that takes the favorite id.
        _favorites.removeWhere((fav) => fav.userId == userId && fav.postId == postId);
        _favoritePostsWithDetails.removeWhere((item) => item.post.id == postId.toString()); // Keep postId as String here
        notifyListeners();
      }
    } catch (e) {
      print('Error removing favorite: $e');
    }
  }

}
