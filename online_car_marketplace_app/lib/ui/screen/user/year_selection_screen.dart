// screens/year_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class YearSelectionScreen extends StatefulWidget {
  final String brandId;
  final String modelName;
  final String? initialYear;
  final Map<String, dynamic>? initialData;

  const YearSelectionScreen({
    super.key,
    required this.brandId,
    required this.modelName,
    this.initialYear,
    this.initialData,
  });

  @override
  State<YearSelectionScreen> createState() => _YearSelectionScreenState();
}

class _YearSelectionScreenState extends State<YearSelectionScreen> {
  String? _selectedYear;
  final List<String> _years = List.generate(50, (index) => (DateTime.now().year - index).toString());

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialYear;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn năm sản xuất'),
      ),
      body: ListView.builder(
        itemCount: _years.length,
        itemBuilder: (context, index) {
          final year = _years[index];
          final isSelected = year == _selectedYear;
          return ListTile(
            title: Text(
              year,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Theme.of(context).primaryColor : null,
              ),
            ),
            onTap: () {
              setState(() {
                _selectedYear = year;
              });
              // Navigate to the next screen, passing all data
              context.push(
                '/sell/condition-origin',
                extra: {
                  'brandId': widget.brandId,
                  'modelName': widget.modelName,
                  'selectedYear': year,
                  'initialData': widget.initialData,
                },
              );
            },
          );
        },
      ),
    );
  }
}