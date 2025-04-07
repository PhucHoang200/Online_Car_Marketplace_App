import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/feature_model.dart';

class FeatureRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addFeature(Feature feature) async {
    await _firestore.doc('features/${feature.id}').set(feature.toMap());
  }

  Future<List<Feature>> getFeatures() async {
    final snapshot = await _firestore.collection('features').get();
    return snapshot.docs.map((doc) => Feature.fromMap(doc.data())).toList();
  }
}