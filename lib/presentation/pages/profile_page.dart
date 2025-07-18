import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../theme/app_theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // --- TAMBAHKAN BAGIAN INI ---
  @override
  void initState() {
    super.initState();
    // Gunakan addPostFrameCallback untuk memastikan context sudah siap
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Ambil UID pengguna yang sedang login dari AuthProvider
      final authProvider = context.read<AuthProvider>();
      final user = authProvider.user;

      // Jika ada user yang login, fetch datanya
      if (user != null) {
        // Panggil fetchUserDetails dari ProfileProvider
        context.read<ProfileProvider>().fetchUserDetails(user.uid);
      }
    });
  }
  // --- BATAS PENAMBAHAN ---


  @override
  Widget build(BuildContext context) {
    // ... sisa kode build method Anda tidak perlu diubah ...
    final authProvider = context.watch<AuthProvider>();
    final profileProvider = context.watch<ProfileProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Profil Saya')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
        profileProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : profileProvider.user == null
            ? Center(
          child: Text(
            profileProvider.error ?? 'Gagal memuat data user',
          ),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppTheme.warmBrown,
              child: Icon(
                Icons.person,
                size: 50,
                color: AppTheme.creamBeige,
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoTile(
              'Nama Lengkap',
              profileProvider.user!.fullName,
            ),
            _buildInfoTile('Username', profileProvider.user!.username),
            _buildInfoTile('Email', profileProvider.user!.email),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                authProvider.signOut();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.tomatoRed,
              ),
              child:
              authProvider.isLoading
                  ? const CircularProgressIndicator(
                color: Colors.white,
              )
                  : const Text('LOGOUT'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.warmBrown,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
    );
  }
}