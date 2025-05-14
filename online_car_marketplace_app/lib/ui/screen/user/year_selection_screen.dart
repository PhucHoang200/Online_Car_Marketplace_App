// screens/year_selection_screen.dart
import 'package:flutter/material.dart';
import 'condition_origin_screen.dart'; // Import màn hình chọn tình trạng và xuất xứ

class YearSelectionScreen extends StatelessWidget {
  final String brandId;
  final String modelName;

  const YearSelectionScreen({
    super.key,
    required this.brandId,
    required this.modelName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chọn năm sản xuất')),
      body: ListView.builder(
        itemCount: 2025 - 1990 + 1,
        itemBuilder: (context, index) {
          final year = (1990 + index).toString();
          return ListTile(
            title: Text(year),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConditionOriginScreen(
                    brandId: brandId,
                    modelName: modelName,
                    selectedYear: year, // Truyền năm đã chọn
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}