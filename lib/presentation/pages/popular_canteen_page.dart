import 'package:flutter/material.dart';

class PopularCanteenPage extends StatelessWidget {
  const PopularCanteenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kantin Populer'),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text('Halaman ini sedang dalam pengembangan.'),
          ],
        ),
      ),
    );
  }
}
