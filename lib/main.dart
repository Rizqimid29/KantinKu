import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'presentation/providers/search_provider.dart';

import 'firebase_options.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/canteen_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/canteen_repository.dart';
import 'presentation/pages/onboarding_page.dart';

import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/home_provider.dart';
import 'presentation/providers/profile_provider.dart';
import 'presentation/theme/app_theme.dart';
import 'presentation/providers/popular_product_provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthRepository authRepository = AuthRepositoryImpl();
    final CanteenRepository canteenRepository = CanteenRepositoryImpl();

    return MultiProvider(
      providers: [
        Provider<AuthRepository>(create: (_) => authRepository),
        Provider<CanteenRepository>(create: (_) => canteenRepository),
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider(
            ctx.read<AuthRepository>(),
            ctx.read<CanteenRepository>(), // <-- Perubahan di sini
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ProfileProvider(ctx.read<CanteenRepository>()),
        ),
        ChangeNotifierProvider(
          create: (ctx) => HomeProvider(ctx.read<CanteenRepository>()),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SearchProvider(ctx.read<CanteenRepository>()),
        ),
        ChangeNotifierProvider(
          create: (ctx) => PopularProductProvider(ctx.read<CanteenRepository>()),
        ),
      ],
      child: MaterialApp(
        title: 'KantinKU',
        theme: AppTheme.theme,
        debugShowCheckedModeBanner: false,
        home: const OnboardingPage(),
      ),
    );
  }
}