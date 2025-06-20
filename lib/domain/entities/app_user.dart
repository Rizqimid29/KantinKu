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

  factory AppUser.fromMap(Map<String, dynamic> data, String uid) {
    return AppUser(
      uid: uid,
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      username: data['username'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'email': email, 'fullName': fullName, 'username': username};
  }
}
