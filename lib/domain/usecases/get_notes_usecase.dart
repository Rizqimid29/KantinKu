// lib/domain/usecases/get_notes_usecase.dart
import '../entities/note.dart';
import '../repositories/note_repository.dart';

class GetNotesUseCase {
  final NoteRepository repository;
  GetNotesUseCase(this.repository);

  Stream<List<Note>> call(String uid) {
    return repository.getNotes(uid);
  }
}
