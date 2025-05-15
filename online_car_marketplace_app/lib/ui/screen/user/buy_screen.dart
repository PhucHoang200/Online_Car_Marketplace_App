import 'package:flutter/material.dart';
import 'package:online_car_marketplace_app/ui/screen/user/post_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/post_provider.dart';
import 'package:online_car_marketplace_app/models/post_with_car_and_images.dart';
import 'package:online_car_marketplace_app/providers/brand_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

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
        break;
      case 1:
        break;
      case 2:
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
              // _buildTopBar(),
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

  // Widget _buildTopBar() {
  //   return const Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Icon(Icons.notifications_none),
  //       CircleAvatar(backgroundColor: Colors.grey, radius: 18),
  //     ],
  //   );
  // }

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
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: 90, // Tăng chiều cao để phù hợp với thiết kế
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: brands.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12), // Khoảng cách giữa các logo
            itemBuilder: (context, index) {
              final brand = brands[index];
              final brandName = brand.name.toUpperCase();
              final brandAvatarPath = 'assets/brands/${brand.name.toLowerCase()}.png';

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 60, // Tăng kích thước logo
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white, // Thêm background trắng cho logo
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0), // Thêm padding cho hình ảnh
                      child: Image.asset(
                        brandAvatarPath,
                        fit: BoxFit.contain, // Đảm bảo logo hiển thị đầy đủ
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    brandName,
                    style: const TextStyle(fontSize: 12), // Tăng kích thước chữ
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  Widget _buildPostList(List<PostWithCarAndImages> posts) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final postWithDetails = posts[index];
        final post = postWithDetails.post;
        final car = postWithDetails.car;
        final imageUrl = postWithDetails.imageUrls.isNotEmpty ? postWithDetails.imageUrls.first : null;

        print("--- Bài đăng thứ $index ---");
        print("Tên người bán (BuyScreen): ${postWithDetails.sellerName}");
        print("Số điện thoại người bán (BuyScreen): ${postWithDetails.sellerPhone}");
        print("Địa chỉ người bán (BuyScreen): ${postWithDetails.carLocation}");
        print("User ID của bài đăng (BuyScreen): ${post.userId}");

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 1,
          child: InkWell( // Sử dụng InkWell để có hiệu ứng khi chạm
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostDetailScreen(postWithDetails: postWithDetails),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 12, right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          _truncateText(post.title, 25),
                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.blueAccent),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (car != null)
                        Text(
                          '${car.price.toStringAsFixed(0)} \Triệu',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent, fontSize: 16),
                        ),
                    ],
                  ),
                ),
                if (imageUrl != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12, top: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              imageUrl,
                              width: double.infinity,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _truncateText(post.description, 50),
                                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                if (car != null)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '• ${car.transmission}            • ${car.condition} ',
                                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                      ),
                                      Text(
                                        '• Máy ${car.fuelType}       • ${car.mileage} km',
                                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Divider(height: 1, color: Colors.grey),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(postWithDetails.sellerName ?? 'N/A', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          if (postWithDetails.sellerPhone != null && postWithDetails.sellerPhone!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Row(
                                children: [
                                  const Icon(Icons.phone_outlined, size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(postWithDetails.sellerPhone!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(postWithDetails.carLocation ?? 'N/A', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
