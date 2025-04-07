import 'package:cloud_firestore/cloud_firestore.dart';
class FirestoreHelper {
  static Future<void> addDocument(String collection, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection(collection).add(data);
  }
// Thêm các phương thức khác như get, update, delete
}