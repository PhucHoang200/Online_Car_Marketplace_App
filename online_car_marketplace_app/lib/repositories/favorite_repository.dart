import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/favorite_model.dart';

class FavoriteRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addFavorite(Favorite favorite) async {
    await _firestore.doc('favorites/${favorite.id}').set(favorite.toMap());
  }

  // Thêm favorite với ID tự động tăng
  Future<void> addFavoriteAutoIncrement(Favorite favorite) async {
    final snapshot = await _firestore
        .collection('favorites')
        .orderBy('id', descending: true)
        .limit(1)
        .get();

    int nextId = 1;
    if (snapshot.docs.isNotEmpty) {
      final lastBrand = Favorite.fromMap(snapshot.docs.first.data());
      nextId = lastBrand.id + 1;
    }

    final newFavorite = Favorite(
      id: nextId,
      userId: favorite.userId,
     postId: favorite.postId,
    );

    await _firestore
        .collection('favorites')
        .doc(newFavorite.id.toString())
        .set(newFavorite.toMap());
  }

  Future<List<Favorite>> getFavorites() async {
    final snapshot = await _firestore.collection('favorites').get();
    return snapshot.docs.map((doc) => Favorite.fromMap(doc.data())).toList();
  }

  // Lấy danh sách các mục yêu thích của một người dùng cụ thể
  Future<List<Favorite>> getFavoritesByUserId(String userId) async {
    print("--- Truy vấn favorites cho User ID: $userId ---");
    final snapshot = await _firestore
        .collection('favorites')
        .where('userId', isEqualTo: userId)
        .get();
    print("--- Số lượng favorites tìm thấy: ${snapshot.docs.length} ---");
    return snapshot.docs.map((doc) => Favorite.fromMap(doc.data())).toList();
  }

  // // Lấy thông tin chi tiết của một bài post dựa trên postId
  // Future<DocumentSnapshot<Map<String, dynamic>>> getPostDetails(String postId) async {
  //   return await _firestore.collection('posts').doc(postId).get();
  // }
  //
  // // Lấy danh sách URLs của hình ảnh liên quan đến postId
  // Future<List<String>> getPostImageUrls(String postId) async {
  //   final snapshot = await _firestore
  //       .collection('post_images')
  //       .where('postId', isEqualTo: postId)
  //       .get();
  //   return snapshot.docs.map((doc) => doc.data()['imageUrl'] as String).toList();
  // }

  Future<void> removeFavorite(String userId, int postId) async {
    final snapshot = await _firestore
        .collection('favorites')
        .where('userId', isEqualTo: userId)
        .where('postId', isEqualTo: postId)
        .get();

    for (var doc in snapshot.docs) {
      await _firestore.collection('favorites').doc(doc.id).delete();
      print("--- Đã xóa bài đăng ID: $postId khỏi yêu thích của người dùng: $userId (document ID: ${doc.id}) ---");
      return; // Giả sử mỗi người dùng chỉ có một mục yêu thích cho mỗi bài đăng
    }
    print("--- Không tìm thấy bài đăng ID: $postId trong yêu thích của người dùng: $userId ---");
  }

  Future<List<Favorite>> getFavoritesByUserIdAndPostId(String userId, int postId) async {
    print("--- Truy vấn favorites cho User ID: $userId và Post ID: $postId ---");
    final snapshot = await _firestore
        .collection('favorites')
        .where('userId', isEqualTo: userId)
        .where('postId', isEqualTo: postId)
        .get();
    print("--- Số lượng favorites tìm thấy: ${snapshot.docs.length} ---");
    return snapshot.docs.map((doc) => Favorite.fromMap(doc.data())).toList();
  }
}
