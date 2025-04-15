import 'package:flutter/material.dart';
import '../models/model_model.dart';
import '../repositories/model_repository.dart';

class ModelProvider with ChangeNotifier {
  final ModelRepository _modelRepository = ModelRepository();
  List<CarModel> _models = [];

  List<CarModel> get models => _models;

  Future<void> fetchModels() async {
    _models = await _modelRepository.getModels();
    notifyListeners();
  }

  Future<void> addModelAutoIncrement(CarModel model) async {
    await _modelRepository.addModelAutoIncrement(model);
    await fetchModels(); // Refresh list
  }

  void clearModels() {
    _models = [];
    notifyListeners();
  }
}
