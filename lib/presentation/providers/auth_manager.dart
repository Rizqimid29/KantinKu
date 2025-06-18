// lib/presentation/providers/auth_manager.dart
import 'package:flutter/material.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';

// Ganti nama class dari AuthProvider menjadi AuthManager
class AuthManager extends ChangeNotifier {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;

  bool _isLogin = true;

  bool get isLogin => _isLogin;

  void toggleAuthMode() {
    _isLogin = !_isLogin;
    notifyListeners();
  }

  bool _loading = false;

  bool get loading => _loading;

  String? _error;

  String? get error => _error;

  // Ganti nama constructor
  AuthManager({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
  });

  Future<void> login(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      print('➡️ AuthManager: Memanggil SignInUseCase...');
      await signInUseCase(email, password);
      print(
        '✅ AuthManager: Login berhasil! (Firebase Auth akan memperbarui status)',
      );
    } catch (e) {
      print('❌ AuthManager: Login gagal: $e');
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
      print('➡️ AuthManager: Loading selesai, notifikasi UI.');
    }
  }

  Future<void> register(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      print('➡️ AuthManager: Memanggil SignUpUseCase...');
      await signUpUseCase(email, password);
      print(
        '✅ AuthManager: Registrasi berhasil! (Firebase Auth akan memperbarui status)',
      );
    } catch (e) {
      print('❌ AuthManager: Registrasi gagal: $e');
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
      print('➡️ AuthManager: Loading selesai, notifikasi UI.');
    }
  }

  Future<void> logout() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      print('➡️ AuthManager: Memanggil SignOutUseCase...');
      await signOutUseCase();
      print(
        '✅ AuthManager: Logout berhasil! (Firebase Auth akan memperbarui status)',
      );
    } catch (e) {
      print('❌ AuthManager: Logout gagal: $e');
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
      print('➡️ AuthManager: Loading selesai, notifikasi UI.');
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
