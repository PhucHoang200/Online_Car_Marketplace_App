import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isRegistrationComplete = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng ký tài khoản'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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
      ),
    );
  }

  Widget _buildRegistrationForm(UserProvider userProvider) {
    return Form(
      key: _formKey,
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
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Họ và tên',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              prefixIcon: const Icon(Icons.person_outline),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập họ và tên';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Email field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              prefixIcon: const Icon(Icons.email_outlined),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Email không hợp lệ';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Phone field
          TextFormField(
            controller: _phoneController,
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
              if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                return 'Số điện thoại không hợp lệ';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Address field
          TextFormField(
            controller: _addressController,
            decoration: InputDecoration(
              labelText: 'Địa chỉ',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              prefixIcon: const Icon(Icons.home_outlined),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập địa chỉ';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Password field
          TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              labelText: 'Mật khẩu',
              helperText: 'Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ cái, số và ký tự đặc biệt',
              helperMaxLines: 2,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập mật khẩu';
              }
              if (value.length < 8) {
                return 'Mật khẩu phải có ít nhất 8 ký tự';
              }
              if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$').hasMatch(value)) {
                return 'Mật khẩu phải chứa chữ cái, số và ký tự đặc biệt';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Confirm Password field
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: !_isConfirmPasswordVisible,
            decoration: InputDecoration(
              labelText: 'Xác nhận mật khẩu',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng xác nhận mật khẩu';
              }
              if (value != _passwordController.text) {
                return 'Mật khẩu không khớp';
              }
              return null;
            },
          ),
          const SizedBox(height: 30),

          // Error message if any
          if (userProvider.errorMessage != null)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                userProvider.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          const SizedBox(height: 20),

          // Register button
          ElevatedButton(
            onPressed: userProvider.isLoading
                ? null
                : () => _register(context),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: userProvider.isLoading
                ? const CircularProgressIndicator()
                : const Text(
              'Đăng ký',
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 20),

          // Login link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Đã có tài khoản?'),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
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
        // Header
        Text(
          'Xác thực email',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Một link xác thực đã được gửi đến email ${_emailController.text}',
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

        // Error message if any
        if (userProvider.errorMessage != null)
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              userProvider.errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        const SizedBox(height: 30),

        // Check verification button
        ElevatedButton(
          onPressed: userProvider.isLoading
              ? null
              : () => _checkEmailVerification(context),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: userProvider.isLoading
              ? const CircularProgressIndicator()
              : const Text(
            'Tôi đã xác thực email',
            style: TextStyle(fontSize: 16),
          ),
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
                  : () => _resendVerificationEmail(context),
              child: const Text('Gửi lại email xác thực'),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Return to login button
        OutlinedButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen())
            );
          },
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

  Future<void> _register(BuildContext context) async {
    // Clear any previous errors
    Provider.of<UserProvider>(context, listen: false).clearError();

    if (_formKey.currentState!.validate()) {
      final success = await Provider.of<UserProvider>(
        context,
        listen: false,
      ).register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text.trim(),
        address: _addressController.text.trim(),
      );

      if (success && mounted) {
        setState(() {
          _isRegistrationComplete = true;
        });
      }
    }
  }

  Future<void> _checkEmailVerification(BuildContext context) async {
    // Clear any previous errors
    Provider.of<UserProvider>(context, listen: false).clearError();

    final success = await Provider.of<UserProvider>(
      context,
      listen: false,
    ).checkEmailVerification();

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng ký thành công')),
      );

      // Navigate back to login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  Future<void> _resendVerificationEmail(BuildContext context) async {
    // Clear any previous errors
    Provider.of<UserProvider>(context, listen: false).clearError();

    // Resend verification email
    final success = await Provider.of<UserProvider>(
      context,
      listen: false,
    ).resendVerificationEmail();

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email xác thực đã được gửi lại')),
      );
    }
  }
}
