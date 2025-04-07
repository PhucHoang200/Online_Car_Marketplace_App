import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../models/car_model.dart';
import 'image_repository.dart';

class CarRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImageRepository _imageRepository = ImageRepository();

  // Lấy danh sách xe
  Future<List<Car>> getCars() async {
    final snapshot = await _firestore.collection('cars').get();
    return snapshot.docs.map((doc) => Car.fromMap(doc.data())).toList();
  }

  // Thêm xe mới và upload ảnh lên Cloudinary
  Future<void> addCar(Car car, List<XFile> images) async {
    // Lưu thông tin xe vào Firestore
    await _firestore.doc('cars/${car.id}').set(car.toMap());

    // Upload ảnh lên Cloudinary và lưu URL vào Firestore
    if (images.isNotEmpty) {
      await _imageRepository.uploadCarImages(car.id, images);
    }
  }

  // Cập nhật xe
  Future<void> updateCar(Car car) async {
    await _firestore.doc('cars/${car.id}').update(car.toMap());
  }

  // Xóa xe
  Future<void> deleteCar(int carId) async {
    await _firestore.doc('cars/$carId').delete();
    // Xóa các ảnh liên quan (nếu cần)
    await _imageRepository.deleteCarImages(carId);
  }
}