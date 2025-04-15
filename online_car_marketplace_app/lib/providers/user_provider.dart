import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class UserProvider with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  List<User> _users = [];
  List<User> get users => _users;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      _users = await _userRepository.getUsers();
    } catch (e) {
      print('Error fetching users: $e');
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
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await _userRepository.updateUser(user);
      await fetchUsers();
    } catch (e) {
      print('Error updating user: $e');
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      await _userRepository.deleteUser(id);
      _users.removeWhere((u) => u.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting user: $e');
    }
  }
}
