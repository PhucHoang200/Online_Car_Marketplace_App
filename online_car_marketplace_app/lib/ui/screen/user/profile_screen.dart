import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({required this.uid, super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String userId;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    userId = widget.uid;
  }
  // Định nghĩa phương thức getUserData() để lấy dữ liệu người dùng từ Firestore
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      // Giả sử bạn đang dùng Firebase Firestore
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();

      if (userDoc.exists) {
        // Trả về dữ liệu người dùng dưới dạng Map<String, dynamic>
        return userDoc.data();
      } else {
        return null; // Nếu không tìm thấy dữ liệu
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null; // Nếu có lỗi, trả về null
    }
  }

  @override
  @override
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: getUserData(),  // Gọi phương thức getUserData để lấy dữ liệu
      builder: (context, snapshot) {
        // Kiểm tra trạng thái của Future
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        // Kiểm tra nếu có lỗi trong việc lấy dữ liệu
        if (snapshot.hasError) {
          return const Scaffold(body: Center(child: Text("Error loading user data")));
        }

        // Kiểm tra nếu không có dữ liệu hoặc dữ liệu null
        if (!snapshot.hasData || snapshot.data == null) {
          return const Scaffold(body: Center(child: Text("No user data found")));
        }

        final userData = snapshot.data!;

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FB),
          body: Column(
            children: [
              // Thông tin người dùng
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  children: [
                    // Thanh tiêu đề
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Icon(Icons.arrow_back),
                        Icon(Icons.edit, color: Colors.orange),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.teal,
                          backgroundImage: NetworkImage(userData['avatarUrl'] ?? ''),
                        ),
                        const CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.edit, size: 16, color: Colors.orange),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      userData['name'] ?? 'No Name', // Cải thiện khi tên null
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Text("Buyer / Seller", style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 20),
                    // Thông tin liên hệ
                    _buildUserInfoRow(Icons.phone, userData['phone'] ?? 'No phone'),
                    _buildUserInfoRow(Icons.email, userData['email'] ?? 'No email'),
                    _buildUserInfoRow(Icons.home, userData['address'] ?? 'No address'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Danh sách các lựa chọn profile
              Expanded(
                child: ListView(
                  children: [
                    _ProfileItem(icon: Icons.favorite_border, label: "Favorites"),
                    _ProfileItem(icon: Icons.payment, label: "Payments"),
                    _ProfileItem(icon: Icons.share, label: "Tell your friends"),
                    _ProfileItem(icon: Icons.settings, label: "Setting"),
                    _ProfileItem(icon: Icons.logout, label: "Logout"),
                    ListTile(
                      leading: Icon(Icons.lock, color: Colors.orange),
                      title: const Text("Change Password"),
                      onTap: () {
                        // Xử lý chuyển đến màn hình đổi mật khẩu
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }



  Widget _buildUserInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.purple),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

}

// Định nghĩa lại widget _ProfileItem
class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ProfileItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(label),
      onTap: () {
        // Thực hiện hành động khi người dùng nhấn vào item (nếu cần)
      },
    );
  }
}
