import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:online_car_marketplace_app/providers/user_provider.dart';
import 'package:online_car_marketplace_app/models/user_model.dart';
import 'package:online_car_marketplace_app/services/storage_service.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({required this.uid, super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String userId;
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _nameController;
  TextEditingController? _phoneController;
  TextEditingController? _emailController;
  TextEditingController? _addressController;
  String? _avatarUrl;
  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  final StorageService _storageService = StorageService(); // Sử dụng StorageService

  @override
  void initState() {
    super.initState();
    userId = widget.uid;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await _getUserData();
    if (userData != null) {
      setState(() {
        _nameController = TextEditingController(text: userData['name'] ?? '');
        _phoneController = TextEditingController(text: userData['phone'] ?? '');
        _emailController = TextEditingController(text: userData['email'] ?? '');
        _addressController = TextEditingController(text: userData['address'] ?? '');
        _avatarUrl = userData['avatarUrl'];
      });
    }
  }

  Future<Map<String, dynamic>?> _getUserData() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: widget.uid)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data();
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = pickedFile;
    });
  }

  Future<void> _saveChanges(UserProvider userProvider) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isEditing = false;
      });
      String? newAvatarUrl = _avatarUrl;
      if (_selectedImage != null) {
        try {
          newAvatarUrl = await _storageService.uploadImage(_selectedImage!);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error uploading image: $e')),
          );
          return;
        }
      }

      final updatedUser = User(
        id: 0,
        uid: widget.uid,
        name: _nameController!.text.trim(),
        email: _emailController!.text.trim(),
        phone: _phoneController!.text.trim(),
        address: _addressController!.text.trim(),
        avatarUrl: newAvatarUrl,
        roleId: 1,
        status: 'Hoạt động',
        creationDate: Timestamp.now(),
        updateDate: Timestamp.now(),
      );

      await userProvider.updateUserProfile(context, updatedUser);
      _loadUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return FutureBuilder<Map<String, dynamic>?>(
      future: _getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasError) {
          return const Scaffold(body: Center(child: Text("Error loading user data")));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Scaffold(body: Center(child: Text("No user data found")));
        }

        final userData = snapshot.data!;

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FB),
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/buy', extra: userId),
            ),
            title: const Text('Profile'),
            actions: [
              IconButton(
                icon: Icon(_isEditing ? Icons.save : Icons.edit, color: Colors.orange),
                onPressed: () {
                  if (_isEditing) {
                    _saveChanges(userProvider);
                  } else {
                    setState(() {
                      _isEditing = true;
                    });
                  }
                },
              ),
            ],
          ),
          body: Column(
            children: [
              // Thông tin người dùng (có thể chỉnh sửa)
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Thanh tiêu đề (chỉ nút edit/save)
                      const SizedBox(height: 40), // Khoảng trống cho nút back
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.teal,
                            backgroundImage: _selectedImage != null
                                ? FileImage(File(_selectedImage!.path)) as ImageProvider<Object>?
                                : NetworkImage(_avatarUrl ?? ''),
                          ),
                          if (_isEditing)
                            GestureDetector(
                              onTap: _pickImage,
                              child: const CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                child: Icon(Icons.camera_alt, size: 20, color: Colors.orange),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _isEditing
                          ? TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
                      )
                          : Text(
                        userData['name'] ?? 'No Name',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      _isEditing
                          ? TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(labelText: 'Phone'),
                        keyboardType: TextInputType.phone,
                        validator: (value) => value == null || value.isEmpty ? 'Please enter your phone' : null,
                      )
                          : _buildUserInfoRow(Icons.phone, userData['phone'] ?? 'No phone'),
                      const SizedBox(height: 12),
                      _isEditing
                          ? TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter your email';
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Please enter a valid email';
                          return null;
                        },
                      )
                          : _buildUserInfoRow(Icons.email, userData['email'] ?? 'No email'),
                      const SizedBox(height: 12),
                      _isEditing
                          ? TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(labelText: 'Address'),
                        maxLines: 2,
                        validator: (value) => value == null || value.isEmpty ? 'Please enter your address' : null,
                      )
                          : _buildUserInfoRow(Icons.home, userData['address'] ?? 'No address'),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Danh sách các lựa chọn profile (không chỉnh sửa)
              Expanded(
                child: ListView(
                  children: [
                    const _ProfileItem(icon: Icons.favorite_border, label: "Favorites"),
                    const _ProfileItem(icon: Icons.payment, label: "Payments"),
                    const _ProfileItem(icon: Icons.share, label: "Tell your friends"),
                    const _ProfileItem(icon: Icons.settings, label: "Setting"),
                    const _ProfileItem(icon: Icons.logout, label: "Logout"),
                    ListTile(
                      leading: const Icon(Icons.lock, color: Colors.orange),
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
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.purple),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

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