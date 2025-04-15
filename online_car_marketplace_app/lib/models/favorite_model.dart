import 'package:cloud_firestore/cloud_firestore.dart';

class Favorite {
  final int id;
  final int userId;
  final int carId;

  Favorite({
    required this.id,
    required this.userId,
    required this.carId,
  });

  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      id: map['id'] as int,
      userId: map['userId'] as int,
      carId: map['carId'] as int,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'carId': carId,
  };
}