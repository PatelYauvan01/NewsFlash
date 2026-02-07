import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

final authServiceProvider = Provider((ref) => AuthService());

final currentUserProvider = StateNotifierProvider<CurrentUserNotifier, User?>((ref) {
  return CurrentUserNotifier(ref.watch(authServiceProvider));
});

final isLoggedInProvider = FutureProvider<bool>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return await authService.isLoggedIn();
});

class CurrentUserNotifier extends StateNotifier<User?> {
  final AuthService _authService;

  CurrentUserNotifier(this._authService) : super(null) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _authService.getUser();
    state = user;
  }

  Future<bool> login(String email, String password) async {
    final success = await _authService.login(email, password);
    if (success) {
      // Create a temporary user for demo
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        username: email.split('@')[0],
        email: email,
        phone: '1234567890',
        name: email.split('@')[0],
        role: 'Viewer',
      );
      await _authService.saveUser(user);
      state = user;
    }
    return success;
  }

  Future<bool> register(String username, String email, String password, String phone) async {
    final success = await _authService.register(username, email, password, phone);
    if (success) {
      final user = await _authService.getUser();
      state = user;
    }
    return success;
  }

  Future<void> updateUser(User updatedUser) async {
    await _authService.saveUser(updatedUser);
    state = updatedUser;
  }

  Future<void> logout() async {
    await _authService.logout();
    state = null;
  }
}
