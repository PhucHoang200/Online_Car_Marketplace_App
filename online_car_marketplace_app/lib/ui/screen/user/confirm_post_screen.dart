import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_car_marketplace_app/models/car_model.dart';
import 'package:online_car_marketplace_app/models/post_model.dart';
import 'package:online_car_marketplace_app/models/image_model.dart';
import 'package:online_car_marketplace_app/repositories/post_repository.dart';
import 'package:online_car_marketplace_app/repositories/car_repository.dart';
import 'package:online_car_marketplace_app/services/storage_service.dart';
import 'package:online_car_marketplace_app/repositories/image_repository.dart';

class ConfirmPostScreen extends StatefulWidget {
  final String brandId;
  final String modelName;
  final String selectedYear;
  final String condition;
  final String origin;
  final int mileage;
  final String fuelType;
  final String transmission;
  final double price;
  final String title;
  final String description;
  final XFile? selectedImage;

  const ConfirmPostScreen({
    super.key,
    required this.brandId,
    required this.modelName,
    required this.selectedYear,
    required this.condition,
    required this.origin,
    required this.mileage,
    required this.fuelType,
    required this.transmission,
    required this.price,
    required this.title,
    required this.description,
    this.selectedImage,
  });

  @override
  State<ConfirmPostScreen> createState() => _ConfirmPostScreenState();
}

