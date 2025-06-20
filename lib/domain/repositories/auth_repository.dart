import 'package:firebase_auth/firebase_auth.dart' as firebase;

abstract class AuthRepository {
  Stream<firebase.User?> get authStateChanges;
  Future<firebase.User?> signIn(String email, String password);
  Future<void> signUp(
    String fullName,
    String username,
    String email,
    String password,
  );
  Future<void> signOut();
}
