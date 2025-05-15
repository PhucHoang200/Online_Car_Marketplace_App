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
      // status: post.status,
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
    print("--- Bắt đầu lấy dữ liệu bài đăng (Repository) ---");

    for (var doc in postsSnapshot.docs) {
      final post = Post.fromMap(doc.data() as Map<String, dynamic>);
      Car? car;
      String? sellerName;
      String? sellerPhone;
      String? carLocation;
      List<String> imageUrls = [];
      print("--- Xử lý bài đăng ID: ${post.id} ---");
      print("User ID của bài đăng: ${post.userId}");

      // Lấy thông tin xe
      if (post.carId != null) {
        final carDoc = await _firestore.collection('cars').doc(post.carId.toString()).get();
        if (carDoc.exists) {
          final carData = carDoc.data() as Map<String, dynamic>;
          car = Car.fromMap(carData);
          carLocation = carData['location'] as String?;
        }
      }


      // Lấy thông tin người dùng
      if (post.userId != null) {
        final String userId = post.userId!; // Ép kiểu String vì đã kiểm tra null
        print("Tìm kiếm thông tin người dùng với UID: $userId");
        try {
          final userDoc = await _firestore.collection('users').doc(userId).get();
          if (userDoc.exists) {
            final userData = userDoc.data() as Map<String, dynamic>;
            sellerName = userData['name'] as String?;
            sellerPhone = userData['phone'] as String?;
            print("Đã lấy thông tin người dùng cho UID $userId:");
            print("  Tên: $sellerName");
            print("  Số điện thoại: $sellerPhone");
          } else {
            print("Không tìm thấy thông tin người dùng cho UID: $userId");
            sellerName = null; // Đặt giá trị mặc định nếu không tìm thấy
            sellerPhone = null; // Đặt giá trị mặc định nếu không tìm thấy
          }
        } catch (e) {
          print("Lỗi khi lấy thông tin người dùng cho UID $userId: $e");
          sellerName = null;
          sellerPhone = null;
        }
      } else {
        print("User ID của bài đăng là null.");
        sellerName = null; // Đặt giá trị mặc định nếu null
        sellerPhone = null; // Đặt giá trị mặc định nếu null
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
        'carLocation': carLocation,
        'images': imageUrls,
      });
    }
    print("--- Kết thúc lấy dữ liệu bài đăng (Repository) ---");
    print("Kết quả trả về từ Repository: $results");

    return results;
  }

}