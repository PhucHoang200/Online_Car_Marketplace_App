import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_car_marketplace_app/utils/validators/car_validator.dart';

class Car {
  final int id;
  final int userId;
  final int modelId;
  final String fuelType;
  final String transmission;
  final int year;
  final int mileage;
  final String licensePlate;
  final String location;
  final double price;

  Car({
    required this.id,
    required this.userId,
    required this.modelId,
    required this.fuelType,
    required this.transmission,
    required this.year,
    required this.mileage,
    required String licensePlate,
    required this.location,
    required this.price,
  }) : licensePlate = CarValidator.validateLicensePlate(licensePlate);

  factory Car.fromMap(Map<String, dynamic> map) {
    return Car(
      id: map['id'],
      userId: map['userId'],
      modelId: map['modelId'],
      fuelType: map['fuelType'],
      transmission: map['transmission'],
      year: map['year'],
      mileage: map['mileage'],
      licensePlate: map['licensePlate'],
      location: map['location'],
      price: (map['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'modelId': modelId,
    'fuelType': fuelType,
    'transmission': transmission,
    'year': year,
    'mileage': mileage,
    'licensePlate': licensePlate,
    'location': location,
    'price': price,
  };
}
