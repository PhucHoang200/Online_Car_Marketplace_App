import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/model_model.dart';

class ModelRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addModel(CarModel model) async {
    await _firestore.doc('models/${model.id}').set(model.toMap());
  }

  Future<void> addModelAutoIncrement(CarModel model) async {
    final snapshot = await _firestore
        .collection('models')
        .orderBy('id', descending: true)
        .limit(1)
        .get();

    int nextId = 1;
    if (snapshot.docs.isNotEmpty) {
      final lastModel = CarModel.fromMap(snapshot.docs.first.data());
      nextId = lastModel.id + 1;
    }

    final newModel = CarModel(
      id: nextId,
      brandId: model.brandId,
      carTypeId: model.carTypeId,
      name: model.name,
    );

    await _firestore
        .collection('models')
        .doc(newModel.id.toString())
        .set(newModel.toMap());
  }

  Future<List<CarModel>> getModels() async {
    final snapshot = await _firestore.collection('models').get();
    return snapshot.docs.map((doc) => CarModel.fromMap(doc.data())).toList();
  }
}