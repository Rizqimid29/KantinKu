import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/canteen_repository.dart'; // <-- Import baru

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  final CanteenRepository _canteenRepository; // <-- Tambahkan repository

  // Perbarui konstruktor
  AuthProvider(this._authRepository, this._canteenRepository);

  firebase.User? _user;
  firebase.User? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  // Fungsi baru untuk validasi
  Future<bool> validateUserDocumentExists(String uid) async {
    try {
      await _canteenRepository.getUserDetails(uid);
      return true;
    } catch (e) {
      return false;
    }
  }

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

  Future<bool> signUp(
      String fullName,
      String username,
      String email,
      String password,
      ) async {
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