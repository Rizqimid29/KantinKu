import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/repositories/auth_repository.dart';
import '../providers/auth_provider.dart' as customAuthProvider;
import 'auth_wrapper.dart';
import 'main_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: context.read<AuthRepository>().authStateChanges,
      builder: (context, snapshot) {
        context.read<customAuthProvider.AuthProvider>().updateUser(
          snapshot.data,
        );

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const MainPage();
        } else {
          return const AuthWrapper();
        }
      },
    );
  }
}
