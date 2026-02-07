import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static const String _userKey = 'current_user';
  static const String _tokenKey = 'auth_token';

  Future<bool> login(String email, String password) async {
    try {
      // Simulate API call - in real app, this would call a backend
      await Future.delayed(const Duration(seconds: 1));
      
      // For demo, accept any email/password combination
      if (email.isEmpty || password.isEmpty) {
        return false;
      }
      
      // Save dummy token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, 'dummy_token_$email');
      
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String username, String email, String password, String phone) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      if (username.isEmpty || email.isEmpty || password.isEmpty || phone.isEmpty) {
        return false;
      }

      // Create user
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        username: username,
        email: email,
        phone: phone,
        name: username,
        role: 'Viewer',
      );

      // Save user and token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(user.toJson()));
      await prefs.setString(_tokenKey, 'dummy_token_$email');
      
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> verifyOTP(String otp) async {
    try {
      // Simulate OTP verification
      await Future.delayed(const Duration(seconds: 1));
      return otp.length == 4; // Simple validation
    } catch (e) {
      return false;
    }
  }

  Future<void> saveUser(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(user.toJson()));
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      if (userJson != null) {
        return User.fromJson(jsonDecode(userJson));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_tokenKey);
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userKey);
    } catch (e) {
      rethrow;
    }
  }
}
