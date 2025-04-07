import 'package:cloud_firestore/cloud_firestore.dart';

class Image {
  final int id;
  final int carId;
  final String url;
  final Timestamp creationDate;

  Image({
    required this.id,
    required this.carId,
    required this.url,
    required this.creationDate,
  });

  factory Image.fromMap(Map<String, dynamic> map) {
    return Image(
      id: map['id'] as int,
      carId: map['carId'] as int,
      url: map['url'] as String,
      creationDate: map['creationDate'] as Timestamp,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'carId': carId,
    'url': url,
    'creationDate': creationDate,
  };
}