// lib/presentation/pages/popular_product_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/popular_product_provider.dart';
import 'search_result_page.dart'; // Import ini untuk menggunakan ProductListItem

// NAMA CLASS JUGA DIUBAH AGAR SESUAI
class PopularProductPage extends StatelessWidget {
  const PopularProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produk Populer'),
        automaticallyImplyLeading: false,
      ),
      body: Consumer<PopularProductProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text(provider.error!));
          }

          if (provider.products.isEmpty) {
            return const Center(
              child: Text('Belum ada produk dengan rating 4.7 ke atas.'),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.fetchPopularProducts,
            child: ListView.builder(
              itemCount: provider.products.length,
              itemBuilder: (context, index) {
                final product = provider.products[index];
                // Gunakan kembali widget yang sudah ada!
                return ProductListItem(product: product);
              },
            ),
          );
        },
      ),
    );
  }
}