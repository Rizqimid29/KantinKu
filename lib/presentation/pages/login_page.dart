// lib/presentation/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_manager.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email wajib diisi';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Format email tidak valid';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password wajib diisi';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final authManager = context.read<AuthManager>();

    return Scaffold(
      appBar: AppBar(
        title: Consumer<AuthManager>(
          builder: (ctx, auth, _) =>
              Text(auth.isLogin ? 'Login' : 'Register'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                    labelText: 'Email', border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Password', border: OutlineInputBorder()),
                validator: _validatePassword,
              ),
              const SizedBox(height: 30),
              Consumer<AuthManager>(
                builder: (ctx, auth, child) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (auth.error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(auth.error!)),
                      );
                      auth.clearError();
                    }
                  });

                  return auth.loading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final email = _emailController.text.trim();
                        final password = _passwordController.text.trim();

                        if (auth.isLogin) {
                          await authManager.login(email, password);
                        } else {
                          await authManager.register(email, password);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: Text(
                      auth.isLogin ? 'Login' : 'Register',
                      style: const TextStyle(fontSize: 18),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              Consumer<AuthManager>(builder: (ctx, auth, _) {
                return TextButton(
                  onPressed: authManager.toggleAuthMode,
                  child: Text(
                    auth.isLogin
                        ? 'Belum punya akun? Daftar'
                        : 'Sudah punya akun? Login',
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
