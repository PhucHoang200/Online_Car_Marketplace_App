import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Provider để quản lý trạng thái
class LandingProvider with ChangeNotifier {
  void onGetStarted() {
    // Xử lý khi nhấn nút "Get Started"
    print("Get Started button pressed");
    // Bạn có thể thêm logic điều hướng hoặc xử lý tại đây
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LandingProvider(),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Hình nền
            Image.asset(
              'assets/images/anhxe.jpg', // Thay bằng URL hình ảnh thực tế
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.3),
              colorBlendMode: BlendMode.darken,
            ),
            // Nội dung
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  const Text(
                    'Your Trusted Marketplace\nfor Second-Hand Cars',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Discover the BEST DEALS\non Pre-Owned Cars',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Consumer<LandingProvider>(
                    builder: (context, provider, child) {
                      return ElevatedButton(
                        onPressed: () {
                          provider.onGetStarted();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow[700],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'GET STARTED',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Cấu hình main.dart để chạy ứng dụng
void main() {
  runApp(
    MaterialApp(
      home: LandingPage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    ),
  );
}