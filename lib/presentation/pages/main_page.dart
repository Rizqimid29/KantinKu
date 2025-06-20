import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import 'home_page.dart';
import 'popular_canteen_page.dart';
import 'profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // State untuk mengelola proses validasi
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _validateAndFetchData();
  }

  Future<void> _validateAndFetchData() async {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.user;

    if (user == null) {
      if (mounted) await authProvider.signOut();
      return;
    }

    // Lakukan validasi dokumen
    final bool docExists = await authProvider.validateUserDocumentExists(user.uid);

    if (mounted) {
      if (docExists) {
        // Jika valid, ambil data profil sekali di sini
        await context.read<ProfileProvider>().fetchUserDetails(user.uid);
        setState(() {
          _isLoading = false;
        });
      } else {
        // Jika tidak valid, logout
        await authProvider.signOut();
      }
    }
  }

  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    PopularCanteenPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Selama loading, tampilkan indicator
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Jika sudah tidak loading (data valid), tampilkan UI utama
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Kantin Populer',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}