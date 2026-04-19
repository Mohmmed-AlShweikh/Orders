import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orders/features/auth/provider/auth_controller.dart';
import '../data/auth_repository.dart';
import '../data/user_model.dart';

/// 📦 Repository
final authRepoProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// 👤 Current User Stream
final authUserProvider = StreamProvider<AppUser?>((ref) {
  final repo = ref.watch(authRepoProvider);
  return repo.userStream();
});

/// ⚡ Controller (Actions فقط)
final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  final repo = ref.watch(authRepoProvider);
  return AuthController(repo);
});



