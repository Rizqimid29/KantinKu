// lib/presentation/providers/popular_product_provider.dart
import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/canteen_repository.dart';

class PopularProductProvider extends ChangeNotifier {
  final CanteenRepository _canteenRepository;

  PopularProductProvider(this._canteenRepository) {
    fetchPopularProducts();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  List<Product> _products = [];
  List<Product> get products => _products;

  Future<void> fetchPopularProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await _canteenRepository.getPopularProducts();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}