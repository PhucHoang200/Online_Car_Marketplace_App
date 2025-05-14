// screens/confirm_post_screen.dart
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
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
  });

  @override
  State<ConfirmPostScreen> createState() => _ConfirmPostScreenState();
}

class _ConfirmPostScreenState extends State<ConfirmPostScreen> {
  XFile? _selectedImage;
  String? _imageUrl;
  bool _isUploading = false;

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
        // Không gán ID ở đây, để CarRepository xử lý
        id: 0, // Giá trị tạm thời, sẽ được ghi đè bởi CarRepository
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
        // Không gán ID ở đây, để PostRepository xử lý
        id: 0, // Giá trị tạm thời, sẽ được ghi đè bởi PostRepository
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
        // Không gán ID ở đây, để Firestore tự động tạo (nếu cần) hoặc ImageRepository xử lý
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

    } catch (e, stackTrace) { // Thêm tham số stackTrace
      print("Lỗi trong _performPost: $e");
      print("Stack Trace:\n$stackTrace"); // In ra stack trace
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

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Xác nhận thông tin'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Hãng xe:', widget.brandId),
                _buildInfoRow('Dòng xe:', widget.modelName),
                _buildInfoRow('Năm sản xuất:', widget.selectedYear),
                _buildInfoRow('Tình trạng:', widget.condition),
                _buildInfoRow('Xuất xứ:', widget.origin),
                if (widget.condition == 'Cũ') _buildInfoRow('Số km đã đi:', '${widget.mileage} km'),
                _buildInfoRow('Nhiên liệu:', widget.fuelType),
                _buildInfoRow('Hộp số:', widget.transmission),
                _buildInfoRow('Giá bán:', '${widget.price} TRIỆU VND'),
                _buildInfoRow('Tiêu đề:', widget.title),
                _buildInfoRow('Mô tả:', widget.description),
                const SizedBox(height: 16),
                if (_selectedImage != null)
                  Image.file(
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    File(_selectedImage!.path),
                  )
                else
                  const Text('Chưa chọn ảnh'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Đóng'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Đăng bài'),
              onPressed: !_isUploading ? _performPost : null, // Gọi _performPost khi nhấn đăng bài
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chọn ảnh & Đăng bài')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Chọn ảnh cho bài đăng:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _selectedImage != null
                      ? Image.file(File(_selectedImage!.path), fit: BoxFit.cover)
                      : const Center(child: Icon(Icons.add_a_photo, size: 48, color: Colors.grey)),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _showConfirmationDialog(context);
                },
                child: const Text('Xem lại thông tin & Đăng bài'),
              ),
            ),
            if (_isUploading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}