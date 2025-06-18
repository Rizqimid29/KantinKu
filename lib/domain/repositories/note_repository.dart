// lib/domain/repositories/note_repository.dart
import '../entities/note.dart';

abstract class NoteRepository {
  Future<void> addNote(Note note, String uid);
  Stream<List<Note>> getNotes(String uid);
  Future<void> deleteNote(String noteId, String uid);

}
