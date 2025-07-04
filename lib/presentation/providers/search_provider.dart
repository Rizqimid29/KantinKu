import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/canteen_repository.dart';

class SearchProvider extends ChangeNotifier {
  final CanteenRepository _canteenRepository;

  SearchProvider(this._canteenRepository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Map<String, List<Product>> _groupedProducts = {};
  Map<String, List<Product>> get groupedProducts => _groupedProducts;

  Future<void> searchProducts(List<String> facultyNames) async {
    if (facultyNames.isEmpty) return;

    _isLoading = true;
    _error = null;
    _groupedProducts = {};
    notifyListeners();

    try {
      final allProducts = await _canteenRepository.searchProductsByFaculties(
        facultyNames,
      );

      for (var faculty in facultyNames) {
        _groupedProducts[faculty] =
            allProducts.where((p) => p.facultyName == faculty).toList();
      }
    } catch (e) {
      _error = "Gagal mencari produk: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
