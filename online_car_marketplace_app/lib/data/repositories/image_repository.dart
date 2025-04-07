import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../services/storage_service.dart';

class ImageRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageService _storageService = StorageService();

  // Upload ảnh lên Cloudinary và lưu URL vào Firestore
  Future<void> uploadCarImages(int carId, List<XFile> images) async {
    for (var image in images) {
      // Upload ảnh lên Cloudinary
      final imageUrl = await _storageService.uploadImage(image);
      // Lưu URL vào Firestore
      await _firestore.collection('images').add({
        'carId': carId,
        'url': imageUrl,
        'creationDate': Timestamp.now(),
      });
    }
  }

  // Lấy danh sách URL ảnh của xe
  Future<List<String>> getCarImages(int carId) async {
    final snapshot = await _firestore
        .collection('images')
        .where('carId', isEqualTo: carId)
        .get();
    return snapshot.docs.map((doc) => doc['url'] as String).toList();
  }

  // Xóa ảnh của xe (nếu cần)
  Future<void> deleteCarImages(int carId) async {
    final snapshot = await _firestore
        .collection('images')
        .where('carId', isEqualTo: carId)
        .get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}