import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/car_model.dart';

class CarRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addCar(Car car) async {
    await _firestore.doc('cars/${car.id}').set(car.toMap());
  }

  Future<void> addCarAutoIncrement(Car car) async {
    final snapshot = await _firestore
        .collection('cars')
        .orderBy('id', descending: true)
        .limit(1)
        .get();

    int nextId = 1;
    if (snapshot.docs.isNotEmpty) {
      final lastCar = Car.fromMap(snapshot.docs.first.data());
      nextId = lastCar.id + 1;
    }

    final newCar = Car(
      id: nextId,
      userId: car.userId,
      modelId: car.modelId,
      year: car.year,
      price: car.price,
      licensePlate: car.licensePlate,
      transmission: car.transmission,
      mileage: car.mileage,
      fuelType: car.fuelType,
      location: car.location,
    );

    await _firestore.collection('cars').doc(newCar.id.toString()).set(newCar.toMap());
  }

  Future<List<Car>> getCars() async {
    final snapshot = await _firestore.collection('cars').get();
    return snapshot.docs.map((doc) => Car.fromMap(doc.data())).toList();
  }

  Future<Car?> getCarById(int id) async {
    final doc = await _firestore.collection('cars').doc(id.toString()).get();
    if (doc.exists) {
      return Car.fromMap(doc.data()!);
    }
    return null;
  }

  Future<void> updateCar(Car car) async {
    await _firestore.collection('cars').doc(car.id.toString()).update(car.toMap());
  }

  Future<void> deleteCar(int id) async {
    await _firestore.collection('cars').doc(id.toString()).delete();
  }
}
