import 'package:firebase_auth/firebase_auth.dart' as firebase;
import '../repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<firebase.User?> call(String email, String password) {
    return repository.signIn(email, password);
  }
}
