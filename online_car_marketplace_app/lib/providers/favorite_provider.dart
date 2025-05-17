  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/car_model.dart';
import '../models/favorite_model.dart';
import '../models/post_model.dart';
import '../models/post_with_car_and_images.dart';
import '../repositories/favorite_repository.dart';
import '../repositories/post_repository.dart';

class FavoriteProvider extends ChangeNotifier {
  final FavoriteRepository _favoriteRepository = FavoriteRepository();
  final PostRepository _postRepository = PostRepository();

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
    _favoritePostsWithDetails.clear();
    try {
      final favoriteList = await _favoriteRepository.getFavoritesByUserId(userId);
      for (final favorite in favoriteList) {
        final postDoc = await _postRepository.getPostDetails(favorite.postId.toString()); // Sử dụng PostRepository

        if (postDoc.exists) {
          final post = Post.fromMap(postDoc.data() as Map<String, dynamic>);
          Car? car;
          String? sellerName;
          String? sellerPhone;
          String? carLocation;
          List<String> imageUrls = [];

          // Lấy thông tin xe
          final carDoc = await _postRepository.getCarDetails(post.carId.toString()); // Sử dụng PostRepository
          if (carDoc.exists) {
            final carData = carDoc.data() as Map<String, dynamic>;
            car = Car.fromMap(carData);
            carLocation = carData['location'] as String?;

            // Lấy ảnh theo carId (tương tự PostRepository)
            final imagesSnapshot = await FirebaseFirestore.instance
                .collection('images')
                .where('carId', isEqualTo: post.carId)
                .get();
            imageUrls = imagesSnapshot.docs.map((e) => e['url'] as String).toList();
          }

          // Lấy thông tin người dùng (tương tự PostRepository)
          if (post.userId != null) {
            final String sellerId = post.userId!;
            final userDoc = await FirebaseFirestore.instance.collection('users').doc(sellerId).get();
            if (userDoc.exists) {
              final userData = userDoc.data() as Map<String, dynamic>;
              sellerName = userData['name'] as String?;
              sellerPhone = userData['phone'] as String?;
            }
          }

          final postWithDetails = PostWithCarAndImages(
            post: post,
            car: car,
            sellerName: sellerName,
            sellerPhone: sellerPhone,
            carLocation: carLocation,
            imageUrls: imageUrls,
          );
          _favoritePostsWithDetails.add(postWithDetails);
        } else {
        }
      }
    } catch (e) {
      print('Error fetching favorite posts with details: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeFavorite(String userId, int postId) async {
    try {
      await _favoriteRepository.removeFavorite(userId, postId);
      _favoritePostsWithDetails.removeWhere((item) => item.post.id == postId);
      notifyListeners();
    } catch (e) {
      print('Error removing favorite: $e');
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

  Future<bool> isPostFavorite(String userId, int postId) async {
    try {
      final favoriteList = await _favoriteRepository.getFavoritesByUserIdAndPostId(userId, postId);
      return favoriteList.isNotEmpty;
    } catch (e) {
      return false;
    }
  }



}
