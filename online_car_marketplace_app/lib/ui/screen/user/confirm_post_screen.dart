// screens/confirm_post_screen.dart
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
import 'image_upload_screen.dart';
import 'model_list_screen.dart'; // Import để quay lại màn hình tải ảnh

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

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.selectedImage; // Khởi tạo ảnh từ tham số
    _modelName = widget.modelName;

  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _selectedImage = pickedFile;
    });
  }

  Future<void> _performPost() async {
    print("Bắt đầu hàm _performPost");
    if (_selectedImage == null) {
      print("Lỗi: _selectedImage là null");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn một ảnh.')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
      print("_isUploading được đặt thành true");
    });

    try {
      final storageService = Provider.of<StorageService>(context, listen: false);
      print("Đã lấy storageService");
      _imageUrl = await storageService.uploadImage(_selectedImage!);
      print("_imageUrl sau khi tải lên: $_imageUrl");

      final User? user = FirebaseAuth.instance.currentUser;
      final String? userIdString = user?.uid; // Lấy UID dưới dạng String
      print("Giá trị userIdString: $userIdString");

      if (userIdString == null) {
        print("Lỗi: Không tìm thấy userId của người dùng.");
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
        userId: userIdString,
        modelId: 1,
        fuelType: widget.fuelType,
        transmission: widget.transmission,
        year: int.parse(widget.selectedYear),
        mileage: widget.mileage,
        location: 'Vietnam',
        price: widget.price,
        condition: widget.condition,
        origin: widget.origin,
      );
      print("Đối tượng Car được tạo (ID tạm thời là 0): ${car.toMap()}");

      final carRepository = Provider.of<CarRepository>(context, listen: false);
      print("Đã lấy carRepository");
      final String carIdString = await carRepository.addCarAutoIncrement(car);
      final int carId = int.parse(carIdString);
      print("carId sau khi addCarAutoIncrement: $carId");
      print("widget.title: ${widget.title}");
      print("widget.description: ${widget.description}");

      final post = Post(
        id: 0,
        userId: userIdString,
        carId: carId,
        title: widget.title ?? "",
        description: widget.description ?? "",
        creationDate: Timestamp.now(),
      );
      print("Đối tượng Post được tạo (ID tạm thời là 0): ${post.toMap()}");

      final postRepository = Provider.of<PostRepository>(context, listen: false);
      print("Đã lấy postRepository");
      await postRepository.addPostAutoIncrement(post);
      print("Đã gọi addPostAutoIncrement");

      final imageRepository = Provider.of<ImageRepository>(context, listen: false);
      print("Đã lấy imageRepository");
      final image = ImageModel(
        id: 0,
        carId: carId,
        url: _imageUrl!,
        creationDate: Timestamp.now(),
      );
      print("Đối tượng ImageModel được tạo: ${image.toMap()}");
      await imageRepository.addImageAutoIncrement(image);
      print("Đã gọi addImageAutoIncrement");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng bài thành công!')),
      );
      print("SnackBar thành công được hiển thị");
      context.pop();
    } catch (e, stackTrace) {
      print("Lỗi trong _performPost: $e");
      print("Stack Trace:\n$stackTrace");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã có lỗi xảy ra: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
        print("_isUploading được đặt thành false");
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
        title: const Text('Xem lại & Đăng bài'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, _selectedImage);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Thông tin bài đăng:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildInfoRow('Hãng xe:', widget.brandId, () {
              // TODO: Navigate back to brand selection screen
              print('Chỉnh sửa hãng xe');
              // Ví dụ: Navigator.push(...) đến màn hình chọn hãng xe
            }),
            _buildInfoRow('Dòng xe:', _modelName, () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ModelListScreen(
                    brandId: widget.brandId,
                    name: _modelName,
                    selectedModel: _modelName,
                  ),
                ),
              );
              if (result != null && result is String) {
                setState(() {
                  // Sửa: Cập nhật biến trạng thái _modelName
                  _modelName = result;
                });
              }
            }),
            _buildInfoRow('Năm sản xuất:', widget.selectedYear, () {
              // TODO: Navigate back to year selection screen
              print('Chỉnh sửa năm sản xuất');
              // Ví dụ: Navigator.push(...) đến màn hình chọn năm sản xuất
            }),
            _buildInfoRow('Tình trạng:', widget.condition, () {
              // TODO: Navigate back to condition selection screen
              print('Chỉnh sửa tình trạng');
              // Ví dụ: Navigator.push(...) đến màn hình chọn tình trạng
            }),
            _buildInfoRow('Xuất xứ:', widget.origin, () {
              // TODO: Navigate back to origin selection screen
              print('Chỉnh sửa xuất xứ');
              // Ví dụ: Navigator.push(...) đến màn hình chọn xuất xứ
            }),
            if (widget.condition == 'Cũ')
              _buildInfoRow('Số km đã đi:', '${widget.mileage} km', () {
                // TODO: Navigate back to mileage input screen
                print('Chỉnh sửa số km đã đi');
                // Ví dụ: Navigator.push(...) đến màn hình nhập số km
              }),
            _buildInfoRow('Nhiên liệu:', widget.fuelType, () {
              // TODO: Navigate back to fuel type selection screen
              print('Chỉnh sửa nhiên liệu');
              // Ví dụ: Navigator.push(...) đến màn hình chọn nhiên liệu
            }),
            _buildInfoRow('Hộp số:', widget.transmission, () {
              // TODO: Navigate back to transmission selection screen
              print('Chỉnh sửa hộp số');
              // Ví dụ: Navigator.push(...) đến màn hình chọn hộp số
            }),
            _buildInfoRow('Giá bán:', '${widget.price} TRIỆU VND', () {
              // TODO: Navigate back to price input screen
              print('Chỉnh sửa giá bán');
              // Ví dụ: Navigator.push(...) đến màn hình nhập giá
            }),
            _buildInfoRow('Tiêu đề:', widget.title, () {
              // TODO: Navigate back to title input screen
              print('Chỉnh sửa tiêu đề');
              // Ví dụ: Navigator.push(...) đến màn hình nhập tiêu đề
            }),
            _buildInfoRow('Mô tả:', widget.description, () {
              // TODO: Navigate back to description input screen
              print('Chỉnh sửa mô tả');
              // Ví dụ: Navigator.push(...) đến màn hình nhập mô tả
            }),
            const SizedBox(height: 24),
            const Text('Ảnh đã chọn:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageUploadScreen(
                      brandId: widget.brandId,
                      modelName: widget.modelName,
                      selectedYear: widget.selectedYear,
                      condition: widget.condition,
                      origin: widget.origin,
                      mileage: widget.mileage,
                      fuelType: widget.fuelType,
                      transmission: widget.transmission,
                      price: widget.price,
                      title: widget.title,
                      description: widget.description,
                      initialImage: _selectedImage,
                    ),
                  ),
                );
              },
              child: Center(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _selectedImage != null
                      ? Image.file(File(_selectedImage!.path), fit: BoxFit.cover)
                      : const Center(
                      child: Icon(Icons.add_a_photo,
                          size: 48, color: Colors.grey)),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: !_isUploading ? _performPost : null,
                child: _isUploading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
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