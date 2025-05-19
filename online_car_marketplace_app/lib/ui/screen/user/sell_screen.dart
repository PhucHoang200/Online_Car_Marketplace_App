import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:online_car_marketplace_app/providers/brand_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';


import '../../widgets/user/sell_bottom_navigation_bar.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  late String userId;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const SellBottomNavigationBar(currentIndex: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              _buildBanner(),
              const SizedBox(height: 30),
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
              const SizedBox(height: 30),
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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16.0, bottom: 8.0),
              child: Text(
                'Chọn hãng xe để đăng tin',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true, // Quan trọng để sử dụng bên trong Column/ListView
              physics: const NeverScrollableScrollPhysics(), // Ngăn cuộn bên trong GridView
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Hiển thị 3 logo trên một hàng (điều chỉnh theo nhu cầu)
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                childAspectRatio: 1.0, // Tỷ lệ khung hình vuông cho mỗi item
              ),
              itemCount: brands.length,
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
                      '/sell/models',
                      extra: {
                        'brandId': brand.id.toString(), // Truyền brand.id dưới dạng String qua extra
                        'brandName': brand.name,
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 0.5,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 50, // Kích thước logo
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              brandAvatarPath,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          brandName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 10),
                          overflow: TextOverflow.ellipsis, // Xử lý tên quá dài
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

}
