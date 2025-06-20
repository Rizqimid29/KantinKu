import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<void> call(
    String fullName,
    String username,
    String email,
    String password,
  ) {
    return repository.signUp(fullName, username, email, password);
  }
}
