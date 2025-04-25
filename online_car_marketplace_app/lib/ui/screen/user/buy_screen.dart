import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/post_provider.dart';
import 'package:online_car_marketplace_app/models/post_with_car_and_images.dart';
import 'package:online_car_marketplace_app/providers/brand_provider.dart';
import '../../../models/post_model.dart';
import 'package:online_car_marketplace_app/navigation/app_router.dart';
import 'package:online_car_marketplace_app/models/user_model.dart';
import 'package:online_car_marketplace_app/ui/screen/user/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BuyScreen extends StatefulWidget {
  final String uid;
  const BuyScreen({required this.uid, super.key});

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  late String userId;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    userId = widget.uid;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PostProvider>(context, listen: false).fetchPosts();
      Provider.of<BrandProvider>(context, listen: false).fetchBrands();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
      // Đang ở Buy, không cần đi đâu
        break;
      case 1:
      // TODO: Điều hướng sang FavoriteScreen (chưa có thì để sau)
        break;
      case 2:
      // TODO: Điều hướng sang ChatScreen (chưa có thì để sau)
        break;
      case 3:
        final firebaseUser = FirebaseAuth.instance.currentUser;

        // Kiểm tra xem firebaseUser có tồn tại không
        if (firebaseUser != null) {
          final userId = firebaseUser.uid;
          // Điều hướng đến BuyScreen, truyền userId (uid)
          GoRouter.of(context).go('/profile', extra: firebaseUser.uid);
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<PostProvider>(context).posts;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildTopBar(),
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
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildTopBar() {
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
          scrollDirection: Axis.horizontal,
          child: Row(
            children: brands.map((brand) {
              final brandName = brand.name.toUpperCase();
              final brandAvatarPath = 'assets/brands/${brand.name.toLowerCase()}.png';

              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        brandAvatarPath,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(brandName, style: const TextStyle(fontSize: 10)),
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

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.grey,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: 'Buy'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favorite'),
        BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }
}
