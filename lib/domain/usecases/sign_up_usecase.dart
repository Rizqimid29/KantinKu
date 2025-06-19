// lib/domain/usecases/sign_up_usecase.dart
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;
  SignUpUseCase(this.repository);

  // Terima semua parameter yang dibutuhkan untuk registrasi
  Future<void> call(String fullName, String username, String email, String password) {
    return repository.signUp(fullName, username, email, password);
  }
}