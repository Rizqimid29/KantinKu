import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/home_provider.dart';
import '../providers/search_provider.dart';
import '../theme/app_theme.dart';
import '../../domain/entities/product.dart';
import 'search_result_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _selectedFaculties = [];

  void _showFacultySelectionDialog(List<String> allFaculties) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Pilih Fakultas'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: allFaculties.length,
                  itemBuilder: (context, index) {
                    final faculty = allFaculties[index];
                    final isSelected = _selectedFaculties.contains(faculty);
                    return CheckboxListTile(
                      title: Text(faculty),
                      value: isSelected,
                      onChanged: (bool? value) {
                        setDialogState(() {
                          if (value == true) {
                            _selectedFaculties.add(faculty);
                          } else {
                            _selectedFaculties.remove(faculty);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _performSearch();
                  },
                  child: const Text('Cari'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _performSearch() {
    if (_selectedFaculties.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih minimal satu fakultas.')),
      );
      return;
    }

    context.read<SearchProvider>().searchProducts(_selectedFaculties);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) =>
                SearchResultPage(selectedFaculties: _selectedFaculties),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KantinKU'),
        automaticallyImplyLeading: false,
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.bestSellers.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(child: Text(provider.error!));
          }
          return RefreshIndicator(
            onRefresh: provider.fetchInitialData,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildFacultyFilter(context, provider.faculties),
                const SizedBox(height: 24),
                _buildSectionHeader(context, 'Paling Laris 🔥', () {}),
                const SizedBox(height: 16),
                _buildBestSellerList(provider.bestSellers),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFacultyFilter(BuildContext context, List<String> faculties) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mau cari di fakultas mana?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.warmBrown,
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () {
            if (faculties.isNotEmpty) {
              _showFacultySelectionDialog(faculties);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Gagal memuat daftar fakultas.')),
              );
            }
          },
          icon: const Icon(Icons.search),
          label: const Text('Pilih Fakultas & Cari'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.orangePeel,
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    VoidCallback onSeeAll,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.warmBrown,
          ),
        ),
        TextButton(onPressed: onSeeAll, child: const Text('Lihat Semua')),
      ],
    );
  }

  Widget _buildBestSellerList(List<Product> products) {
    if (products.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Belum ada produk best seller.'),
        ),
      );
    }
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCard(product: product);
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              product.imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    height: 120,
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp ${product.price}',
                    style: const TextStyle(color: AppTheme.tomatoRed),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(product.rating.toString()),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
