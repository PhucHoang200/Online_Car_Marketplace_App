// screens/image_upload_screen.dart
import 'package:flutter/material.dart';
import 'confirm_post_screen.dart';

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
  });

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tải ảnh lên')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Chọn ảnh từ máy của bạn để tải lên'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement logic to pick images from device
                // After picking, you would typically update the UI to show the selected image.
                // For now, we'll just navigate to the confirmation screen.
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