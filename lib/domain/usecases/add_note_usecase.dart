// lib/domain/usecases/add_note_usecase.dart
import '../entities/note.dart';
import '../repositories/note_repository.dart';

class AddNoteUseCase {
  final NoteRepository repository;
  AddNoteUseCase(this.repository);

  Future<void> call(Note note, String uid) {
    return repository.addNote(note, uid);
  }
}
