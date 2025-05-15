// screens/image_upload_screen.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'confirm_post_screen.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadScreen extends StatefulWidget {
  final String brandId;
  final String modelName;
  final String selectedYear;
  final String condition;
  final String origin;
  final int mileage;
  final String fuelType;
  final String transmission;
  final double price;
  final String title;
  final String description;
  final XFile? initialImage;

  const ImageUploadScreen({
    super.key,
    required this.brandId,
    required this.modelName,
    required this.selectedYear,
    required this.condition,
    required this.origin,
    required this.mileage,
    required this.fuelType,
    required this.transmission,
    required this.price,
    required this.title,
    required this.description,
    this.initialImage,
  });

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  XFile? _selectedImage;

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.initialImage; // Khởi tạo ảnh nếu có
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _selectedImage = pickedFile;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Tải ảnh lên'),
          leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context, _selectedImage); // Trả về ảnh khi đóng
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Chọn ảnh từ máy của bạn để tải lên'),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: _selectedImage != null
                    ? Image.file(File(_selectedImage!.path), fit: BoxFit.cover)
                    : const Center(child: Icon(Icons.add_a_photo, size: 48, color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfirmPostScreen(
                      brandId: widget.brandId,
                      modelName: widget.modelName,
                      selectedYear: widget.selectedYear,
                      condition: widget.condition,
                      origin: widget.origin,
                      mileage: widget.mileage,
                      fuelType: widget.fuelType,
                      transmission: widget.transmission,
                      price: widget.price,
                      title: widget.title,
                      description: widget.description,
                      selectedImage: _selectedImage,
                    ),
                  ),
                );
              },
              child: const Text('Chọn ảnh & Tiếp tục'),
            ),
            const SizedBox(height: 20),
            const Text('Sau khi chọn ảnh, bạn sẽ được xem lại toàn bộ thông tin trước khi đăng bài.'),
          ],
        ),
      ),
    );
  }
}