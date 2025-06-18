// lib/presentation/providers/note_provider.dart
import 'package:flutter/material.dart';
import 'dart:async'; // Pastikan ini di-import untuk StreamController dan StreamSubscription

import '../../domain/usecases/add_note_usecase.dart';
import '../../domain/usecases/delete_note_usecase.dart';
import '../../domain/usecases/get_notes_usecase.dart'; // Import GetNotesUseCase
import '../../domain/entities/note.dart';

class NoteProvider extends ChangeNotifier {
  final AddNoteUseCase addNoteUseCase;
  final DeleteNoteUseCase deleteNoteUseCase;
  final GetNotesUseCase getNotesUseCase; // Tambahkan ini

  List<Note> _notes = [];
  // Getter untuk notes saat ini, berguna jika widget perlu akses langsung.
  List<Note> get notes => _notes;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  // StreamController untuk memancarkan notes ke UI.
  // StreamProvider di main.dart akan mendengarkan ini.
  final StreamController<List<Note>> _notesStreamController =
  StreamController<List<Note>>.broadcast(); // .broadcast() agar bisa didengarkan banyak listener
  Stream<List<Note>> get notesStream => _notesStreamController.stream;

  // Subscription untuk mengelola stream dari use case.
  // Penting untuk di-cancel agar tidak ada memory leak.
  StreamSubscription<List<Note>>? _notesSubscription;

  // Constructor NoteProvider
  NoteProvider({
    required this.addNoteUseCase,
    required this.deleteNoteUseCase,
    required this.getNotesUseCase, // Inisialisasi GetNotesUseCase
  });

