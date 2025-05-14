// screens/condition_origin_screen.dart
import 'package:flutter/material.dart';
import 'fuel_transmission_screen.dart'; // Import màn hình chọn nhiên liệu và hộp số

class ConditionOriginScreen extends StatefulWidget {
  final String brandId;
  final String modelName;
  final String selectedYear; // Nhận năm đã chọn

  const ConditionOriginScreen({
    super.key,
    required this.brandId,
    required this.modelName,
    required this.selectedYear,
  });

  @override
  State<ConditionOriginScreen> createState() => _ConditionOriginScreenState();
}

class _ConditionOriginScreenState extends State<ConditionOriginScreen> {
  String? condition;
  String? origin;
  TextEditingController mileageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tình trạng & Xuất xứ')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tình trạng xe*', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Xe cũ'),
                    value: 'Cũ',
                    groupValue: condition,
                    onChanged: (value) {
                      setState(() {
                        condition = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Xe mới'),
                    value: 'Mới',
                    groupValue: condition,
                    onChanged: (value) {
                      setState(() {
                        condition = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            if (condition == 'Cũ')
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: mileageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Số km đã đi*',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            const Text('Xuất xứ*', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Trong nước'),
                    value: 'Trong nước',
                    groupValue: origin,
                    onChanged: (value) {
                      setState(() {
                        origin = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Nhập khẩu'),
                    value: 'Nhập khẩu',
                    groupValue: origin,
                    onChanged: (value) {
                      setState(() {
                        origin = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: condition != null && origin != null
                  ? () {
                int? mileage =
                condition == 'Cũ' ? int.tryParse(mileageController.text) : 0;
                if (condition == 'Cũ' && mileage == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vui lòng nhập số km đã đi.')),
                  );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FuelTransmissionScreen(
                      brandId: widget.brandId,
                      modelName: widget.modelName,
                      selectedYear: widget.selectedYear, // Truyền năm đã chọn
                      condition: condition!,
                      origin: origin!,
                      mileage: mileage ?? 0,
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