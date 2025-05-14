import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final int id;
  final int userId;
  final int carId;
  final String title;
  final String description;
  final Timestamp creationDate;

  Post({
    required this.id,
    required this.userId,
    required this.carId,
    required this.title,
    required this.description,
    required this.creationDate,
  });

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as int,
      userId: map['userId'] as int,
      carId: map['carId'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      creationDate: map['creationDate'] as Timestamp,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'carId': carId,
    'title': title,
    'description': description,
    'creationDate': creationDate,
  };
}