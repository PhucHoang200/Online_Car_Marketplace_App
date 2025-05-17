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
      final fetchedBrands = await _brandRepository.getBrands();
      // Sử dụng Future.microtask để đảm bảo cập nhật UI sau khi build xong.
      Future.microtask(() {
        _brands = fetchedBrands;
        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      // Tương tự, cập nhật trong microtask nếu có lỗi.
      Future.microtask(() {
        _isLoading = false;
        notifyListeners();
      });
      print('Error fetching brands: $e');
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
