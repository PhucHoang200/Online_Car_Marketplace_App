// screens/price_title_description_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PriceTitleDescriptionScreen extends StatefulWidget {
  final String brandId;
  final String modelName;
  final String selectedYear;
  final String condition;
  final String origin;
  final int mileage;
  final String fuelType;
  final String transmission;
  final Map<String, dynamic>? initialData;
  final double? initialPrice;
  final String? initialTitle;
  final String? initialDescription;

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
    this.initialData,
    this.initialPrice,
    this.initialTitle,
    this.initialDescription,
  });

  @override
  State<PriceTitleDescriptionScreen> createState() => _PriceTitleDescriptionScreenState();
}

class _PriceTitleDescriptionScreenState extends State<PriceTitleDescriptionScreen> {
  TextEditingController priceController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialPrice != null) {
      priceController.text = widget.initialPrice!.toStringAsFixed(0);
    }
    titleController.text = widget.initialTitle ?? '';
    descriptionController.text = widget.initialDescription ?? '';
  }

  @override
  void dispose() {
    priceController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

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
                  descriptionController.text.isNotEmpty &&
                  widget.condition != null &&
                  widget.origin != null &&
                  widget.fuelType != null &&
                  widget.transmission != null
                  ? () {
                double? price =
                double.tryParse(priceController.text);
                if (price == null) {
                  // Show error message using SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Giá không hợp lệ'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return; // Stop navigation
                }

                context.go(
                  '/sell/image-upload',
                  extra: {
                    'brandId': widget.brandId,
                    'modelName': widget.modelName,
                    'selectedYear': widget.selectedYear,
                    'condition': widget.condition,
                    'origin': widget.origin,
                    'mileage': widget.mileage,
                    'fuelType': widget.fuelType,
                    'transmission': widget.transmission,
                    'price': price,
                    'title': titleController.text,
                    'description': descriptionController.text,
                    'initialData': {
                      ...widget.initialData ?? {},
                      'price': price,
                      'title': titleController.text,
                      'description': descriptionController.text,
                    },
                    'initialImage': widget.initialData?['selectedImage'],
                  },
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