
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

// Import Entities
import 'domain/entities/note.dart';
import 'domain/entities/user.dart';

// Import Repositories
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/note_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/note_repository.dart';

// Import Use Cases
import 'domain/usecases/sign_in_usecase.dart';
import 'domain/usecases/sign_up_usecase.dart';
import 'domain/usecases/sign_out_usecase.dart';
import 'domain/usecases/get_notes_usecase.dart';
import 'domain/usecases/add_note_usecase.dart';
import 'domain/usecases/delete_note_usecase.dart';
import 'domain/usecases/get_auth_state_changes_usecase.dart';

// Import Providers
import 'presentation/providers/auth_manager.dart';
import 'presentation/providers/note_provider.dart';

// Import Pages
import 'presentation/pages/login_page.dart';
import 'presentation/pages/notes_page.dart';

// GlobalKey tidak lagi dibutuhkan di sini karena SnackBar dipindahkan ke halaman
// final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final AuthRepository authRepo = AuthRepositoryImpl();
  final NoteRepository noteRepo = NoteRepositoryImpl();

  runApp(
    MultiProvider(
      providers: [
        // Repositories
        Provider<AuthRepository>(create: (_) => authRepo),
        Provider<NoteRepository>(create: (_) => noteRepo),

        // Use Cases
        Provider(create: (ctx) => SignInUseCase(ctx.read<AuthRepository>())),
        Provider(create: (ctx) => SignUpUseCase(ctx.read<AuthRepository>())),
        Provider(create: (ctx) => SignOutUseCase(ctx.read<AuthRepository>())),
        Provider(create: (ctx) => GetNotesUseCase(ctx.read<NoteRepository>())),
        Provider(create: (ctx) => AddNoteUseCase(ctx.read<NoteRepository>())),
        Provider(create: (ctx) => DeleteNoteUseCase(ctx.read<NoteRepository>())),
        Provider(create: (ctx) => GetAuthStateChangesUseCase(ctx.read<AuthRepository>())),

        // AuthManager
        ChangeNotifierProvider<AuthManager>(
          create: (ctx) => AuthManager(
            signInUseCase: ctx.read<SignInUseCase>(),
            signUpUseCase: ctx.read<SignUpUseCase>(),
            signOutUseCase: ctx.read<SignOutUseCase>(),
          ),
        ),

        // StreamProvider untuk status autentikasi pengguna
        StreamProvider<UserEntity?>(
          create: (ctx) => ctx.read<GetAuthStateChangesUseCase>()(),
          initialData: null,
          lazy: false,
        ),

        // NoteProvider
        ChangeNotifierProvider<NoteProvider>(
          create: (ctx) => NoteProvider(
            addNoteUseCase: ctx.read<AddNoteUseCase>(),
            deleteNoteUseCase: ctx.read<DeleteNoteUseCase>(),
            getNotesUseCase: ctx.read<GetNotesUseCase>(),
          ),
        ),

        // StreamProvider untuk List<Note>
        StreamProvider<List<Note>>(
          create: (ctx) {
            return ctx.read<NoteProvider>().notesStream;
          },
          initialData: const [],
          lazy: false,
        ),
      ],
      child: Consumer<UserEntity?>(
        builder: (context, currentUser, _) {
          final noteProvider = context.read<NoteProvider>();

          // --- LOGIKA SNACKBAR DIHAPUS DARI SINI ---
          // if (authManager.error != null) { ... }
          // if (noteProvider.error != null) { ... }

          // --- Memuat atau Mereset Catatan berdasarkan Status Autentikasi ---
          if (currentUser != null) {
            noteProvider.loadNotes(currentUser.uid);
          } else {
            noteProvider.reset();
          }

          // --- Penentuan Halaman Utama ---
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            // scaffoldMessengerKey tidak lagi diperlukan di sini
            home: currentUser == null
                ? const LoginPage()
                : NotesPage(uid: currentUser.uid),
          );
        },
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}



