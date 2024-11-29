import 'package:flutter/material.dart';
import 'add_product_page.dart';
import 'view_products_page.dart';
import 'generate_pdf_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Management')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddProductPage()),
              ),
              child: const Text('Add Product'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ViewProductsPage()),
              ),
              child: const Text('View Products'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const GeneratePDFPage()),
              ),
              child: const Text('Generate PDF'),
            ),
          ],
        ),
      ),
    );
  }
}
