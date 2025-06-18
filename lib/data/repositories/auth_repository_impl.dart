// lib/data/repositories/auth_repository_impl.dart
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

// data/repositories/auth_repository_impl.dart
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart'; // UserEntity Anda

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Stream<UserEntity?> get authStateChanges {
    // Mengubah Stream<User> dari Firebase menjadi Stream<UserEntity>

    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      if (firebaseUser == null) {
        return null;
      }
      return UserEntity.fromFirebaseUser(firebaseUser);
    });
  }

  @override
  Future<UserEntity?> signIn(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        return UserEntity.fromFirebaseUser(userCredential.user!);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      // Tangani exception Firebase Auth, mungkin ubah menjadi exception domain
      throw Exception(e.message ?? 'Login failed');
    }
  }

  @override
  Future<UserEntity?> signUp(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        return UserEntity.fromFirebaseUser(userCredential.user!);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Sign up failed');
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}


// class AuthRepositoryImpl implements AuthRepository {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   @override
//   Future<UserEntity?> signIn(String email, String password) async {
//     final cred = await _auth.signInWithEmailAndPassword(
//         email: email, password: password);
//     final user = cred.user;
//     if (user != null) {
//       return UserEntity(uid: user.uid, email: user.email!);
//     }
//     return null;
//   }
//
//   @override
//   Future<UserEntity?> signUp(String email, String password) async {
//     final cred = await _auth.createUserWithEmailAndPassword(
//         email: email, password: password);
//     final user = cred.user;
//     if (user != null) {
//       return UserEntity(uid: user.uid, email: user.email!);
//     }
//     return null;
//   }
//
//   @override
//   Future<void> signOut() async {
//     return _auth.signOut();
//   }
// }
