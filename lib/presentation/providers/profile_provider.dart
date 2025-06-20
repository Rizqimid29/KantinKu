import 'package:flutter/material.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/canteen_repository.dart';

class ProfileProvider extends ChangeNotifier {
  final CanteenRepository _canteenRepository;

  ProfileProvider(this._canteenRepository);

  AppUser? _user;
  AppUser? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchUserDetails(String uid) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _user = await _canteenRepository.getUserDetails(uid);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
