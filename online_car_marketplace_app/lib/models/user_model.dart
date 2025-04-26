import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_car_marketplace_app/utils/validators/user_validator.dart';

class User {
  final int id;
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String? avatarUrl;
  final int roleId;
  final String status;
  final Timestamp creationDate;
  final Timestamp updateDate;

  User({
    required this.id,
    required this.uid,
    required String name,
    required this.email,
    required this.phone,
    required this.address,
    this.avatarUrl,
    required this.roleId,
    required String status,
    required this.creationDate,
    required this.updateDate,
    bool isHashed = false,
  })  : name = UserValidator.validateName(name),
        status = UserValidator.validateStatus(status);

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      uid: map['uid'] ?? '',
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      address: map['address'],
      avatarUrl: map['avatarUrl'],
      roleId: map['roleId'],
      status: map['status'],
      creationDate: map['creationDate'],
      updateDate: map['updateDate'],
      isHashed: true,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'uid': uid,
    'name': name,
    'email': email,
    'phone': phone,
    'address': address,
    'avatarUrl': avatarUrl,
    'roleId': roleId,
    'status': status,
    'creationDate': creationDate,
    'updateDate': updateDate,
  };
}
