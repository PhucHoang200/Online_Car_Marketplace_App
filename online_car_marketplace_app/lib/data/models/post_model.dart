import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final int id;
  final int userId;
  final int carId;
  final String title;
  final String description;
  final String status;
  final Timestamp creationDate;
  final Timestamp updateDate;

  Post({
    required this.id,
    required this.userId,
    required this.carId,
    required this.title,
    required this.description,
    required this.status,
    required this.creationDate,
    required this.updateDate,
  });

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as int,
      userId: map['userId'] as int,
      carId: map['carId'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      status: map['status'] as String,
      creationDate: map['creationDate'] as Timestamp,
      updateDate: map['updateDate'] as Timestamp,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'carId': carId,
    'title': title,
    'description': description,
    'status': status,
    'creationDate': creationDate,
    'updateDate': updateDate,
  };
}