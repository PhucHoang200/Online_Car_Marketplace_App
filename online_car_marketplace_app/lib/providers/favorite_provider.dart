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
    print("--- fetchFavoritePosts bắt đầu cho User ID: $userId ---");
    try {
      final favoriteList = await _favoriteRepository.getFavoritesByUserId(userId);
      print("--- Số lượng favorites lấy được: ${favoriteList.length} ---");
      for (final favorite in favoriteList) {
        print("--- Đang xử lý Favorite ID: ${favorite.id}, Post ID: ${favorite.postId} ---");
        final postDoc = await _postRepository.getPostDetails(favorite.postId.toString()); // Sử dụng PostRepository
        print("--- Post ID: ${favorite.postId}, Post Snapshot tồn tại: ${postDoc.exists} ---");
        print("--- Post ID: ${favorite.postId}, Dữ liệu Post Snapshot: ${postDoc.data()} ---");

        if (postDoc.exists) {
          final post = Post.fromMap(postDoc.data() as Map<String, dynamic>);
          Car? car;
          String? sellerName;
          String? sellerPhone;
          String? carLocation;
          List<String> imageUrls = [];

          // Lấy thông tin xe
          if (post.carId != null) {
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
          print("--- Đã thêm bài đăng yêu thích với ID: ${post.id} ---");
        } else {
          print("--- Không tìm thấy bài đăng với ID: ${favorite.postId} ---");
        }
      }
    } catch (e) {
      print('Error fetching favorite posts with details: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
      print("--- Hoàn thành fetchFavoritePosts. Số lượng bài đăng yêu thích: ${_favoritePostsWithDetails.length} ---");
    }
  }

  Future<void> removeFavorite(String userId, int postId) async {
    try {
      await _favoriteRepository.removeFavorite(userId, postId);
      _favoritePostsWithDetails.removeWhere((item) => item.post.id == postId);
      notifyListeners();
      print("--- Đã xóa bài đăng với ID: $postId khỏi yêu thích của người dùng: $userId ---");
    } catch (e) {
      print("--- Lỗi khi xóa bài đăng với ID: $postId khỏi yêu thích của người dùng: $userId: $e ---");
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
    print("--- Bên trong addFavoriteAutoIncrement ---");
    try {
      await _favoriteRepository.addFavoriteAutoIncrement(favorite);
      _favorites.add(favorite);
      notifyListeners();
      print("--- Thêm vào yêu thích thành công trong Provider ---");
    } catch (e) {
      print('Error adding favorite with auto-increment ID: $e');
    }
  }

  Future<bool> isPostFavorite(String userId, int postId) async {
    try {
      final favoriteList = await _favoriteRepository.getFavoritesByUserIdAndPostId(userId, postId);
      return favoriteList.isNotEmpty;
    } catch (e) {
      print('Error checking if post is favorite: $e');
      return false;
    }
  }



}
