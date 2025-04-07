import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final int id;
  final int reviewerId;
  final int carId;
  final String content;
  final Timestamp creationDate;

  Review({
    required this.id,
    required this.reviewerId,
    required this.carId,
    required this.content,
    required this.creationDate,
  });

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'] as int,
      reviewerId: map['reviewerId'] as int,
      carId: map['carId'] as int,
      content: map['content'] as String,
      creationDate: map['creationDate'] as Timestamp,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'reviewerId': reviewerId,
    'carId': carId,
    'content': content,
    'creationDate': creationDate,
  };
}