import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:pdf/pdf.dart';
import 'package:sqflite/sqflite.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class Thirrd extends StatefulWidget {
  @override
  _ThirrdState createState() => _ThirrdState();
}

class _ThirrdState extends State<Thirrd> {
  late Database db;
  final _formKey = GlobalKey<FormState>();
  final _customerController = TextEditingController();
  final _productController = TextEditingController();
  final _priceController = TextEditingController();

  String? _currentCustomer;
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

  Future<void> _addProduct(String product, double price) async {
    setState(() {
      _products.add(
          {'customer': _currentCustomer, 'product': product, 'price': price});
    });
  }

  Future<void> _saveProductsToDb() async {
    for (var product in _products) {
      await db.insert(
        'products',
        {
          'customer': product['customer'],
          'product': product['product'],
          'price': product['price'],
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    _fetchProducts();
  }

  Future<void> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Invoice',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Customer: $_currentCustomer',
                style: pw.TextStyle(fontSize: 18)),
            pw.Divider(),
            pw.Text('Products:', style: pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 10),
            ..._products.map((product) => pw.Text(
                  '${product['product']} - \$${product['price']}',
                )),
            pw.Divider(),
            pw.Text(
              'Total Amount: \$${_products.fold(0.0, (sum, item) => sum + item['price'] as double)}',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
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
            if (_currentCustomer == null)
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _customerController,
                      decoration: InputDecoration(labelText: 'Customer Name'),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter a name'
                          : null,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _currentCustomer = _customerController.text;
                          });
                          _customerController.clear();
                        }
                      },
                      child: Text('Start Adding Products'),
                    ),
                  ],
                ),
              ),
            if (_currentCustomer != null)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Customer: $_currentCustomer',
                        style: TextStyle(fontSize: 18)),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _productController,
                            decoration:
                                InputDecoration(labelText: 'Product Name'),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _priceController,
                            decoration: InputDecoration(labelText: 'Price'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            if (_productController.text.isNotEmpty &&
                                _priceController.text.isNotEmpty) {
                              _addProduct(
                                _productController.text,
                                double.parse(_priceController.text),
                              );
                              _productController.clear();
                              _priceController.clear();
                            }
                          },
                          child: Text('Add'),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _products.length,
                        itemBuilder: (context, index) {
                          final product = _products[index];
                          return ListTile(
                            title: Text(product['product']),
                            subtitle: Text('\$${product['price']}'),
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await _saveProductsToDb();
                        setState(() {
                          _currentCustomer = null;
                          _products = [];
                        });
                      },
                      child: Text('Save and Clear'),
                    ),
                  ],
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
