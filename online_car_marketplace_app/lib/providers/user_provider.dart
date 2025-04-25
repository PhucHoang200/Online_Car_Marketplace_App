import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class UserProvider with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  List<User> _users = [];
  List<User> get users => _users;

  User? _currentUser;
  User? get currentUser => _currentUser;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  auth.User? _authUser;
  auth.User? get authUser => _authUser;

  // Thiết lập lắng nghe trạng thái xác thực
  UserProvider() {
    _userRepository.authStateChanges.listen((auth.User? user) {
      _authUser = user;
      _isAuthenticated = user != null;
      notifyListeners();
    });
  }

  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      _users = await _userRepository.getUsers();
    } catch (e) {
      print('Error fetching users: $e');
      _errorMessage = 'Lỗi khi tải danh sách người dùng: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addUser(User user) async {
    try {
      await _userRepository.addUserAutoIncrement(user);
      await fetchUsers(); // cập nhật danh sách
    } catch (e) {
      print('Error adding user: $e');
      _errorMessage = 'Lỗi khi thêm người dùng: $e';
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await _userRepository.updateUser(user);
      await fetchUsers();
    } catch (e) {
      print('Error updating user: $e');
      _errorMessage = 'Lỗi khi cập nhật người dùng: $e';
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      await _userRepository.deleteUser(id);
      _users.removeWhere((u) => u.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting user: $e');
      _errorMessage = 'Lỗi khi xóa người dùng: $e';
    }
  }

  // Authentication Methods

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _userRepository.login(email, password);

      if (result['success']) {
        _currentUser = result['user'];
        _isAuthenticated = true;
      } else {
        _errorMessage = result['message'];
      }

      _isLoading = false;
      notifyListeners();
      return result['success'];
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Lỗi đăng nhập: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _userRepository.logout();
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  // Register step 1: Đăng ký và gửi email xác thực
  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String address,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newUser = User(
        id: 0, // this will be auto-incremented by the repository
        name: name,
        email: email,
        phone: phone,
        password: password,
        address: address,
        avatarUrl: null,
        roleId: 1, // assuming 1 is for normal users
        status: 'Hoạt động',
        creationDate: Timestamp.now(),
        updateDate: Timestamp.now(),
      );

      final result = await _userRepository.registerUser(newUser);

      if (!result['success']) {
        _errorMessage = result['message'];
      }

      _isLoading = false;
      notifyListeners();
      return result['success'];
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Lỗi đăng ký: $e';
      notifyListeners();
      return false;
    }
  }

  // Kiểm tra xác thực email
  Future<bool> checkEmailVerification() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _userRepository.checkEmailVerification();

      if (!result['success']) {
        _errorMessage = result['message'];
      }

      _isLoading = false;
      notifyListeners();
      return result['success'];
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Lỗi kiểm tra xác thực: $e';
      notifyListeners();
      return false;
    }
  }

  // Gửi lại email xác thực
  Future<bool> resendVerificationEmail() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _userRepository.resendVerificationEmail();

      if (!result['success']) {
        _errorMessage = result['message'];
      }

      _isLoading = false;
      notifyListeners();
      return result['success'];
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Lỗi gửi lại email xác thực: $e';
      notifyListeners();
      return false;
    }
  }

  // Quên mật khẩu: Gửi email đặt lại mật khẩu
  Future<bool> sendPasswordResetEmail(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _userRepository.resetPasswordWithEmail(email);

      if (!result['success']) {
        _errorMessage = result['message'];
      }

      _isLoading = false;
      notifyListeners();
      return result['success'];
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Lỗi gửi email đặt lại mật khẩu: $e';
      notifyListeners();
      return false;
    }
  }

  // Clear any error messages
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Kiểm tra người dùng hiện tại
  auth.User? getCurrentAuthUser() {
    return _userRepository.getCurrentAuthUser();
  }

  // Thêm vào UserProvider
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
