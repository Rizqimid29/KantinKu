// lib/domain/repositories/auth_repository.dart
import '../entities/user.dart';

// abstract class AuthRepository {
//   Future<UserEntity?> signIn(String email, String password);
//   Future<UserEntity?> signUp(String email, String password);
//   Future<void> signOut();
// }


// domain/repositories/auth_repository.dart


abstract class AuthRepository {
  // Metode untuk mendapatkan stream UserEntity
  Stream<UserEntity?> get authStateChanges; // <<< PENTING: Stream UserEntity

  Future<UserEntity?> signIn(String email, String password);
  Future<UserEntity?> signUp(String email, String password);
  Future<void> signOut();
// ... metode otentikasi lainnya
}