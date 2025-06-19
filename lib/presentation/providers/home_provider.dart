// lib/presentation/providers/home_provider.dart
import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/canteen_repository.dart';

class HomeProvider extends ChangeNotifier {
  final CanteenRepository _canteenRepository;

  HomeProvider(this._canteenRepository) {
    // Langsung fetch data saat provider diinisialisasi
    fetchInitialData();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<String> _faculties = [];
  List<String> get faculties => _faculties;

  List<Product> _bestSellers = [];
  List<Product> get bestSellers => _bestSellers;

  String? _error;
  String? get error => _error;

  Future<void> fetchInitialData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      // Fetch data secara bersamaan
      final results = await Future.wait([
        _canteenRepository.getFaculties(),
        _canteenRepository.getBestSellers(),
      ]);
      _faculties = results[0] as List<String>;
      _bestSellers = results[1] as List<Product>;

      print('DEBUG: Jumlah Fakultas Ditemukan: ${_faculties.length}');
      print('DEBUG: Data Fakultas: $_faculties');
      print('DEBUG: Jumlah Best Seller Ditemukan: ${_bestSellers.length}');

    } catch (e) {
      _error = "Gagal memuat data: ${e.toString()}";
      print('DEBUG: TERJADI ERROR SAAT FETCH DATA: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}