import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orders/features/auth/data/auth_repository.dart';
import 'package:orders/features/auth/data/user_model.dart';


class AuthController extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _repo;

  AuthController(this._repo) : super(const AsyncData(null));

  /// 🔐 Login
  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    try {
      await _repo.login(email, password);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e.toString(), st);
    }
  }

  /// 🆕 Register
  Future<void> register(AppUser user, String password) async {
    state = const AsyncLoading();
    try {
      await _repo.register(user, password);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e.toString(), st);
    }
  }

  /// 🚪 Logout
  Future<void> logout() async {
    await _repo.logout();
    
  }

 Future<void> updateProfile(AppUser user) async {
  state = const AsyncLoading();

  try {

    /// 💾 save to Firestore
    await _repo.updateUser(user);

    state = const AsyncData(null);
  } catch (e, st) {
    state = AsyncError(e.toString(), st);
  }
}
}