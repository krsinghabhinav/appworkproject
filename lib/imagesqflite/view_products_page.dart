import 'package:appworkproject/imagesqflite/db_helper.dart';
import 'package:appworkproject/imagesqflite/product_model.dart';
import 'package:flutter/material.dart';

class ViewProductsPage extends StatelessWidget {
  const ViewProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('View Products')),
      body: FutureBuilder<List<ProductModel>>(
        future: DBHelper().fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          } else if (snapshot.data!.isEmpty) {
            return const Center(child: Text('No products available'));
          }

          final products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                leading: Image.memory(product.image, width: 50, height: 50),
                title: Text(product.name),
                subtitle: Text(
                  '\$${product.price}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
