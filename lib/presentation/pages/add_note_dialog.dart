// lib/presentation/pages/add_note_dialog.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart'; // Pastikan NoteProvider diimpor

// Tidak perlu lagi mengimpor Note entity di sini, karena objek Note dibuat di NoteProvider
// import '../../domain/entities/note.dart';

class AddNoteDialog extends StatefulWidget {
  final String uid; // UID diperlukan untuk proses penyimpanan catatan
  const AddNoteDialog({Key? key, required this.uid}) : super(key: key);

  @override
  State<AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Menggunakan context.read<NoteProvider>() karena kita hanya memanggil method
    // dan tidak perlu rebuild dialog ini berdasarkan perubahan state NoteProvider.
    final noteProvider = context.read<NoteProvider>();

    return AlertDialog(
      title: const Text('Tambah Catatan'),
      content: Column(
        mainAxisSize: MainAxisSize.min, // Agar dialog tidak memakan seluruh tinggi layar
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Judul'),
          ),
          const SizedBox(height: 10), // Memberi sedikit jarak antar TextField
          TextField(
            controller: _contentController,
            decoration: const InputDecoration(labelText: 'Isi'),
            maxLines: 3, // Memungkinkan input multi-baris untuk isi catatan
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Tutup dialog tanpa menyimpan
          },
          child: const Text('Batal'),
        ),
        Consumer<NoteProvider>( // Menggunakan Consumer untuk mendengarkan state loading
          builder: (ctx, noteProv, child) {
            return ElevatedButton(
              onPressed: noteProv.loading // Tombol dinonaktifkan jika NoteProvider sedang loading
                  ? null
                  : () async {
                // Panggil metode addNote dari NoteProvider.
                // NoteProvider akan membuat objek Note dari title dan content ini.
                await noteProv.addNote(
                  _titleController.text,
                  _contentController.text,
                  widget.uid, // Teruskan UID yang diterima dari NotesPage
                );
                // Setelah operasi selesai (berhasil atau gagal), dialog ditutup.
                // Penanganan error (SnackBar) akan muncul di main.dart.
                Navigator.pop(context);
              },
              child: noteProv.loading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : const Text('Simpan'),
            );
          },
        ),
      ],
    );
  }
}


// lib/presentation/pages/add_note_dialog.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/note_provider.dart';
//
// // Ubah menjadi StatefulWidget untuk pengelolaan TextEditingController yang benar
// class AddNoteDialog extends StatefulWidget {
//   final String uid;
//   const AddNoteDialog({Key? key, required this.uid}) : super(key: key);
//
//   @override
//   State<AddNoteDialog> createState() => _AddNoteDialogState();
// }
//
// class _AddNoteDialogState extends State<AddNoteDialog> {
//   // Inisialisasi controller di State
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _contentController = TextEditingController();
//
//   // Bersihkan controller saat widget di-dispose
//   @override
//   void dispose() {
//     _titleController.dispose();
//     _contentController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Ambil NoteProvider. Gunakan .read() karena kita hanya memanggil method
//     final noteProvider = context.read<NoteProvider>();
//
//     return AlertDialog(
//       title: const Text('Tambah Catatan'),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           TextField(
//             controller: _titleController,
//             decoration: const InputDecoration(labelText: 'Judul'),
//           ),
//           TextField(
//             controller: _contentController,
//             decoration: const InputDecoration(labelText: 'Isi'),
//             maxLines: 3, // Opsional: Beri ruang lebih untuk isi
//           ),
//         ],
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.pop(context); // Tutup dialog saat batal
//           },
//           child: const Text('Batal'),
//         ),
//         // Gunakan Consumer di sini untuk menampilkan loading indicator pada tombol
//         // jika Anda ingin tombol berubah menjadi loading saat operasi sedang berjalan
//         Consumer<NoteProvider>(
//           builder: (ctx, noteProv, child) {
//             return ElevatedButton(
//               onPressed: noteProv.loading // Tombol dinonaktifkan jika sedang loading
//                   ? null
//                   : () async {
//                 await noteProv.addNote(
//                   _titleController.text,
//                   _contentController.text,
//                   widget.uid, // Akses uid dari widget
//                 );
//
//                 // Logika SnackBar untuk error sudah ditangani di NotesPage.
//                 // Jadi, di sini cukup pop dialog, terlepas dari sukses/gagal.
//                 // NotesPage akan menampilkan SnackBar jika ada error.
//                 Navigator.pop(context);
//               },
//               child: noteProv.loading
//                   ? const SizedBox(
//                 width: 20,
//                 height: 20,
//                 child: CircularProgressIndicator(
//                   color: Colors.white,
//                   strokeWidth: 2,
//                 ),
//               )
//                   : const Text('Simpan'),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }


// lib/presentation/pages/add_note_dialog.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/note_provider.dart';
//
// class AddNoteDialog extends StatelessWidget {
//   final String uid;
//   const AddNoteDialog({Key? key, required this.uid}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final titleCtrl = TextEditingController();
//     final contentCtrl = TextEditingController();
//     final noteProv = context.read<NoteProvider>();
//
//     return AlertDialog(
//       title: const Text('Tambah Catatan'),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Judul')),
//           TextField(controller: contentCtrl, decoration: const InputDecoration(labelText: 'Isi')),
//         ],
//       ),
//       actions: [
//         TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
//         ElevatedButton(
//           onPressed: () async {
//             await noteProv.addNote(titleCtrl.text, contentCtrl.text, uid);
//             if (noteProv.error != null) {
//               Navigator.pop(context);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text(noteProv.error!)),
//               );
//             } else {
//               Navigator.pop(context);
//             }
//           },
//           child: const Text('Simpan'),
//         ),
//       ],
//     );
//   }
// }
