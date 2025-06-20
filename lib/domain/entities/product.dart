class Product {
  final String id;
  final String name;
  final int price;
  final double rating;
  final String standName;
  final String facultyName;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.standName,
    required this.facultyName,
    required this.imageUrl,
  });

  factory Product.fromMap(Map<String, dynamic> data, String id) {
    // Fungsi bantuan untuk mengubah link Google Drive
    String _getDirectImageUrl(String? url) {
      const String placeholder = 'https://via.placeholder.com/150';
      if (url == null || url.isEmpty) {
        return placeholder;
      }

      // Cek apakah ini link Google Drive yang umum
      if (url.contains("drive.google.com/file/d/")) {
        try {
          // Ekstrak ID file dari URL
          final fileId = url.split('/d/')[1].split('/')[0];
          // Bentuk URL direct link yang baru
          return 'https://drive.google.com/uc?export=view&id=$fileId';
        } catch (e) {
          // Jika gagal, kembalikan placeholder
          return placeholder;
        }
      }

      // Jika bukan link Google Drive, kembalikan URL aslinya
      return url;
    }

    // Fungsi bantuan untuk mengurai harga dengan aman
    int parsePrice(dynamic priceData) {
      if (priceData is int) {
        return priceData;
      }
      if (priceData is String) {
        return int.tryParse(priceData) ?? 0;
      }
      return 0;
    }

    return Product(
      id: id,
      name: data['name'] ?? 'Nama Produk Tidak Tersedia',
      price: parsePrice(data['price']),
      rating: (data['rating'] ?? 0.0).toDouble(),
      standName: data['standName'] ?? 'Stand Tidak Tersedia',
      facultyName: data['facultyName'] ?? 'Fakultas Tidak Tersedia',
      imageUrl: _getDirectImageUrl(data['imageUrl']), // <-- Gunakan fungsi konversi
    );
  }
}