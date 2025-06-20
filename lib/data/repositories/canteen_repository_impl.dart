// lib/data/repositories/canteen_repository_impl.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/canteen_repository.dart';

class CanteenRepositoryImpl implements CanteenRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<AppUser> getUserDetails(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return AppUser.fromMap(doc.data()!, uid);
      }
      throw Exception('User details not found.');
    } catch (e) {
      throw Exception('Failed to get user details: $e');
    }
  }

  @override
  Future<void> saveUserDetails(AppUser user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toMap());
    } catch (e) {
      throw Exception('Failed to save user details: $e');
    }
  }

  @override
  Future<List<String>> getFaculties() async {
    try {
      final snapshot = await _firestore.collection('faculties').get();
      return snapshot.docs.map((doc) => doc.data()['name'] as String).toList();
    } catch (e) {
      throw Exception('Failed to get faculties: $e');
    }
  }

  @override
  Future<List<Product>> getBestSellers() async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .where('isBestSeller', isEqualTo: true)
          .limit(5)
          .get();
      return snapshot.docs
          .map((doc) => Product.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get best sellers: $e');
    }
  }

  @override
  Future<List<Product>> searchProductsByFaculties(List<String> facultyNames) async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .where('facultyName', whereIn: facultyNames)
          .get();
      return snapshot.docs
          .map((doc) => Product.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }
  @override
  Future<List<Product>> getPopularProducts() async {
    try {
      // Query untuk mengambil produk dengan rating >= 4.7
      final snapshot = await _firestore
          .collection('products')
          .where('rating', isGreaterThanOrEqualTo: 4.7)
          .orderBy('rating', descending: true) // Urutkan dari rating tertinggi
          .limit(20) // Batasi hasilnya, misal 20 produk teratas
          .get();
      return snapshot.docs
          .map((doc) => Product.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get popular products: $e');
    }
  }
}