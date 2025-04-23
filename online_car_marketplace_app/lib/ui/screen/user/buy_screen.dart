import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/post_provider.dart';
import 'package:online_car_marketplace_app/models/post_with_car_and_images.dart';
import 'package:online_car_marketplace_app/providers/brand_provider.dart';
import '../../../models/post_model.dart';
import 'package:online_car_marketplace_app/navigation/app_router.dart';

class BuyScreen extends StatefulWidget {
  const BuyScreen({super.key});

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<PostProvider>(context, listen: false).fetchPosts();
    Provider.of<BrandProvider>(context, listen: false).fetchBrands();
  }

  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<PostProvider>(context).posts;

    return Scaffold(
      bottomNavigationBar: _buildBottomNavBar(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildTopBar(context),
              const SizedBox(height: 16),
              _buildSearchBar(),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => context.go('/sell'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: const Text('Switch to Sell'),
                ),
              ),
              const SizedBox(height: 10),
              _buildBrandSelector(),
              const SizedBox(height: 16),
              Expanded(child: _buildPostList(posts)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Icon(Icons.notifications_none),
        CircleAvatar(backgroundColor: Colors.grey, radius: 18),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search Cars...",
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  Widget _buildBrandSelector() {
    return Consumer<BrandProvider>(
      builder: (context, brandProvider, child) {
        if (brandProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final brands = brandProvider.brands;

        if (brands.isEmpty) {
          return const Text('No brands found');
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,  // Cho phép cuộn ngang
          child: Row(
            children: brands.map((brand) {
              final brandName = brand.name.toUpperCase();
              // Giả sử bạn đã lưu ảnh trong thư mục assets như 'assets/brands/brand_name.png'
              final brandAvatarPath = 'assets/brands/${brand.name.toLowerCase()}.png';

              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        brandAvatarPath,
                        width: 48,  // Giảm kích thước hình ảnh
                        height: 48,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(brandName, style: const TextStyle(fontSize: 10)),  // Giảm kích thước chữ
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }




  Widget _buildPostList(List<PostWithCarAndImages> posts) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        final car = post.car;
        final imageUrl = post.imageUrls.isNotEmpty ? post.imageUrls.first : null;

        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUrl != null)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(imageUrl, width: double.infinity, height: 180, fit: BoxFit.cover),
                ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.post.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text(post.post.description),
                    if (car != null)
                      Text(
                        "${car.year} • ${car.mileage} km • ${car.fuelType} • ${car.price.toStringAsFixed(0)}\$",
                        style: const TextStyle(color: Colors.grey),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      onTap: (index) {},
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: 'Buy'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favorite'),
        BottomNavigationBarItem(icon: Icon(Icons.help_outline), label: 'Help'),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      ],
    );
  }
}
