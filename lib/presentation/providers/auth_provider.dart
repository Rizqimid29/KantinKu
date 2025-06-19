// lib/presentation/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import '../../domain/repositories/auth_repository.dart';

// GANTI NAMA CLASS DI SINI
class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  // GANTI NAMA CONSTRUCTOR DI SINI
  AuthViewModel(this._authRepository);

  firebase.User? _user;
  firebase.User? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  void updateUser(firebase.User? newUser) {
    if (_user != newUser) {
      _user = newUser;
      notifyListeners();
    }
  }

  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _authRepository.signIn(email, password);
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signUp(String fullName, String username, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _authRepository.signUp(fullName, username, email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();
    await _authRepository.signOut();
    _user = null;
    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _error = null;
  }
}