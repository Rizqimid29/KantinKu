// lib/presentation/pages/best_seller_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/best_seller_provider.dart';
import 'search_result_page.dart'; // Menggunakan ulang ProductListItem

class BestSellerPage extends StatelessWidget {
  const BestSellerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produk Terlaris'),
      ),
      body: Consumer<BestSellerProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text(provider.error!));
          }

          if (provider.products.isEmpty) {
            return const Center(
              child: Text('Belum ada produk best seller.'),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.fetchAllBestSellers,
            child: ListView.builder(
              itemCount: provider.products.length,
              itemBuilder: (context, index) {
                final product = provider.products[index];
                return ProductListItem(product: product);
              },
            ),
          );
        },
      ),
    );
  }
}