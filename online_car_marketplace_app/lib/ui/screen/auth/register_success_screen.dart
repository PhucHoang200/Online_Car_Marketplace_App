import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:online_car_marketplace_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class RegisterSuccessScreen extends StatefulWidget {
  const RegisterSuccessScreen({super.key});

  @override
  State<RegisterSuccessScreen> createState() => _RegisterSuccessScreenState();
}

class _RegisterSuccessScreenState extends State<RegisterSuccessScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // _timer?.cancel();
    super.dispose();
  }

  Future<void> _checkVerificationAndNavigate(BuildContext context, UserProvider userProvider) async {
    final verificationResult = await userProvider.checkEmailVerification(context);
    if (verificationResult['success']) {
      if (mounted) {
        context.go('/login');
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(verificationResult['message'])),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Ngăn người dùng quay lại màn hình đăng ký
        title: const Text('Đăng ký thành công'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            Text(
              'Chúc mừng bạn đã đăng ký thành công!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.green),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Một email xác thực đã được gửi đến hộp thư của bạn.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Vui lòng kiểm tra email và nhấp vào liên kết để xác thực tài khoản của bạn.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                await _checkVerificationAndNavigate(context, userProvider);
              },
              child: const Text('Tiếp tục đăng nhập'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: userProvider.isLoadingResendEmail
                  ? null
                  : () async {
                await userProvider.resendVerificationEmail(context);
                if (userProvider.resendEmailMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(userProvider.resendEmailMessage!)),
                  );
                }
              },
              child: userProvider.isLoadingResendEmail
                  ? const CircularProgressIndicator()
                  : const Text('Không nhận được email? Gửi lại'),
            ),
          ],
        ),
      ),
    );
  }
}