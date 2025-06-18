// lib/domain/usecases/delete_note_usecase.dart
import '../repositories/note_repository.dart';

class DeleteNoteUseCase {
  final NoteRepository repository;
  DeleteNoteUseCase(this.repository);

  Future<void> call(String noteId, String uid) {
    return repository.deleteNote(noteId, uid);
  }
}
