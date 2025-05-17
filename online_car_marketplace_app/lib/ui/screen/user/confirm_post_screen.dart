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
  bool _postSuccessful = false;
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile;
      });
    }
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
        id: 0, // Temporary ID, will be replaced by Firestore
        userId: userId,
        modelId: 1, // You might have a different way to get this
        fuelType: _fuelType,
        transmission: _transmission,
        year: int.parse(_selectedYear),
        mileage: _mileage,
        location:
        'Vietnam', //  You might want to allow users to select this.
        price: _price,
        condition: _condition,
        origin: _origin,
      );

      final carRepository = Provider.of<CarRepository>(context, listen: false);
      final String carIdString = await carRepository.addCarAutoIncrement(car);
      final int carId =
      int.parse(carIdString); // Parse the ID as integer.

      final post = Post(
        id: 0, // Temporary ID
        userId: userId,
        carId: carId,
        title: _title,
        description: _description,
        creationDate: Timestamp.now(),
      );
      final postRepository =
      Provider.of<PostRepository>(context, listen: false);
      await postRepository.addPostAutoIncrement(post);

      final imageRepository =
      Provider.of<ImageRepository>(context, listen: false);
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
      setState(() {
        _postSuccessful = true;
      }); //set post successful
      context.go('/sell'); // Navigate on success

    } catch (e) {
      // Log the error!  This is crucial for debugging.
      print("Error posting: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã có lỗi xảy ra: $e')),
      );
      setState(() {
        _isUploading = false;
        //_errorMessage = e.toString(); // Optionally set error message
      });
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Widget _buildInfoRow(String label, String value, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: const TextStyle(color: Colors.black87),
              ),
            ),
            if (onTap != null)
              const Icon(Icons.edit, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(), // Sử dụng context.pop() để quay lại
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Hãng xe:', widget.brandId, () {}),
            _buildInfoRow('Dòng xe:', _modelName, () {
              context.push('/sell/models', extra: {
                'brandId': _brandId,
                'brandName': _modelName, // Correct key name
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
            }),
            _buildInfoRow('Năm sản xuất:', _selectedYear, () {
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
            }),
            _buildInfoRow('Tình trạng:', _condition, () {
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
            }),
            _buildInfoRow('Xuất xứ:', _origin, () {
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
            }),
            if (_condition == 'Cũ')
              _buildInfoRow('Số km đã đi:', '$_mileage km', () {
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
              }),
            _buildInfoRow('Nhiên liệu:', _fuelType, () {
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
            }),
            _buildInfoRow('Hộp số:', _transmission, () {
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
            }),
            _buildInfoRow('Giá bán:', '$_price TRIỆU VND', () {
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
            }),
            _buildInfoRow('Tiêu đề:', _title, () {
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
            }),
            _buildInfoRow('Mô tả:', _description, () {
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
            }),
            const SizedBox(height: 24),
            _buildInfoRow(
                'Ảnh đã chọn:',
                _selectedImage != null ? 'Đã chọn' : 'Chưa chọn', () {
              context.push('/sell/image-upload', extra: {
                'brandId': _brandId,
                'modelName': _modelName,
                'selectedYear': _selectedYear,
                'condition': _condition,
                'origin': _origin,
                'mileage': _mileage,
                'fuelType': _fuelType,
                'transmission': _transmission,
                'price': _price,
                'title': _title,
                'description': _description,
                'initialImage': _selectedImage,
              });
            }),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed:
                !_isUploading ? _performPost : null, // Disable during upload
                child: _isUploading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                      strokeWidth:
                      2), // Show indicator during upload
                )
                    : const Text('Đăng bài'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}