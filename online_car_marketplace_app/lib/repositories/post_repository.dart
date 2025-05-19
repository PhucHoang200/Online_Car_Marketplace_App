import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_car_marketplace_app/models/post_model.dart';
import 'package:online_car_marketplace_app/models/car_model.dart';

import '../models/post_with_car_and_images.dart';

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

  Future<List<Map<String, dynamic>>> getPostsWithCarAndImages() async {
    final postsSnapshot = await _firestore.collection('posts').get();
    List<Map<String, dynamic>> results = [];

    for (var doc in postsSnapshot.docs) {
      final post = Post.fromMap(doc.data());
      Car? car;
      String? sellerName;
      String? sellerPhone;
      String? sellerAddress;
      String? carLocation;
      List<String> imageUrls = [];

      // Lấy thông tin xe
      final carDoc = await _firestore.collection('cars').doc(post.carId.toString()).get();
      if (carDoc.exists) {
        final carData = carDoc.data() as Map<String, dynamic>;
        car = Car.fromMap(carData);
        carLocation = carData['location'] as String?;
      }


      // Lấy thông tin người dùng
      if (post.userId != null) {
        final String userId = post.userId!;
        try {
          final userDoc = await _firestore.collection('users').doc(userId).get();
          if (userDoc.exists) {
            final userData = userDoc.data() as Map<String, dynamic>;
            sellerName = userData['name'] as String?;
            sellerPhone = userData['phone'] as String?;
            sellerAddress = userData['address'] as String?;
          } else {
            sellerName = null;
            sellerPhone = null;
          }
        } catch (e) {
          sellerName = null;
          sellerPhone = null;
        }
      } else {
        sellerName = null;
        sellerPhone = null;
      }

      // Lấy ảnh
      final imagesSnapshot = await _firestore
          .collection('images')
          .where('carId', isEqualTo: post.carId)
          .get();
      imageUrls = imagesSnapshot.docs.map((e) => e['url'] as String).toList();

      results.add({
        'post': post,
        'car': car,
        'sellerName': sellerName,
        'sellerPhone': sellerPhone,
        'sellerAddress': sellerAddress,
        'carLocation': carLocation,
        'images': imageUrls,
      });
    }

    return results;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getPostDetails(String postId) async {
    return await _firestore.collection('posts').doc(postId).get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getCarDetails(String carId) async {
    return await _firestore.collection('cars').doc(carId).get();
  }

  Future<PostWithCarAndImages?> getPostWithCarAndImagesById(String postId) async {
    final postDoc = await _firestore.collection('posts').doc(postId).get();
    if (postDoc.exists && postDoc.data() != null) {
      final postData = postDoc.data() as Map<String, dynamic>;
      final post = Post.fromMap(postData);
      return await _fetchPostDetails(post);
    }
    return null;
  }

  Future<PostWithCarAndImages> _fetchPostDetails(Post post) async {
    Car? car;
    String? sellerName;
    String? sellerPhone;
    String? sellerAddress;
    String? carLocation;
    List<String> imageUrls = [];

    // Lấy thông tin xe
    try {
      final carDoc = await _firestore.collection('cars').doc(post.carId.toString()).get();
      if (carDoc.exists) {
        final carData = carDoc.data() as Map<String, dynamic>;
        car = Car.fromMap(carData);
        carLocation = carData['location'] as String?;
      }
    } catch (e) {
      print('Error fetching car details for post ${post.id}: $e');
    }

    // Lấy thông tin người dùng
    if (post.userId != null) {
      final String userId = post.userId!;
      try {
        final userDoc = await _firestore.collection('users').doc(userId).get();
        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;
          sellerName = userData['name'] as String?;
          sellerPhone = userData['phone'] as String?;
          sellerAddress = userData['address'] as String?;
        } else {
          sellerName = null;
          sellerPhone = null;
          sellerAddress = null;
        }
      } catch (e) {
        print('Error fetching user details for post ${post.id}: $e');
        sellerName = null;
        sellerPhone = null;
        sellerAddress = null;
      }
    } else {
      sellerName = null;
      sellerPhone = null;
      sellerAddress = null;
    }

    // Lấy ảnh
    try {
      final imagesSnapshot = await _firestore
          .collection('images')
          .where('carId', isEqualTo: post.carId)
          .get();
      imageUrls = imagesSnapshot.docs.map((e) => e['url'] as String).toList();
    } catch (e) {
      print('Error fetching images for car ${post.carId}: $e');
    }

    return PostWithCarAndImages(
      post: post,
      car: car,
      sellerName: sellerName,
      sellerPhone: sellerPhone,
      sellerAddress: sellerAddress,
      carLocation: carLocation,
      imageUrls: imageUrls,
    );
  }
}