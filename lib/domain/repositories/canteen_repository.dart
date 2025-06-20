// lib/domain/repositories/canteen_repository.dart
import '../entities/product.dart';
import '../entities/app_user.dart';

abstract class CanteenRepository {
  Future<AppUser> getUserDetails(String uid);
  Future<void> saveUserDetails(AppUser user);
  Future<List<String>> getFaculties();
  Future<List<Product>> getBestSellers();
  Future<List<Product>> searchProductsByFaculties(List<String> facultyNames);
  Future<List<Product>> getPopularProducts();
  Future<List<Product>> getAllBestSellers(); // <-- BARIS YANG DITAMBAHKAN
}