  // Metode untuk memuat catatan berdasarkan UID pengguna.
  // Ini akan dipanggil dari main.dart saat status autentikasi berubah.
  Future<void> loadNotes(String uid) async {
    _loading = true;
    _error = null;
    notifyListeners(); // Beri tahu listener bahwa loading dimulai

    // Batalkan subscription sebelumnya untuk menghindari duplikasi listener
    // jika loadNotes dipanggil berkali-kali (misalnya saat user login/logout berulang).
    _notesSubscription?.cancel();

    try {
      // Dapatkan stream notes dari use case dan dengarkan perubahannya.
      _notesSubscription = getNotesUseCase(uid).listen(
            (newNotes) {
          _notes = newNotes; // Perbarui list notes internal
          _notesStreamController.add(newNotes); // Pancarkan notes baru ke stream utama
          _loading = false; // Setelah notes pertama kali dimuat, loading selesai
          notifyListeners(); // Beri tahu widget yang mendengarkan NoteProvider lokal
        },
        onError: (e) {
          _error = e.toString();
          _loading = false;
          _notesStreamController.addError(e); // Pancarkan error ke stream utama
          notifyListeners(); // Beri tahu widget yang mendengarkan NoteProvider lokal
        },
        onDone: () {
          _loading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      _error = e.toString();
      _loading = false;
      _notesStreamController.addError(e); // Pancarkan error ke stream utama
      notifyListeners();
    }
  }

  // Metode untuk menambah catatan
  Future<void> addNote(String title, String content, String uid) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final note = Note(
        id: '',
        title: title,
        content: content,
        createdAt: DateTime.now(),
      );
      await addNoteUseCase(note, uid);
      // Catatan akan otomatis diperbarui oleh _notesSubscription
      // karena use case memicu pembaruan di repository yang memancarkan stream Firestore.
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // Metode untuk menghapus catatan
  Future<void> deleteNote(String id, String uid) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await deleteNoteUseCase(id, uid);
      // Catatan akan otomatis diperbarui oleh _notesSubscription
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // Metode untuk membersihkan error (biasanya setelah SnackBar ditampilkan)
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Metode untuk mereset state NoteProvider (misalnya saat user logout)
  void reset() {
    _notes = [];
    _notesStreamController.add([]); // Pancarkan list kosong
    _notesSubscription?.cancel(); // Batalkan subscription yang aktif
    _loading = false;
    _error = null;
    notifyListeners(); // Beri tahu listener bahwa state sudah direset
  }

  // Penting: Tutup StreamController dan batalkan subscription saat NoteProvider di-dispose
  @override
  void dispose() {
    _notesSubscription?.cancel(); // Pastikan subscription dibatalkan
    _notesStreamController.close(); // Tutup stream controller
    super.dispose();
  }
}


// // lib/presentation/providers/note_provider.dart
// import 'package:flutter/material.dart';
// import '../../domain/entities/note.dart';
// import '../../domain/usecases/get_notes_usecase.dart';
// import '../../domain/usecases/add_note_usecase.dart';
// import '../../domain/usecases/delete_note_usecase.dart';
//
// class NoteProvider extends ChangeNotifier {
//   final GetNotesUseCase getNotesUseCase;
//   final AddNoteUseCase addNoteUseCase;
//   final DeleteNoteUseCase deleteNoteUseCase;
//
//   List<Note> _notes = [];
//   List<Note> get notes => _notes;
//
//
//   bool _loading = false;
//   bool get loading => _loading;
//
//   String? _error;
//   String? get error => _error;
//
//   // bool _initialized = false;
//
//   NoteProvider({
//     required this.getNotesUseCase,
//     required this.addNoteUseCase,
//     required this.deleteNoteUseCase,
//   });
//
//   void clearError() {
//     _error = null;
//     notifyListeners();
//   }
//
//   void loadNotes(String uid) {
//     // if (_initialized) return;
//     // _initialized = true;
//
//     _loading = true;
//     _error = null;
//     notifyListeners();
//
//     getNotesUseCase(uid).listen(
//           (list) {
//         _notes = list;
//         _loading = false;
//         notifyListeners();
//       },
//       onError: (e) {
//         _loading = false;
//         _error = e.toString();
//         notifyListeners();
//       },
//     );
//   }
//
//   Future<void> addNote(String title, String content, String uid) async {
//     _loading = true;
//     _error = null;
//     notifyListeners();
//
//     try {
//       final note = Note(
//         id: '',
//         title: title,
//         content: content,
//         createdAt: DateTime.now(),
//       );
//       await addNoteUseCase(note, uid);
//     } catch (e) {
//       _error = e.toString();
//     } finally {
//       _loading = false;
//       notifyListeners();
//     }
//   }
//
//   Future<void> deleteNote(String noteId, String uid) async {
//     try {
//       await deleteNoteUseCase(noteId, uid);
//     } catch (e) {
//       _error = e.toString();
//       notifyListeners();
//     }
//   }
//
//   void reset() {
//     // _initialized = false;
//     _notes = [];
//     _error = null;
//     _loading = false;
//     notifyListeners();
//   }
//
//
// }
//


// // lib/presentation/providers/note_provider.dart
// import 'package:flutter/material.dart';
// import '../../domain/entities/note.dart';
// // Hapus GetNotesUseCase karena StreamProvider<List<Note>> yang akan menggunakannya
// // import '../../domain/usecases/get_notes_usecase.dart';
// import '../../domain/usecases/add_note_usecase.dart';
// import '../../domain/usecases/delete_note_usecase.dart';
//
// class NoteProvider extends ChangeNotifier {
//   // Hapus GetNotesUseCase dari dependensi provider ini
//   // final GetNotesUseCase getNotesUseCase;
//   final AddNoteUseCase addNoteUseCase;
//   final DeleteNoteUseCase deleteNoteUseCase;
//
//   // Hapus _notes karena StreamProvider<List<Note>> yang akan menyediakannya
//   // List<Note> _notes = [];
//   // List<Note> get notes => _notes;
//
//   bool _loading = false;
//   bool get loading => _loading;
//
//   String? _error;
//   String? get error => _error;
//
//   NoteProvider({
//     // Hapus getNotesUseCase dari required params
//     // required this.getNotesUseCase,
//     required this.addNoteUseCase,
//     required this.deleteNoteUseCase,
//   });
//
//   void clearError() {
//     _error = null;
//     notifyListeners();
//   }
//
//   // Hapus metode loadNotes sepenuhnya
//   // void loadNotes(String uid) { ... }
//
//   Future<void> addNote(String title, String content, String uid) async {
//     _loading = true;
//     _error = null;
//     notifyListeners(); // Beritahu UI bahwa loading dimulai
//
//     try {
//       final note = Note(
//         id: '', // ID akan di-generate oleh database
//         title: title,
//         content: content,
//         createdAt: DateTime.now(),
//       );
//       await addNoteUseCase(note, uid);
//       // Data notes akan otomatis di-refresh oleh StreamProvider<List<Note>>
//       // karena addNoteUseCase akan menulis ke database dan database memicu stream.
//     } catch (e) {
//       _error = e.toString();
//     } finally {
//       _loading = false;
//       notifyListeners(); // Beritahu UI bahwa loading selesai (dan mungkin ada error)
//     }
//   }
//
//   Future<void> deleteNote(String noteId, String uid) async {
//     _loading = true; // Tambahkan loading untuk delete juga
//     _error = null;
//     notifyListeners();
//
//     try {
//       await deleteNoteUseCase(noteId, uid);
//       // Data notes akan otomatis di-refresh oleh StreamProvider<List<Note>>
//       // karena deleteNoteUseCase akan menulis ke database dan database memicu stream.
//     } catch (e) {
//       _error = e.toString();
//     } finally {
//       _loading = false; // Akhiri loading
//       notifyListeners();
//     }
//   }
//
//   void reset() {
//     // Tidak perlu reset _notes karena itu ada di StreamProvider
//     _error = null;
//     _loading = false;
//     notifyListeners();
//   }
// }