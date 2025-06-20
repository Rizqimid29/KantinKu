import 'package:firebase_auth/firebase_auth.dart' as firebase;
import '../repositories/auth_repository.dart';

class GetAuthStateChangesUseCase {
  final AuthRepository _repository;

  GetAuthStateChangesUseCase(this._repository);

  Stream<firebase.User?> call() {
    return _repository.authStateChanges;
  }
}
