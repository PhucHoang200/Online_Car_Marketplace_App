import 'package:cloud_firestore/cloud_firestore.dart';

class Car {
  final int id;
  final int userId;
  final double price;
  final int carTypeId;
  final int modelId;
  final int year;
  final int mileage;
  final String fuelType;
  final String transmission;
  final String location;
  final String licensePlate;
  final String chassisNumber;
  final String engineNumber;
  final DateTime inspectionDate;
  final String color;
  final int seats;
  final DateTime registrationDate;
  final double engineCapacity;
  final Timestamp creationDate;
  final Timestamp updateDate;

  Car({
    required this.id,
    required this.userId,
    required this.price,
    required this.carTypeId,
    required this.modelId,
    required this.year,
    required this.mileage,
    required this.fuelType,
    required this.transmission,
    required this.location,
    required this.licensePlate,
    required this.chassisNumber,
    required this.engineNumber,
    required this.inspectionDate,
    required this.color,
    required this.seats,
    required this.registrationDate,
    required this.engineCapacity,
    required this.creationDate,
    required this.updateDate,
  });

  factory Car.fromMap(Map<String, dynamic> map) {
    return Car(
      id: map['id'] as int,
      userId: map['userId'] as int,
      price: (map['price'] as num).toDouble(),
      carTypeId: map['carTypeId'] as int,
      modelId: map['modelId'] as int,
      year: map['year'] as int,
      mileage: map['mileage'] as int,
      fuelType: map['fuelType'] as String,
      transmission: map['transmission'] as String,
      location: map['location'] as String,
      licensePlate: map['licensePlate'] as String,
      chassisNumber: map['chassisNumber'] as String,
      engineNumber: map['engineNumber'] as String,
      inspectionDate: (map['inspectionDate'] as Timestamp).toDate(),
      color: map['color'] as String,
      seats: map['seats'] as int,
      registrationDate: (map['registrationDate'] as Timestamp).toDate(),
      engineCapacity: (map['engineCapacity'] as num).toDouble(),
      creationDate: map['creationDate'] as Timestamp,
      updateDate: map['updateDate'] as Timestamp,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'price': price,
    'carTypeId': carTypeId,
    'modelId': modelId,
    'year': year,
    'mileage': mileage,
    'fuelType': fuelType,
    'transmission': transmission,
    'location': location,
    'licensePlate': licensePlate,
    'chassisNumber': chassisNumber,
    'engineNumber': engineNumber,
    'inspectionDate': Timestamp.fromDate(inspectionDate),
    'color': color,
    'seats': seats,
    'registrationDate': Timestamp.fromDate(registrationDate),
    'engineCapacity': engineCapacity,
    'creationDate': creationDate,
    'updateDate': updateDate,
  };
}