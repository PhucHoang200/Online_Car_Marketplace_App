import 'package:cloud_firestore/cloud_firestore.dart';

class Favorite {
  final int id;
  final int userId;
  final int carId;
  final Timestamp creationDate;

  Favorite({
    required this.id,
    required this.userId,
    required this.carId,
    required this.creationDate,
  });

  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      id: map['id'] as int,
      userId: map['userId'] as int,
      carId: map['carId'] as int,
      creationDate: map['creationDate'] as Timestamp,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'carId': carId,
    'creationDate': creationDate,
  };
}