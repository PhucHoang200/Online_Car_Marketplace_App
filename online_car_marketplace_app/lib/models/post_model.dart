import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_car_marketplace_app/utils/validators/post_validator.dart';

class Post {
  final int id;
  final int userId;
  final int carId;
  final String title;
  final String description;
  // final String status;
  final Timestamp creationDate;

  Post({
    required this.id,
    required this.userId,
    required this.carId,
    required this.title,
    required this.description,
    // required String status,
    required this.creationDate,
  }); //: status = PostValidator.validateStatus(status) ;

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as int,
      userId: map['userId'] as int,
      carId: map['carId'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      // status: map['status'] as String,
      creationDate: map['creationDate'] as Timestamp,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'carId': carId,
    'title': title,
    'description': description,
    // 'status': status,
    'creationDate': creationDate,
  };
}