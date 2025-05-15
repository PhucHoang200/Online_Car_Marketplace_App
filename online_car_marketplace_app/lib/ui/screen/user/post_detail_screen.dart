import 'package:flutter/material.dart';
import 'package:online_car_marketplace_app/models/post_with_car_and_images.dart';

class PostDetailScreen extends StatelessWidget {
  final PostWithCarAndImages postWithDetails;

  const PostDetailScreen({super.key, required this.postWithDetails});

  @override
  Widget build(BuildContext context) {
    final post = postWithDetails.post;
    final car = postWithDetails.car;
    final imageUrl = postWithDetails.imageUrls.isNotEmpty ? postWithDetails.imageUrls.first : null;
    final sellerName = postWithDetails.sellerName ?? 'N/A';
    final sellerPhone = postWithDetails.sellerPhone ?? 'N/A';
    final carLocation = postWithDetails.carLocation ?? 'N/A';

    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              Image.network(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 16),
            Text(
              post.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (car != null)
              Text(
                'Giá: ${car.price.toStringAsFixed(0)} Triệu đồng',
                style: const TextStyle(fontSize: 18, color: Colors.redAccent),
              ),
            const SizedBox(height: 16),
            const Text(
              'Mô tả:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              post.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Thông tin chi tiết:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (car != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Năm sản xuất: ${car.year}', style: const TextStyle(fontSize: 16)),
                  Text('Odo: ${car.mileage} km', style: const TextStyle(fontSize: 16)),
                  Text('Loại nhiên liệu: ${car.fuelType}', style: const TextStyle(fontSize: 16)),
                  Text('Loại xe: ${car.modelId}', style: const TextStyle(fontSize: 16)),
                ],
              ),
            const SizedBox(height: 16),
            const Text(
              'Thông tin người bán:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Tên: $sellerName', style: const TextStyle(fontSize: 16)),
            Text('Số điện thoại: $sellerPhone', style: const TextStyle(fontSize: 16)),
            Text('Địa chỉ: $carLocation', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}