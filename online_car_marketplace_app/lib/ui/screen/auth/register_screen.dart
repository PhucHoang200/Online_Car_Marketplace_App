import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:online_car_marketplace_app/ui/screen/auth/register_success_screen.dart';
import 'package:provider/provider.dart';
import 'package:online_car_marketplace_app/providers/user_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
   bool _isRegistrationComplete = false;
   String? _selectedProvince;
   final List<String> _provinces = [
     'An Giang', 'Bà Rịa - Vũng Tàu', 'Bạc Liêu', 'Bắc Giang', 'Bắc Kạn', 'Bắc Ninh',
     'Bến Tre', 'Bình Định', 'Bình Dương', 'Bình Phước', 'Bình Thuận', 'Cà Mau',
     'Cao Bằng', 'Cần Thơ', 'Đà Nẵng', 'Đắk Lắk', 'Đắk Nông', 'Điện Biên',
     'Đồng Nai', 'Đồng Tháp', 'Gia Lai', 'Hà Giang', 'Hà Nam', 'Hà Nội',
     'Hà Tĩnh', 'Hải Dương', 'Hải Phòng', 'Hậu Giang', 'Hòa Bình', 'Hưng Yên',
     'Khánh Hòa', 'Kiên Giang', 'Kon Tum', 'Lai Châu', 'Lạng Sơn', 'Lào Cai',
     'Lâm Đồng', 'Long An', 'Nam Định', 'Nghệ An', 'Ninh Bình', 'Ninh Thuận',
     'Phú Thọ', 'Phú Yên', 'Quảng Bình', 'Quảng Nam', 'Quảng Ngãi', 'Quảng Ninh',
     'Quảng Trị', 'Sóc Trăng', 'Sơn La', 'Tây Ninh', 'Thái Bình', 'Thái Nguyên',
     'Thanh Hóa', 'Thừa Thiên Huế', 'Tiền Giang', 'Trà Vinh', 'Tuyên Quang',
     'Vĩnh Long', 'Vĩnh Phúc', 'Yên Bái', 'Phú Quốc', 'Bắc Giang', 'Bắc Ninh',
   ];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Đăng ký tài khoản'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: _isRegistrationComplete
                  ? const RegisterSuccessScreen()
                  : _buildRegistrationForm(userProvider),
            ),
          ),
        )
    );
  }

  Widget _buildRegistrationForm(UserProvider userProvider) {
    return Form(
      key: userProvider.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Text(
            'Tạo tài khoản mới',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Vui lòng điền đầy đủ thông tin bên dưới',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 30),
          // Name field
          TextFormField(
            controller: userProvider.nameController,
            decoration: InputDecoration(
              labelText: 'Họ và tên',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              prefixIcon: const Icon(Icons.person_outline),
            ),
            validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập họ và tên' : null,
          ),
          const SizedBox(height: 20),
          // Email field
          TextFormField(
            controller: userProvider.emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              prefixIcon: const Icon(Icons.email_outlined),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Vui lòng nhập email';
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Email không hợp lệ';
              return null;
            },
          ),
          const SizedBox(height: 20),
          // Phone number field
          TextFormField(
            controller: userProvider.phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Số điện thoại',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              prefixIcon: const Icon(Icons.phone_outlined),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập số điện thoại';
              }
              if (!RegExp(r'^0\d{9}$').hasMatch(value)) {
                return 'Số điện thoại không hợp lệ (phải bắt đầu bằng 0 và có 10 số)';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          // Address (Province) dropdown
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Địa chỉ',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              prefixIcon: const Icon(Icons.location_on_outlined),
            ),
            value: _selectedProvince,
            items: _provinces.map((province) {
              return DropdownMenuItem<String>(
                value: province,
                child: Text(province),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedProvince = value;
              });
              userProvider.selectedProvince = value;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng chọn địa chỉ';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          // Password field
          TextFormField(
            controller: userProvider.passwordController,
            obscureText: !userProvider.isPasswordVisible,
            decoration: InputDecoration(
              labelText: 'Mật khẩu',
              helperText: 'Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ cái, số và ký tự đặc biệt',
              helperMaxLines: 2,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(userProvider.isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                onPressed: () => userProvider.isPasswordVisible = !userProvider.isPasswordVisible,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Vui lòng nhập mật khẩu';
              if (value.length < 8) return 'Mật khẩu phải có ít nhất 8 ký tự';
              if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$').hasMatch(value)) return 'Mật khẩu phải chứa chữ cái, số và ký tự đặc biệt';
              return null;
            },
          ),
          const SizedBox(height: 20),
          // Confirm Password field
          TextFormField(
            controller: userProvider.confirmPasswordController,
            obscureText: !userProvider.isConfirmPasswordVisible,
            decoration: InputDecoration(
              labelText: 'Xác nhận mật khẩu',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(userProvider.isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
                onPressed: () => userProvider.isConfirmPasswordVisible = !userProvider.isConfirmPasswordVisible,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Vui lòng xác nhận mật khẩu';
              if (value != userProvider.passwordController.text) return 'Mật khẩu không khớp';
              return null;
            },
          ),
          const SizedBox(height: 30),

          // Register button
          ElevatedButton(
            onPressed: userProvider.isLoading
                ? null
                : () async {
              if (userProvider.formKey.currentState!.validate()) {
                final success = await userProvider.registerUser(context);
                if (success && mounted) {
                  // Chuyển sang màn hình RegisterSuccessScreen ngay sau khi đăng ký thành công
                  context.go('/register-success');
                } else if (!success && userProvider.errorMessage != null && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(userProvider.errorMessage!)),
                  );
                }
              }
            },
            child: userProvider.isLoading ? const CircularProgressIndicator() : const Text('Đăng ký'),
          ),
          const SizedBox(height: 20),

          // Login link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Đã có tài khoản?'),
              TextButton(
                onPressed: () => context.go('/login'),
                child: const Text('Đăng nhập'),
              ),
            ],
          ),
        ],
      ),
    );
  }


}
