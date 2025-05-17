import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:online_car_marketplace_app/models/favorite_model.dart';
import 'package:online_car_marketplace_app/providers/favorite_provider.dart';
import 'package:online_car_marketplace_app/providers/post_provider.dart';
import 'package:online_car_marketplace_app/models/post_with_car_and_images.dart';
import 'package:online_car_marketplace_app/ui/screen/user/post_detail_screen.dart';
import 'package:online_car_marketplace_app/providers/brand_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_car_marketplace_app/ui/widgets/user/main_bottom_navigation_bar.dart';

class BuyScreen extends StatefulWidget {
  final String uid;
  const BuyScreen({required this.uid, super.key});

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  late String userId;

  @override
  void initState() {
    super.initState();
    userId = widget.uid;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PostProvider>(context, listen: false).fetchPosts();
      Provider.of<BrandProvider>(context, listen: false).fetchBrands();
      final favoriteProvider = Provider.of<FavoriteProvider>(context, listen: false);
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        favoriteProvider.fetchFavoritePosts(currentUser.uid);
      }
    });
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
      bottomNavigationBar: const MainBottomNavigationBar(currentIndex: 0),
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
                    // decoration: BoxDecoration(
                    //   shape: BoxShape.circle,
                    //   color: Colors.white, // Thêm background trắng cho logo
                    //   boxShadow: [
                    //     BoxShadow(
                    //       color: Colors.grey.withOpacity(0.3),
                    //       spreadRadius: 1,
                    //       blurRadius: 3,
                    //       offset: const Offset(0, 2),
                    //     ),
                    //   ],
                    // ),
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
        final favoriteProvider = Provider.of<FavoriteProvider>(context, listen: false);
        final currentUser = FirebaseAuth.instance.currentUser;

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
                          '${car.price.toStringAsFixed(0)} Triệu',
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
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '• ${car.transmission}',
                                              style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                            ),
                                            Text(
                                              '• Máy ${car.fuelType}',
                                              style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '• ${car.condition}',
                                              style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                            ),
                                            Text(
                                              '• ${car.mileage} km',
                                              style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
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
                      Column( // Đổi Row thành Column
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(postWithDetails.sellerName ?? 'N/A', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                          if (postWithDetails.sellerPhone != null && postWithDetails.sellerPhone!.isNotEmpty)
                            Row(
                              children: [
                                const Icon(Icons.phone_outlined, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(postWithDetails.sellerPhone!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(postWithDetails.sellerAddress ?? 'N/A', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                      // Thêm icon yêu thích
                      FutureBuilder<bool>(
                        future: currentUser != null
                            ? favoriteProvider.isPostFavorite(currentUser.uid, post.id)
                            : Future.value(false),
                        builder: (context, snapshot) {
                          final isFavorite = snapshot.data ?? false;
                          return IconButton(
                            icon: Icon(isFavorite ? Icons.bookmark : Icons.bookmark_border),
                            onPressed: () async {
                              if (currentUser != null) {
                                final userId = currentUser.uid;
                                if (isFavorite) {
                                  // Nếu đã là yêu thích, thực hiện xóa
                                  await favoriteProvider.removeFavorite(userId, post.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Đã xóa khỏi mục đã lưu.')),
                                  );
                                } else {
                                  // Nếu chưa là yêu thích, thực hiện thêm
                                  final favorite = Favorite(
                                    id: 0,
                                    userId: userId,
                                    postId: post.id,
                                  );
                                  await favoriteProvider.addFavoriteAutoIncrement(favorite);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Đã thêm vào yêu thích!')),
                                  );
                                }
                                setState(() {}); // Cập nhật giao diện
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Bạn cần đăng nhập để thêm vào yêu thích.')),
                                );
                              }
                            },
                          );
                        },
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

}
