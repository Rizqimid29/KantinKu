// lib/domain/entities/app_user.dart
class AppUser {
  final String uid;
  final String email;
  final String fullName;
  final String username;

  AppUser({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.username,
  });

  // Factory constructor untuk membuat AppUser dari map (data Firestore)
  factory AppUser.fromMap(Map<String, dynamic> data, String uid) {
    return AppUser(
      uid: uid,
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      username: data['username'] ?? '',
    );
  }

  // Method untuk mengubah AppUser menjadi map (untuk disimpan ke Firestore)
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'fullName': fullName,
      'username': username,
    };
  }
}