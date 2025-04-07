import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/car_type_model.dart';

class CarTypeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addCarType(CarType carType) async {
    await _firestore.doc('car_types/${carType.id}').set(carType.toMap());
  }

  Future<List<CarType>> getCarTypes() async {
    final snapshot = await _firestore.collection('car_types').get();
    return snapshot.docs.map((doc) => CarType.fromMap(doc.data())).toList();
  }
}