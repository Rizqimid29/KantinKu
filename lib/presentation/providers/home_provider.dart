// lib/main.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/canteen_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/canteen_repository.dart';
import 'presentation/pages/auth_wrapper.dart';
import 'presentation/pages/main_page.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/home_provider.dart';
import 'presentation/providers/profile_provider.dart';
import 'presentation/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // REPOSITORIES
        Provider<AuthRepository>(create: (_) => AuthRepositoryImpl()),
        Provider<CanteenRepository>(create: (_) => CanteenRepositoryImpl()),

        // PROVIDERS / STATE MANAGEMENT
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider(ctx.read<AuthRepository>()),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ProfileProvider(ctx.read<CanteenRepository>()),
        ),
        ChangeNotifierProvider(
          create: (ctx) => HomeProvider(ctx.read<CanteenRepository>()),
        ),
      ],
      child: MaterialApp(
        title: 'KantinKU',
        theme: AppTheme.theme,
        debugShowCheckedModeBanner: false,
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dengarkan perubahan status autentikasi
    return StreamBuilder<User?>(
      stream: context.read<AuthRepository>().authStateChanges,
      builder: (context, snapshot) {
        // Update user state di AuthProvider
        context.read<AuthProvider>().updateUser(snapshot.data);

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasData) {
          // Jika user sudah login, arahkan ke MainPage
          return const MainPage();
        } else {
          // Jika belum login, arahkan ke halaman autentikasi
          return const AuthWrapper();
        }
      },
    );
  }
}