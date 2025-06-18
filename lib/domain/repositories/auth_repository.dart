// lib/domain/repositories/auth_repository.dart
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import '../entities/app_user.dart';

abstract class AuthRepository {
  Stream<firebase.User?> get authStateChanges;
  Future<firebase.User?> signIn(String email, String password);
  // Ubah return type signUp untuk mengembalikan AppUser
  Future<void> signUp(String fullName, String username, String email, String password);
  Future<void> signOut();
}