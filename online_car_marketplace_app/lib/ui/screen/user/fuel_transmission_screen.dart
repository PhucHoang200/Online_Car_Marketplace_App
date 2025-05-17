import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FuelTransmissionScreen extends StatefulWidget {
  final String brandId;
  final String modelName;
  final String selectedYear;
  final String condition;
  final String origin;
  final int mileage;
  final Map<String, dynamic>? initialData;
  final String? initialFuelType;
  final String? initialTransmission;

  const FuelTransmissionScreen({
    super.key,
    required this.brandId,
    required this.modelName,
    required this.selectedYear,
    required this.condition,
    required this.origin,
    required this.mileage,
    this.initialData,
    this.initialFuelType,
    this.initialTransmission,
  });

  @override
  State<FuelTransmissionScreen> createState() => _FuelTransmissionScreenState();
}

class _FuelTransmissionScreenState extends State<FuelTransmissionScreen> {
  String? fuelType;
  String? transmission;

  @override
  void initState() {
    super.initState();
    fuelType = widget.initialFuelType;
    transmission = widget.initialTransmission;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nhiên liệu & Hộp số')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Loại nhiên liệu*', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              value: fuelType,
              items: <String>['Xăng', 'Dầu', 'Điện', 'Hybrid']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    fuelType = value;
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            const Text('Hộp số*', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              value: transmission,
              items: <String>['Số sàn', 'Số tự động', 'Bán tự động']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    transmission = value;
                  });
                }
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: fuelType != null &&
                  transmission != null
                  ? () {
                context.go(
                  '/sell/price-title-description',
                  extra: {
                    'brandId': widget.brandId,
                    'modelName': widget.modelName,
                    'selectedYear': widget.selectedYear,
                    'condition': widget.condition,
                    'origin': widget.origin,
                    'mileage': widget.mileage,
                    'fuelType': fuelType!,
                    'transmission': transmission!,
                    'initialData': {
                      ...widget.initialData ?? {},
                      'fuelType': fuelType,
                      'transmission': transmission,
                    },
                    'initialPrice': widget.initialData?['price'],
                    'initialTitle': widget.initialData?['title'],
                    'initialDescription': widget.initialData?['description'],
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