import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String password; // Đã mã hóa
  final String address;
  final String? avatarUrl;
  final int roleId;
  final String status;
  final Timestamp creationDate;
  final Timestamp updateDate;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required String password,
    required this.address,
    this.avatarUrl,
    required this.roleId,
    required this.status,
    required this.creationDate,
    required this.updateDate,
  }) : password = _hashPassword(password); // mã hóa SHA tại đây

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      password: map['password'] as String, // đã là hashed nên không hash lại
      address: map['address'] as String,
      avatarUrl: map['avatarUrl'] as String?,
      roleId: map['roleId'] as int,
      status: map['status'] as String,
      creationDate: map['creationDate'] as Timestamp,
      updateDate: map['updateDate'] as Timestamp,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'password': password, // đã hash
    'address': address,
    'avatarUrl': avatarUrl,
    'roleId': roleId,
    'status': status,
    'creationDate': creationDate,
    'updateDate': updateDate,
  };

  /// Hàm mã hóa SHA256
  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }
}
