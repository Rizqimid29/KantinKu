// lib/domain/repositories/canteen_repository.dart
import '../entities/product.dart';
import '../entities/app_user.dart';

abstract class CanteenRepository {
  // Mengambil detail user dari Firestore
  Future<AppUser> getUserDetails(String uid);

  // Menyimpan detail user tambahan saat registrasi
  Future<void> saveUserDetails(AppUser user);

  // Mengambil daftar semua fakultas
  Future<List<String>> getFaculties();

  // Mengambil produk best seller
  Future<List<Product>> getBestSellers();

  // Mencari produk berdasarkan filter fakultas
  Future<List<Product>> searchProductsByFaculties(List<String> facultyNames);
  Future<List<Product>> getPopularProducts();
}