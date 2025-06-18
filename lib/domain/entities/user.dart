// domain/entities/user.dart
import 'package:firebase_auth/firebase_auth.dart';

class UserEntity {
  final String uid;
  final String email;
  final String? displayName;
  // Tambahkan properti lain yang relevan dari domain Anda

  UserEntity({
    required this.uid,
    required this.email,
    this.displayName,
  });

  // Contoh metode untuk konversi dari Firebase User ke UserEntity
  // Ini bisa juga diletakkan di data/models/user_model.dart
  factory UserEntity.fromFirebaseUser(User user) {
    return UserEntity(
      uid: user.uid,
      email: user.email ?? 'no-email@example.com', // Firebase user.email bisa null
      displayName: user.displayName,
    );
  }
}


