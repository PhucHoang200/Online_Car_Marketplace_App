// screens/fuel_transmission_screen.dart
import 'package:flutter/material.dart';
import 'price_title_description_screen.dart';

class FuelTransmissionScreen extends StatefulWidget {
  final String brandId;
  final String modelName;
  final String selectedYear;
  final String condition;
  final String origin;
  final int mileage;

  const FuelTransmissionScreen({
    super.key,
    required this.brandId,
    required this.modelName,
    required this.selectedYear,
    required this.condition,
    required this.origin,
    required this.mileage,
  });

  @override
  State<FuelTransmissionScreen> createState() => _FuelTransmissionScreenState();
}

class _FuelTransmissionScreenState extends State<FuelTransmissionScreen> {
  String? fuelType;
  String? transmission;

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
                setState(() {
                  fuelType = value;
                });
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
                setState(() {
                  transmission = value;
                });
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: fuelType != null && transmission != null
                  ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PriceTitleDescriptionScreen(
                      brandId: widget.brandId,
                      modelName: widget.modelName,
                      selectedYear: widget.selectedYear,
                      condition: widget.condition,
                      origin: widget.origin,
                      mileage: widget.mileage,
                      fuelType: fuelType!,
                      transmission: transmission!,
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