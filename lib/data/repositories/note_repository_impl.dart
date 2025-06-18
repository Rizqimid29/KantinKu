// lib/data/repositories/note_repository_impl.dart
import 'package:firebase_database/firebase_database.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';

class NoteRepositoryImpl implements NoteRepository {
  final DatabaseReference _dbRef =
  FirebaseDatabase.instance.ref().child('notes');

  @override
  Future<void> addNote(Note note, String uid) async {
    final ref = _dbRef.child(uid).push();
    await ref.set({
      'title': note.title,
      'content': note.content,
      'createdAt': note.createdAt.millisecondsSinceEpoch,
    });
  }

  @override
  Stream<List<Note>> getNotes(String uid) {
    return _dbRef.child(uid).onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      return data.entries.map((e) {
        final val = e.value as Map<dynamic, dynamic>;
        return Note(
          id: e.key,
          title: val['title'] ?? '',
          content: val['content'] ?? '',
          createdAt:
          DateTime.fromMillisecondsSinceEpoch(val['createdAt']),
        );
      }).toList();
    });
  }

  @override
  Future<void> deleteNote(String noteId, String uid) async {
    return _dbRef.child(uid).child(noteId).remove();
  }
}
