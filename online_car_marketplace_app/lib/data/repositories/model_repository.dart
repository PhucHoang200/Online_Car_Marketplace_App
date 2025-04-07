import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/model_model.dart';

class ModelRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addModel(CarModel model) async {
    await _firestore.doc('models/${model.id}').set(model.toMap());
  }

  Future<List<CarModel>> getModels() async {
    final snapshot = await _firestore.collection('models').get();
    return snapshot.docs.map((doc) => CarModel.fromMap(doc.data())).toList();
  }
}