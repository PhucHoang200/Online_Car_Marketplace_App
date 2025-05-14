import 'package:flutter/material.dart';
import '../models/car_model.dart';
import '../repositories/car_repository.dart';

class CarProvider with ChangeNotifier {
  final CarRepository _carRepository = CarRepository();
  List<Car> _cars = [];
  bool _isLoading = false;

  List<Car> get cars => _cars;
  bool get isLoading => _isLoading;

  Future<void> fetchCars() async {
    _isLoading = true;
    notifyListeners();

    try {
      _cars = await _carRepository.getCars();
    } catch (e) {
      debugPrint('Lỗi khi lấy danh sách xe: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addCar(Car car) async {
    try {
      await _carRepository.addCarAutoIncrement(car);
      await fetchCars(); // Cập nhật danh sách sau khi thêm
    } catch (e) {
      debugPrint('Lỗi khi thêm xe: $e');
    }
  }

  // Future<void> updateCar(Car car) async {
  //   try {
  //     await _carRepository.updateCar(car);
  //     await fetchCars(); // Cập nhật danh sách sau khi sửa
  //   } catch (e) {
  //     debugPrint('Lỗi khi cập nhật xe: $e');
  //   }
  // }
  //
  // Future<void> deleteCar(int id) async {
  //   try {
  //     await _carRepository.deleteCar(id);
  //     _cars.removeWhere((car) => car.id == id);
  //     notifyListeners();
  //   } catch (e) {
  //     debugPrint('Lỗi khi xóa xe: $e');
  //   }
  // }

  Car? getCarById(int id) {
    return _cars.firstWhere((car) => car.id == id, orElse: () => null as Car);
  }
}
