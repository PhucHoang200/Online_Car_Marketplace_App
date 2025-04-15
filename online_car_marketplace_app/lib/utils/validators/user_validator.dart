import 'dart:convert';
import 'package:crypto/crypto.dart';

class UserValidator {
  static String validateName(String name) {
    if (name.isEmpty || name.length < 1 || name.length > 50) {
      throw Exception('Tên tài khoản không hợp lệ');
    }
    return name;
  }

  static String validateAndHashPassword(String password) {
    if (password.length < 8 ||
        !RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$')
            .hasMatch(password)) {
      throw Exception(
          'Mật khẩu phải có ít nhất 8 ký tự và chứa cả chữ cái, số và ký tự đặc biệt');
    }
    return _hashPassword(password);
  }


  static String validateStatus(String status) {
    const allowedStatuses = ['Hoạt động', 'Khóa'];
    if (!allowedStatuses.contains(status)) {
      throw Exception('Trạng thái không hợp lệ');
    }
    return status;
  }

  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }
}
