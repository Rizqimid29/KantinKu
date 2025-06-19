import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';

class ProfileProvider extends ChangeNotifier {
  final UserRepository _userRepository;

  ProfileProvider(this._userRepository);

  bool isLoading = false;
  String? error;
  UserEntity? user;

  Future<void> fetchUserDetails(String userId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      user = await _userRepository.getUserById(userId);
    } catch (e) {
      error = 'Gagal memuat data user: ${e.toString()}';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
