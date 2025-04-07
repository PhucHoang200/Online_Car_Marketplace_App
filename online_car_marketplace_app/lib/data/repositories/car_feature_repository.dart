import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/car_feature_model.dart';

class CarFeatureRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addCarFeature(CarFeature carFeature) async {
    await _firestore.doc('car_features/${carFeature.carId}_${carFeature.featureId}').set(carFeature.toMap());
  }

  Future<List<CarFeature>> getCarFeatures() async {
    final snapshot = await _firestore.collection('car_features').get();
    return snapshot.docs.map((doc) => CarFeature.fromMap(doc.data())).toList();
  }
}