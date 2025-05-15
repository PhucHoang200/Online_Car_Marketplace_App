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
  late String userId;
  int _selectedIndex = 0;
  final carNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<BrandProvider>(context, listen: false).fetchBrands();
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
              // _buildCarNumberInput(),
              // const SizedBox(height: 16),
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              //   onPressed: () {}, //
              //   child: const Text('Get a price'),
              // ),
              // const SizedBox(height: 16),
              // const Center(child: Text("Or", style: TextStyle(fontWeight: FontWeight.bold))),
              // const SizedBox(height: 16),
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

  // Widget _buildCarNumberInput() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text("Enter your car number"),
  //       const SizedBox(height: 6),
  //       TextField(
  //         controller: carNumberController,
  //         decoration: InputDecoration(
  //           hintText: "e.g. DL45 VC 4321",
  //           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  //         ),
  //       ),
  //       const SizedBox(height: 10),
  //       Align(
  //         alignment: Alignment.centerRight,
  //         child: ElevatedButton(
  //           onPressed: () {
  //             // Lấy userId hiện tại (bạn cần có logic để lấy userId này)
  //             final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  //             if (currentUserId != null) {
  //               context.go('/buy', extra: currentUserId);
  //             } else {
  //               // Xử lý trường hợp không có userId (ví dụ: điều hướng mà không có uid)
  //               context.go('/buy', extra: ''); // Hoặc một giá trị mặc định, hoặc xử lý khác
  //             }
  //           },
  //           style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300]),
  //           child: const Text("Switch to Buy", style: TextStyle(color: Colors.black)),
  //         ),
  //       ),
  //     ],
  //   );
  // }

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
                      '/models?brandId=${brand.id.toString()}&brandName=${Uri.encodeComponent(brand.name)}', // Chuyển đổi brand.id thành String
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
