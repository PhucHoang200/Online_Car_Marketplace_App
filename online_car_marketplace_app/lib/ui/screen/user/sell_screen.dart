import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:online_car_marketplace_app/providers/brand_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  final carNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<BrandProvider>(context, listen: false).fetchBrands();
  }

  @override
  void dispose() {
    carNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomNavBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              _buildBanner(),
              const SizedBox(height: 16),
              _buildCarNumberInput(),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () {}, // TODO: handle price fetch
                child: const Text('Get a price'),
              ),
              const SizedBox(height: 16),
              const Center(child: Text("Or", style: TextStyle(fontWeight: FontWeight.bold))),
              const SizedBox(height: 16),
              _buildBrandSelector(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Image.asset('assets/images/car mask.png', height: 180, width: double.infinity, fit: BoxFit.cover),
          const Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Sell your car at", style: TextStyle(color: Colors.white, fontSize: 18)),
                Text("Best price", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarNumberInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Enter your car number"),
        const SizedBox(height: 6),
        TextField(
          controller: carNumberController,
          decoration: InputDecoration(
            hintText: "e.g. DL45 VC 4321",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () {
              // Lấy userId hiện tại (bạn cần có logic để lấy userId này)
              final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
              if (currentUserId != null) {
                context.go('/buy', extra: currentUserId);
              } else {
                // Xử lý trường hợp không có userId (ví dụ: điều hướng mà không có uid)
                context.go('/buy', extra: ''); // Hoặc một giá trị mặc định, hoặc xử lý khác
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300]),
            child: const Text("Switch to Buy", style: TextStyle(color: Colors.black)),
          ),
        ),
      ],
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
          return const Center(child: Text('No brands available'));
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

              return GestureDetector(
                onTap: () {
                  debugPrint('Brand clicked: $brandName');
                  debugPrint('Brand ID: ${brand.id}, Type: ${brand.id.runtimeType}');
                  debugPrint('Brand Name: $brandName');

                  context.push(
                    '/models?brandId=${brand.id.toString()}&brandName=${Uri.encodeComponent(brand.name)}', // Chuyển đổi brand.id thành String
                  );
                },
                child: Column(
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
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: 0,
      onTap: (index) {},
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.sell), label: 'Sell'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favorite'),
        BottomNavigationBarItem(icon: Icon(Icons.help_outline), label: 'Help'),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      ],
    );
  }
}
