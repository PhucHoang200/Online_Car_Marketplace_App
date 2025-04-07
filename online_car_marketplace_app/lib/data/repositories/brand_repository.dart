import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/brand_model.dart';

class BrandRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addBrand(Brand brand) async {
    await _firestore.doc('brands/${brand.id}').set(brand.toMap());
  }

  Future<List<Brand>> getBrands() async {
    final snapshot = await _firestore.collection('brands').get();
    return snapshot.docs.map((doc) => Brand.fromMap(doc.data())).toList();
  }
}