import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:online_car_marketplace_app/providers/user_provider.dart';
import 'package:online_car_marketplace_app/ui/screen/auth/login_user_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
   bool _isRegistrationComplete = false;

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
                  ? _buildVerificationInstructions(userProvider)
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
                  setState(() {
                    _isRegistrationComplete = true;
                  });
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

  Widget _buildVerificationInstructions(UserProvider userProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Xác thực email',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Một link xác thực đã được gửi đến email ${userProvider.emailController.text}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),

        const Card(
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Icon(Icons.email_outlined, size: 50, color: Colors.blue),
                SizedBox(height: 16),
                Text(
                  'Vui lòng kiểm tra hộp thư của bạn và nhấp vào liên kết xác thực để hoàn tất đăng ký.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Nếu không tìm thấy email trong hộp thư đến, vui lòng kiểm tra thư mục spam.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),

        // Check verification button
        ElevatedButton(
          onPressed: userProvider.isLoading
              ? null
              : () async {
            userProvider.setLoading(true); // Gọi setLoading thông qua userProvider
            final success = await userProvider.checkEmailVerification(context);
            userProvider.setLoading(false); // Gọi setLoading thông qua userProvider
            if (success && mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
              );
            } else if (!success && mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(userProvider.errorMessage ?? "Có lỗi xảy ra trong quá trình xác thực.")),
              );
            }
          },
          child: userProvider.isLoading ? const CircularProgressIndicator() : const Text('Tôi đã xác thực email'),
        ),
        const SizedBox(height: 20),

        // Resend verification email link
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Không nhận được email?'),
            TextButton(
              onPressed: userProvider.isLoading
                  ? null
                  : () => userProvider.resendVerificationEmail(context),
              child: const Text('Gửi lại email xác thực'),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Return to login button
        OutlinedButton(
          onPressed: () => context.go('/login'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Quay lại đăng nhập'),
        ),
      ],
    );
  }
}
