import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/favorite_model.dart';

class FavoriteRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addFavorite(Favorite favorite) async {
    await _firestore.doc('favorites/${favorite.id}').set(favorite.toMap());
  }

  Future<List<Favorite>> getFavorites() async {
    final snapshot = await _firestore.collection('favorites').get();
    return snapshot.docs.map((doc) => Favorite.fromMap(doc.data())).toList();
  }
}