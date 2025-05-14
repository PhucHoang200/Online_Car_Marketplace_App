import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:online_car_marketplace_app/providers/model_provider.dart';
import 'year_selection_screen.dart';

class ModelListScreen extends StatefulWidget {
  final String brandId;
  final String name;

  const ModelListScreen({
    super.key,
    required this.brandId,
    required this.name,
  });

  @override
  State<ModelListScreen> createState() => _ModelListScreenState();
}

class _ModelListScreenState extends State<ModelListScreen> {
  late Future<void> _fetchFuture;

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
      appBar: AppBar(title: Text('Models of ${widget.name}')),
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
        return ListTile(
          title: Text(model.name),
          onTap: () {
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
