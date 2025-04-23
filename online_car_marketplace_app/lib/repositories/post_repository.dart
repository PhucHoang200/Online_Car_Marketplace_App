import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';
import '../models/car_model.dart';


class PostRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addPost(Post post) async {
    await _firestore.doc('posts/${post.id}').set(post.toMap());
  }

  Future<void> addPostAutoIncrement(Post post) async {
    final snapshot = await _firestore
        .collection('posts')
        .orderBy('id', descending: true)
        .limit(1)
        .get();

    int nextId = 1;
    if (snapshot.docs.isNotEmpty) {
      final lastPost = Post.fromMap(snapshot.docs.first.data());
      nextId = lastPost.id + 1;
    }

    final newPost = Post(
      id: nextId,
      userId: post.userId,
      carId: post.carId,
      title: post.title,
      description: post.description,
      status: post.status,
      creationDate: post.creationDate,
    );

    await _firestore
        .collection('posts')
        .doc(newPost.id.toString())
        .set(newPost.toMap());
  }
  
  Future<List<Post>> getPosts() async {
    final snapshot = await _firestore.collection('posts').get();
    return snapshot.docs.map((doc) => Post.fromMap(doc.data())).toList();
  }

  /// Lấy danh sách post kèm car và danh sách ảnh (từ carId)
  Future<List<Map<String, dynamic>>> getPostsWithCarAndImages() async {
    final postsSnapshot = await _firestore.collection('posts').get();

    List<Map<String, dynamic>> results = [];

    for (var doc in postsSnapshot.docs) {
      final post = Post.fromMap(doc.data());

      // Lấy car theo carId
      final carDoc = await _firestore.collection('cars').doc(post.carId.toString()).get();
      Car? car = carDoc.exists ? Car.fromMap(carDoc.data()!) : null;

      // Lấy ảnh theo carId
      final imagesSnapshot = await _firestore
          .collection('images')
          .where('carId', isEqualTo: post.carId)
          .get();
      List<String> imageUrls = imagesSnapshot.docs.map((doc) => doc['url'] as String).toList();

      print('Post ID: ${post.id}, Car ID: ${post.carId}, Images: $imageUrls');

      results.add({
        'post': post,
        'car': car,
        'images': imageUrls,
      });
    }

    return results;
  }
}