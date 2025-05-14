// screens/price_title_description_screen.dart
import 'package:flutter/material.dart';
import 'image_upload_screen.dart';

class PriceTitleDescriptionScreen extends StatefulWidget {
  final String brandId;
  final String modelName;
  final String selectedYear;
  final String condition;
  final String origin;
  final int mileage;
  final String fuelType;
  final String transmission;

  const PriceTitleDescriptionScreen({
    super.key,
    required this.brandId,
    required this.modelName,
    required this.selectedYear,
    required this.condition,
    required this.origin,
    required this.mileage,
    required this.fuelType,
    required this.transmission,
  });

  @override
  State<PriceTitleDescriptionScreen> createState() => _PriceTitleDescriptionScreenState();
}

class _PriceTitleDescriptionScreenState extends State<PriceTitleDescriptionScreen> {
  TextEditingController priceController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giá bán & Mô tả')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Giá bán*',
                border: OutlineInputBorder(),
                suffixText: 'TRIỆU VND',
              ),
              onChanged: (value) {
                setState(() {}); // Gọi setState khi giá thay đổi
              },
            ),
            const SizedBox(height: 24),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Tiêu đề*',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {}); // Gọi setState khi giá thay đổi
              },
            ),
            const SizedBox(height: 24),
            TextField(
              controller: descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Mô tả*',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {}); // Gọi setState khi giá thay đổi
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: priceController.text.isNotEmpty &&
                  titleController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty
                  ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageUploadScreen(
                      brandId: widget.brandId,
                      modelName: widget.modelName,
                      selectedYear: widget.selectedYear,
                      condition: widget.condition,
                      origin: widget.origin,
                      mileage: widget.mileage,
                      fuelType: widget.fuelType,
                      transmission: widget.transmission,
                      price: double.parse(priceController.text),
                      title: titleController.text,
                      description: descriptionController.text,
                    ),
                  ),
                );
              }
                  : null,
              child: const Text('Tiếp tục'),
            ),
          ],
        ),
      ),
    );
  }
}