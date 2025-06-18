
// lib/presentation/pages/notes_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/note.dart'; // Pastikan Note entity diimpor
import '../providers/note_provider.dart'; // Pastikan NoteProvider diimpor
import '../providers/auth_manager.dart'; // Pastikan AuthManager diimpor
import 'add_note_dialog.dart'; // Pastikan AddNoteDialog diimpor

class NotesPage extends StatelessWidget { // Ini adalah StatelessWidget, jadi tidak perlu State
  final String uid; // UID masih diperlukan untuk operasi add/delete di NoteProvider
  const NotesPage({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 1. Mengambil daftar catatan dari StreamProvider<List<Note>>.
    // context.watch akan merebuild widget ini setiap kali ada perubahan pada list notes.
    final List<Note> notes = context.watch<List<Note>>();

    // 2. Mengambil instance NoteProvider untuk memicu aksi (add/delete).
    // Menggunakan context.read karena kita hanya memanggil method, bukan mendengarkan perubahan state untuk rebuild.
    final noteActionProvider = context.read<NoteProvider>();

    // 3. Mengambil instance AuthManager untuk aksi logout.
    final authManager = context.read<AuthManager>();

    // Logika SnackBar untuk menampilkan error sudah dipindahkan ke main.dart.
    // Widget ini tidak perlu lagi menangani error dari NoteProvider secara langsung.

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authManager.logout(); // Panggil method logout dari AuthManager
            },
          )
        ],
      ),
      body: Consumer<NoteProvider>( // Menggunakan Consumer di sini untuk mendengarkan state loading
        builder: (context, noteProv, child) {
          // 4. Menentukan konten body berdasarkan state loading dan keberadaan catatan.
          if (noteProv.loading && notes.isEmpty) {
            // Tampilkan loading indicator jika sedang memuat dan belum ada data.
            return const Center(child: CircularProgressIndicator());
          } else if (notes.isEmpty) {
            // Tampilkan pesan jika tidak ada catatan setelah loading selesai.
            return const Center(child: Text('Belum ada catatan. Tambahkan satu!'));
          } else {
            // Tampilkan daftar catatan jika ada.
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (_, i) {
                final note = notes[i];
                return ListTile(
                  title: Text(note.title),
                  subtitle: Text(
                    note.content,
                    maxLines: 2, // Batasi 2 baris
                    overflow: TextOverflow.ellipsis, // Tampilkan '...' jika teks terlalu panjang
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Hapus Catatan?'),
                          content: const Text('Apakah kamu yakin ingin menghapus catatan ini?'),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Hapus'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        await noteActionProvider.deleteNote(note.id, uid);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Catatan berhasil dihapus'),
                                duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      }
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => AddNoteDialog(uid: uid), // Tampilkan dialog tambah catatan
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}