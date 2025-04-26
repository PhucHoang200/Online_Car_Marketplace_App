import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'dart:math';
import '../models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  // Store OTP codes for verification (in a real app, these would be sent via email)
  final Map<String, String> _otpCodes = {};
  // Store pending registrations
  final Map<String, User> _pendingRegistrations = {};
  // Store emails for password reset
  final Map<String, String> _resetOtpCodes = {};

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
      uid: user.uid,
      name: user.name,
      email: user.email,
      phone: user.phone,
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

  Future<User?> getUserByEmail(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null;
      }

      return User.fromMap(querySnapshot.docs.first.data());
    } catch (e) {
      throw Exception('Không thể tìm người dùng: $e');
    }
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

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Kiểm tra xác thực email
      if (!authResult.user!.emailVerified) {
        return {
          'success': false,
          'message': 'Email chưa được xác thực. Vui lòng kiểm tra email.',
        };
      }

      // Lấy thông tin user trong Firestore
      final user = await getUserByEmail(email);
      if (user == null) {
        return {
          'success': false,
          'message': 'Không tìm thấy người dùng trong hệ thống',
        };
      }

      if (user.status != 'Hoạt động') {
        return {
          'success': false,
          'message': 'Tài khoản đã bị khóa',
        };
      }

      return {
        'success': true,
        'user': user,
        'message': 'Đăng nhập thành công',
      };

    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi đăng nhập: $e',
      };
    }
  }



  // Đăng xuất
  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<Map<String, dynamic>> registerUser(User user, String password) async {
    try {
      // Kiểm tra email đã tồn tại trên Firebase Auth chưa
      final methods = await _auth.fetchSignInMethodsForEmail(user.email);
      if (methods.isNotEmpty) {
        return {
          'success': false,
          'message': 'Email đã được sử dụng',
        };
      }

      // Tạo tài khoản trên Firebase Authentication
      final authResult = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );

      final newUser = User(
        id: 0,
        uid: authResult.user!.uid,
        name: user.name,
        email: user.email,
        phone: user.phone,
        address: user.address,
        avatarUrl: user.avatarUrl,
        roleId: user.roleId,
        status: user.status,
        creationDate: user.creationDate,
        updateDate: user.updateDate,
      );

      // Lưu vào Firestore
      await addUserAutoIncrement(newUser);

      // Gửi email xác thực
      await authResult.user!.sendEmailVerification();

      return {
        'success': true,
        'message': 'Tài khoản đã được tạo. Vui lòng kiểm tra email để xác thực.',
        'authUser': authResult.user,
      };

    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi đăng ký: $e',
      };
    }
  }


  Future<Map<String, dynamic>> checkEmailVerification() async {
    try {
      // Reload user để cập nhật trạng thái xác thực
      await _auth.currentUser?.reload();
      final currentUser = _auth.currentUser;

      if (currentUser == null) {
        return {
          'success': false,
          'message': 'Không tìm thấy người dùng hiện tại',
        };
      }

      if (!currentUser.emailVerified) {
        return {
          'success': false,
          'message': 'Email chưa được xác thực',
        };
      }

      // Email đã được xác thực, lưu người dùng vào Firestore
      if (_pendingRegistrations.containsKey(currentUser.email)) {
        final user = _pendingRegistrations[currentUser.email]!;
        await addUserAutoIncrement(user);

        // Xóa khỏi danh sách chờ
        _pendingRegistrations.remove(currentUser.email);

        return {
          'success': true,
          'message': 'Đăng ký thành công',
        };
      } else {
        return {
          'success': false,
          'message': 'Không tìm thấy thông tin đăng ký',
        };
      }

    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi kiểm tra xác thực: $e',
      };
    }
  }

  // Gửi lại email xác thực
  Future<Map<String, dynamic>> resendVerificationEmail() async {
    try {
      final currentUser = _auth.currentUser;

      if (currentUser == null) {
        return {
          'success': false,
          'message': 'Không tìm thấy người dùng hiện tại',
        };
      }

      await currentUser.sendEmailVerification();

      return {
        'success': true,
        'message': 'Email xác thực đã được gửi lại',
      };

    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi gửi lại email xác thực: $e',
      };
    }
  }

  // Quên mật khẩu - Sử dụng Firebase Auth để gửi email đặt lại mật khẩu
  Future<Map<String, dynamic>> resetPasswordWithEmail(String email) async {
    try {
      // Kiểm tra người dùng tồn tại trong Firestore
      final user = await getUserByEmail(email);

      if (user == null) {
        return {
          'success': false,
          'message': 'Email không tồn tại trong hệ thống',
        };
      }

      // Gửi email đặt lại mật khẩu
      await _auth.sendPasswordResetEmail(email: email);

      return {
        'success': true,
        'message': 'Link đặt lại mật khẩu đã được gửi đến email của bạn',
      };

    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi yêu cầu đặt lại mật khẩu: $e',
      };
    }
  }

  // Kiểm tra trạng thái đăng nhập hiện tại
  auth.User? getCurrentAuthUser() {
    return _auth.currentUser;
  }

  // Lắng nghe thay đổi trạng thái xác thực
  Stream<auth.User?> get authStateChanges => _auth.authStateChanges();
}

