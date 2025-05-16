import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:online_car_marketplace_app/providers/model_provider.dart';
import 'year_selection_screen.dart';

class ModelListScreen extends StatefulWidget {
  final String brandId;
  final String name;
  final String? selectedModel;

  const ModelListScreen({
    super.key,
    required this.brandId,
    required this.name,
    this.selectedModel,
  });

  @override
  State<ModelListScreen> createState() => _ModelListScreenState();
}

class _ModelListScreenState extends State<ModelListScreen> {
  late Future<void> _fetchFuture;
  String? _highlightedModel;

  @override
  void initState() {
    super.initState();
    // Khởi tạo _fetchFuture bằng future từ ModelProvider
    _fetchFuture = Provider.of<ModelProvider>(context, listen: false)
        .fetchModelsByBrandId(widget.brandId);
  }

  @override
  Widget build(BuildContext context) {
    final modelProvider = Provider.of<ModelProvider>(context);

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context); // Đóng màn hình và không trả về giá trị
            },
          ),
          title: Text('Chọn dòng xe')
      ),
      body: FutureBuilder<void>(
        future: _fetchFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final models = modelProvider.models;
          debugPrint('Models in provider: $models');

          if (models.isEmpty) {
            return const Center(child: Text('No models found.'));
          }

          return ListView.builder(
            itemCount: models.length,
            itemBuilder: (context, index) {
              final model = models[index];
              final isHighlighted = model.name == _highlightedModel;

              return ListTile(
                title: Text(
                  model.name,
                  style: TextStyle(
                    fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                    color: isHighlighted ? Theme.of(context).primaryColor : null,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _highlightedModel = model.name; // Cập nhật model được highlight
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => YearSelectionScreen(
                        brandId: widget.brandId,
                        modelName: model.name,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