class _ConfirmPostScreenState extends State<ConfirmPostScreen> {
  XFile? _selectedImage;
  String? _imageUrl;
  bool _isUploading = false;
  late String _modelName;
  late String _selectedYear;
  late String _condition;
  late String _origin;
  late int _mileage;
  late String _fuelType;
  late String _transmission;
  late double _price;
  late String _title;
  late String _description;
  late String _brandId;

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.selectedImage;
    _brandId = widget.brandId;
    _modelName = widget.modelName;
    _selectedYear = widget.selectedYear;
    _condition = widget.condition;
    _origin = widget.origin;
    _mileage = widget.mileage;
    _fuelType = widget.fuelType;
    _transmission = widget.transmission;
    _price = widget.price;
    _title = widget.title;
    _description = widget.description;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _performPost() async {
    if (_isUploading) return;
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn một ảnh.')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final storageService = Provider.of<StorageService>(context, listen: false);
      _imageUrl = await storageService.uploadImage(_selectedImage!);

      final User? user = FirebaseAuth.instance.currentUser;
      final String? userId = user?.uid;

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bạn cần đăng nhập để đăng bài.')),
        );
        setState(() {
          _isUploading = false;
        });
        return;
      }

      final car = Car(
        id: 0,
        userId: userId,
        modelId: 1,
        fuelType: _fuelType,
        transmission: _transmission,
        year: int.parse(_selectedYear),
        mileage: _mileage,
        location: 'Vietnam',
        price: _price,
        condition: _condition,
        origin: _origin,
      );

      final carRepository = Provider.of<CarRepository>(context, listen: false);
      final String carIdString = await carRepository.addCarAutoIncrement(car);
      final int carId = int.parse(carIdString);

      final post = Post(
        id: 0,
        userId: userId,
        carId: carId,
        title: _title,
        description: _description,
        creationDate: Timestamp.now(),
      );
      final postRepository = Provider.of<PostRepository>(context, listen: false);
      await postRepository.addPostAutoIncrement(post);

      final imageRepository = Provider.of<ImageRepository>(context, listen: false);
      final image = ImageModel(
        id: 0,
        carId: carId,
        url: _imageUrl!,
        creationDate: Timestamp.now(),
      );
      await imageRepository.addImageAutoIncrement(image);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng bài thành công!')),
      );
      setState(() {});
      context.go('/sell');

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã có lỗi xảy ra: $e')),
      );
      setState(() {
        _isUploading = false;
      });
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Widget _buildDetailCard({required String title, required String value, VoidCallback? onTap, Widget? trailing}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                  const SizedBox(height: 4.0),
                  Text(value, style: const TextStyle(fontSize: 14.0, color: Colors.black87)),
                ],
              ),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xác nhận bài đăng'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_selectedImage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.file(
                      File(_selectedImage!.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            _buildDetailCard(
              title: 'Hãng xe',
              value: widget.brandId,
              onTap: () {}, // Logic vẫn giữ nguyên ở các màn hình khác
            ),
            _buildDetailCard(
              title: 'Dòng xe',
              value: _modelName,
              onTap: () {
                context.push('/sell/models', extra: {
                  'brandId': _brandId,
                  'brandName': _modelName,
                  'selectedModel': _modelName,
                  'initialData': {
                    'selectedYear': _selectedYear,
                    'condition': _condition,
                    'origin': _origin,
                    'mileage': _mileage,
                    'fuelType': _fuelType,
                    'transmission': _transmission,
                    'price': _price,
                    'title': _title,
                    'description': _description,
                    'selectedImage': _selectedImage,
                  }
                });
              },
            ),
            _buildDetailCard(
              title: 'Năm sản xuất',
              value: _selectedYear,
              onTap: () {
                context.push('/sell/year', extra: {
                  'brandId': _brandId,
                  'modelName': _modelName,
                  'initialYear': _selectedYear,
                  'initialData': {
                    'condition': _condition,
                    'origin': _origin,
                    'mileage': _mileage,
                    'fuelType': _fuelType,
                    'transmission': _transmission,
                    'price': _price,
                    'title': _title,
                    'description': _description,
                    'selectedImage': _selectedImage,
                  }
                });
              },
            ),
            _buildDetailCard(
              title: 'Tình trạng',
              value: _condition,
              onTap: () {
                context.push('/sell/condition-origin', extra: {
                  'brandId': _brandId,
                  'modelName': _modelName,
                  'selectedYear': _selectedYear,
                  'initialCondition': _condition,
                  'initialOrigin': _origin,
                  'initialMileage': _mileage,
                  'initialData': {
                    'fuelType': _fuelType,
                    'transmission': _transmission,
                    'price': _price,
                    'title': _title,
                    'description': _description,
                    'selectedImage': _selectedImage,
                  }
                });
              },
            ),
            _buildDetailCard(
              title: 'Xuất xứ',
              value: _origin,
              onTap: () {
                context.push('/sell/condition-origin', extra: {
                  'brandId': _brandId,
                  'modelName': _modelName,
                  'selectedYear': _selectedYear,
                  'initialCondition': _condition,
                  'initialOrigin': _origin,
                  'initialMileage': _mileage,
                  'initialData': {
                    'fuelType': _fuelType,
                    'transmission': _transmission,
                    'price': _price,
                    'title': _title,
                    'description': _description,
                    'selectedImage': _selectedImage,
                  }
                });
              },
            ),
            if (_condition == 'Cũ')
              _buildDetailCard(
                title: 'Số km đã đi',
                value: '$_mileage km',
                onTap: () {
                  context.push('/sell/condition-origin', extra: {
                    'brandId': _brandId,
                    'modelName': _modelName,
                    'selectedYear': _selectedYear,
                    'initialCondition': _condition,
                    'initialOrigin': _origin,
                    'initialMileage': _mileage,
                    'initialData': {
                      'fuelType': _fuelType,
                      'transmission': _transmission,
                      'price': _price,
                      'title': _title,
                      'description': _description,
                      'selectedImage': _selectedImage,
                    }
                  });
                },
              ),
            _buildDetailCard(
              title: 'Nhiên liệu',
              value: _fuelType,
              onTap: () {
                context.push('/sell/fuel-transmission', extra: {
                  'brandId': _brandId,
                  'modelName': _modelName,
                  'selectedYear': _selectedYear,
                  'condition': _condition,
                  'origin': _origin,
                  'mileage': _mileage,
                  'initialFuelType': _fuelType,
                  'initialTransmission': _transmission,
                  'initialData': {
                    'price': _price,
                    'title': _title,
                    'description': _description,
                    'selectedImage': _selectedImage,
                  }
                });
              },
            ),
            _buildDetailCard(
              title: 'Hộp số',
              value: _transmission,
              onTap: () {
                context.push('/sell/fuel-transmission', extra: {
                  'brandId': _brandId,
                  'modelName': _modelName,
                  'selectedYear': _selectedYear,
                  'condition': _condition,
                  'origin': _origin,
                  'mileage': _mileage,
                  'initialFuelType': _fuelType,
                  'initialTransmission': _transmission,
                  'initialData': {
                    'price': _price,
                    'title': _title,
                    'description': _description,
                    'selectedImage': _selectedImage,
                  }
                });
              },
            ),
            _buildDetailCard(
              title: 'Giá bán',
              value: '$_price TRIỆU VND',
              onTap: () {
                context.push('/sell/price-title-description', extra: {
                  'brandId': _brandId,
                  'modelName': _modelName,
                  'selectedYear': _selectedYear,
                  'condition': _condition,
                  'origin': _origin,
                  'mileage': _mileage,
                  'fuelType': _fuelType,
                  'transmission': _transmission,
                  'initialPrice': _price,
                  'initialData': {
                    'title': _title,
                    'description': _description,
                    'selectedImage': _selectedImage,
                  }
                });
              },
            ),
            _buildDetailCard(
              title: 'Tiêu đề',
              value: _title,
              onTap: () {
                context.push('/sell/price-title-description', extra: {
                  'brandId': _brandId,
                  'modelName': _modelName,
                  'selectedYear': _selectedYear,
                  'condition': _condition,
                  'origin': _origin,
                  'mileage': _mileage,
                  'fuelType': _fuelType,
                  'transmission': _transmission,
                  'initialPrice': _price,
                  'initialTitle': _title,
                  'initialData': {
                    'description': _description,
                    'selectedImage': _selectedImage,
                  }
                });
              },
            ),
            _buildDetailCard(
              title: 'Mô tả',
              value: _description,
              onTap: () {
                context.push('/sell/price-title-description', extra: {
                  'brandId': _brandId,
                  'modelName': _modelName,
                  'selectedYear': _selectedYear,
                  'condition': _condition,
                  'origin': _origin,
                  'mileage': _mileage,
                  'fuelType': _fuelType,
                  'transmission': _transmission,
                  'initialPrice': _price,
                  'initialTitle': _title,
                  'initialDescription': _description,
                  'initialData': {
                    'selectedImage': _selectedImage,
                  }
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: !_isUploading ? _performPost : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                backgroundColor: Theme.of(context).primaryColor,
                textStyle: const TextStyle(fontSize: 16.0),
              ),
              child: _isUploading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
              )
                  : const Text('Đăng bài', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}