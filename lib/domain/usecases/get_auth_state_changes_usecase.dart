// domain/usecases/get_auth_state_changes_usecase.dart
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GetAuthStateChangesUseCase {
  final AuthRepository _repository;

  GetAuthStateChangesUseCase(this._repository);

  Stream<UserEntity?> call() {
    return _repository.authStateChanges;
  }
}