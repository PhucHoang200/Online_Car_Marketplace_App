import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_car_marketplace_app/data/models/car_model.dart';
import 'package:online_car_marketplace_app/data/repositories/car_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostCarScreen extends StatefulWidget {
  @override
  _PostCarScreenState createState() => _PostCarScreenState();
}

class _PostCarScreenState extends State<PostCarScreen> {
  final CarRepository _carRepository = CarRepository();
  final List<XFile> _images = [];
  final picker = ImagePicker();

  Future<void> _pickImages() async {
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _images.addAll(pickedFiles);
      });
    }
  }

  Future<void> _postCar() async {
    // Tạo đối tượng Car (ví dụ)
    final car = Car(
      id: 1, // Thay bằng ID tự tăng hoặc lấy từ Firestore
      userId: 1, // ID người dùng hiện tại
      price: 800000000,
      carTypeId: 1,
      modelId: 1,
      year: 2020,
      mileage: 25000,
      fuelType: 'Xang',
      transmission: 'SoSan',
      location: 'Ha Noi',
      licensePlate: '29A-12345',
      chassisNumber: 'A12345',
      engineNumber: 'B12345',
      inspectionDate: DateTime(2025, 12, 31),
      color: 'Den',
      seats: 5,
      registrationDate: DateTime(2020, 1, 1),
      engineCapacity: 2.5,
      creationDate: Timestamp.now(),
      updateDate: Timestamp.now(),
    );

    // Thêm xe và ảnh
    await _carRepository.addCar(car, _images);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Car posted successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Post Car')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _pickImages,
              child: Text('Pick Images'),
            ),
            if (_images.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _images.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.file(
                        File(_images[index].path),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            ElevatedButton(
              onPressed: _postCar,
              child: Text('Post Car'),
            ),
          ],
        ),
      ),
    );
  }
}