// lib/presentation/providers/best_seller_provider.dart
import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/canteen_repository.dart';

class BestSellerProvider extends ChangeNotifier {
  final CanteenRepository _canteenRepository;

  BestSellerProvider(this._canteenRepository) {
    fetchAllBestSellers();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  List<Product> _products = [];
  List<Product> get products => _products;

  Future<void> fetchAllBestSellers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await _canteenRepository.getAllBestSellers();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}