import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart'; 

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Hàm thêm user thủ công
  Future<void> addUser(User user) async {
    await _firestore.doc('users/${user.id}').set(user.toMap());
  }

  Future<void> addUserAutoIncrement(User user) async {
    // Lấy user cuối cùng theo id giảm dần
    final snapshot = await _firestore
        .collection('users')
        .orderBy('id', descending: true)
        .limit(1)
        .get();

    int nextId = 1;
    if (snapshot.docs.isNotEmpty) {
      final lastUser = User.fromMap(snapshot.docs.first.data());
      nextId = lastUser.id + 1;
    }

    final newUser = User(
      id: nextId,
      name: user.name,
      email: user.email,
      phone: user.phone,
      password: user.password,
      address: user.address,
      avatarUrl: user.avatarUrl,
      roleId: user.roleId,
      status: user.status,
      creationDate: user.creationDate,
      updateDate: user.updateDate,
    );

    await _firestore
        .collection('users')
        .doc(newUser.id.toString())
        .set(newUser.toMap());
  }

  Future<List<User>> getUsers() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return User.fromMap(data); // nếu bạn gán `id` từ data thì giữ nguyên
      }).toList();
    } catch (e) {
      throw Exception('Không thể tải danh sách người dùng: $e');
    }
  }

  Future<User?> getUserById(int id) async {
    final doc = await _firestore.collection('users').doc(id.toString()).get();
    if (doc.exists) {
      return User.fromMap(doc.data()!);
    }
    return null;
  }

  Future<void> updateUser(User user) async {
    await _firestore
        .collection('users')
        .doc(user.id.toString())
        .update(user.toMap());
  }

  Future<void> deleteUser(int id) async {
    await _firestore.collection('users').doc(id.toString()).delete();
  }
}

