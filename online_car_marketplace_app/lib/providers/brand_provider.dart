import 'package:flutter/material.dart';
import '../models/brand_model.dart';
import '../repositories/brand_repository.dart';

class BrandProvider extends ChangeNotifier {
  final BrandRepository _brandRepository = BrandRepository();

  List<Brand> _brands = [];
  List<Brand> get brands => _brands;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchBrands() async {
    _isLoading = true;
    notifyListeners();

    try {
      _brands = await _brandRepository.getBrands();
    } catch (e) {
      print('Error fetching brands: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addBrand(Brand brand) async {
    try {
      await _brandRepository.addBrand(brand);
      _brands.add(brand);
      notifyListeners();
    } catch (e) {
      print('Error adding brand: $e');
    }
  }
}
