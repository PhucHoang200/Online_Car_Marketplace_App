import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/car_model.dart';

class CarRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> addCarAutoIncrement(Car car) async {
    final snapshot = await _firestore
        .collection('cars')
        .orderBy('id', descending: true)
        .limit(1)
        .get();

    int nextId = 1;
    if (snapshot.docs.isNotEmpty) {
      print("Kiểu dữ liệu userId từ Firestore: ${snapshot.docs.runtimeType}");
      final lastCar = Car.fromMap(snapshot.docs.first.data());
      nextId = lastCar.id + 1;
    }

    final newCar = Car(
      id: nextId,
      userId: car.userId,
      modelId: car.modelId,
      year: car.year,
      price: car.price,
      transmission: car.transmission,
      mileage: car.mileage,
      fuelType: car.fuelType,
      location: car.location,
      condition: car.condition,
      origin: car.origin,
    );

    final DocumentReference<Map<String, dynamic>> docRef =
    _firestore.collection('cars').doc(newCar.id.toString());
    await docRef.set(newCar.toMap());
    return docRef.id;
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

  // Future<void> updateCar(Car car) async {
  //   await _firestore.collection('cars').doc(car.id.toString()).update(car.toMap());
  // }
  //
  // Future<void> deleteCar(int id) async {
  //   await _firestore.collection('cars').doc(id.toString()).delete();
  // }
}
