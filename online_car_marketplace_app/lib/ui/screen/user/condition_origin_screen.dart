import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConditionOriginScreen extends StatefulWidget {
  final String brandId;
  final String modelName;
  final String selectedYear;
  final Map<String, dynamic>? initialData;
  final String? initialCondition;
  final String? initialOrigin;
  final int? initialMileage;

  const ConditionOriginScreen({
    super.key,
    required this.brandId,
    required this.modelName,
    required this.selectedYear,
    this.initialData,
    this.initialCondition,
    this.initialOrigin,
    this.initialMileage,
  });

  @override
  State<ConditionOriginScreen> createState() => _ConditionOriginScreenState();
}

class _ConditionOriginScreenState extends State<ConditionOriginScreen> {
  String? condition;
  String? origin;
  TextEditingController mileageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    condition = widget.initialCondition;
    origin = widget.initialOrigin;
    if (widget.initialMileage != null && widget.initialMileage != 0) {
      mileageController.text = widget.initialMileage.toString();
    }
  }

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
                      if (value != null) {
                        setState(() {
                          condition = value;
                        });
                      }
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
                      if (value != null) { // Null check
                        setState(() {
                          origin = value; // Correct variable
                        });
                      }
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Nhập khẩu'),
                    value: 'Nhập khẩu',
                    groupValue: origin,
                    onChanged: (value) {
                      if (value != null) { // Null check
                        setState(() {
                          origin = value; // Correct variable
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: condition != null && origin != null
                  ? () {
                String selectedCondition = condition!; // Chỉ ép kiểu khi đã kiểm tra null
                String selectedOrigin = origin!;   // Chỉ ép kiểu khi đã kiểm tra null
                int? mileage = condition == 'Cũ'
                    ? int.tryParse(mileageController.text) : 0;
                if (condition == 'Cũ' && mileage == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vui lòng nhập số km đã đi.')),
                  );
                  return;
                }

                context.go(
                  '/sell/fuel-transmission',
                  extra: {
                    'brandId': widget.brandId,
                    'modelName': widget.modelName,
                    'selectedYear': widget.selectedYear,
                    'condition': selectedCondition,
                    'origin': selectedOrigin,
                    'mileage': mileage ?? 0,
                    'initialData': {
                      ...widget.initialData ?? {},
                      'condition': selectedCondition,
                      'origin': selectedOrigin,
                      'mileage': mileage ?? 0,
                    },
                    'initialFuelType': widget.initialData?['fuelType'],
                    'initialTransmission': widget.initialData?['transmission'],
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