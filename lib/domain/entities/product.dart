// lib/domain/entities/product.dart
class Product {
  final String id;
  final String name;
  final int price;
  final double rating;
  final String standName;
  final String facultyName;
  final String imageUrl; // URL gambar produk

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
    return Product(
      id: id,
      name: data['name'] ?? 'Nama Produk Tidak Tersedia',
      price: data['price'] ?? 0,
      rating: (data['rating'] ?? 0.0).toDouble(),
      standName: data['standName'] ?? 'Stand Tidak Tersedia',
      facultyName: data['facultyName'] ?? 'Fakultas Tidak Tersedia',
      imageUrl: data['imageUrl'] ?? 'https://via.placeholder.com/150', // URL default
    );
  }
}