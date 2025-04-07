import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review_model.dart';

class ReviewRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addReview(Review review) async {
    await _firestore.doc('reviews/${review.id}').set(review.toMap());
  }

  Future<List<Review>> getReviews() async {
    final snapshot = await _firestore.collection('reviews').get();
    return snapshot.docs.map((doc) => Review.fromMap(doc.data())).toList();
  }
}