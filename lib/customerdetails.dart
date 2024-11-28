import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:pdf/pdf.dart';
import 'package:sqflite/sqflite.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late Database db;
  final _formKey = GlobalKey<FormState>();
  final _customerController = TextEditingController();
  final _productController = TextEditingController();
  final _priceController = TextEditingController();
  List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    _initializeDb();
  }

  Future<void> _initializeDb() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'product_db.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE products(id INTEGER PRIMARY KEY, customer TEXT, product TEXT, price REAL)',
        );
      },
      version: 1,
    );
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final List<Map<String, dynamic>> products = await db.query('products');
    setState(() {
      _products = products;
    });
  }

  Future<void> _addProduct(
      String customer, String product, double price) async {
    await db.insert(
      'products',
      {'customer': customer, 'product': product, 'price': price},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _fetchProducts();
  }

  Future<void> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          children: [
            pw.Text('Product List', style: pw.TextStyle(fontSize: 20)),
            pw.SizedBox(height: 20),
            pw.ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return pw.Text(
                  '${product['customer']} - ${product['product']} - \$${product['price']}',
                );
              },
            ),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: _generatePdf,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _customerController,
                    decoration: InputDecoration(labelText: 'Customer Name'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter a name' : null,
                  ),
                  TextFormField(
                    controller: _productController,
                    decoration: InputDecoration(labelText: 'Product Name'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Enter a product'
                        : null,
                  ),
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter a price' : null,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _addProduct(
                          _customerController.text,
                          _productController.text,
                          double.parse(_priceController.text),
                        );
                        _customerController.clear();
                        _productController.clear();
                        _priceController.clear();
                      }
                    },
                    child: Text('Add Product'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return ListTile(
                    title: Text(product['product']),
                    subtitle:
                        Text('${product['customer']} - \$${product['price']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _customerController.dispose();
    _productController.dispose();
    _priceController.dispose();
    db.close();
    super.dispose();
  }
}
