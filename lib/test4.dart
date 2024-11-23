import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class Test4 extends StatefulWidget {
  @override
  _Test4State createState() => _Test4State();
}

class _Test4State extends State<Test4> {
  final _customerController = TextEditingController();
  final _productController = TextEditingController();
  final _priceController = TextEditingController();
  String? _currentCustomer;
  List<Map<String, dynamic>> _productList = [];
  List<Map<String, dynamic>> _savedCustomers = [];

  void _addProduct(String product, double price) {
    setState(() {
      _productList.add({'product': product, 'price': price});
    });
    _productController.clear();
    _priceController.clear();
  }

  void _saveCustomer() {
    if (_currentCustomer == null || _productList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enter customer details and add products!')),
      );
      return;
    }

    setState(() {
      _savedCustomers.add({
        'customer': _currentCustomer!,
        'products': List<Map<String, dynamic>>.from(_productList),
      });
      _currentCustomer = null;
      _productList.clear();
      _customerController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Customer details saved!')),
    );
  }

  void _newCustomer() {
    setState(() {
      _currentCustomer = null;
      _productList.clear();
      _customerController.clear();
    });
  }

  Future<void> _generatePdf(
      String customerName, List<Map<String, dynamic>> products) async {
    final pdf = pw.Document();

    double totalPrice = products.fold(0.0, (sum, item) => sum + item['price']);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Invoice',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text('Customer: $customerName',
                        style: pw.TextStyle(fontSize: 16)),
                  ],
                ),
                pw.Container(
                  height: 100,
                  width: 100,
                  child: pw.BarcodeWidget(
                    barcode: pw.Barcode.qrCode(),
                    data: 'Customer: $customerName',
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text('Products:', style: pw.TextStyle(fontSize: 18)),
            pw.Divider(),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text('Product',
                          style: pw.TextStyle(
                              fontSize: 16, fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text('Price',
                          style: pw.TextStyle(
                              fontSize: 16, fontWeight: pw.FontWeight.bold)),
                    ),
                  ],
                ),
                ...products.map(
                  (product) => pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(product['product']),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('\$${product['price']}'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text('Total Price: \$${totalPrice.toStringAsFixed(2)}',
                style:
                    pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
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
        title: Text('Invoice Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _customerController,
              decoration: InputDecoration(labelText: 'Customer Name'),
              onChanged: (value) {
                setState(() {
                  _currentCustomer = value;
                });
              },
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _productController,
                    decoration: InputDecoration(labelText: 'Product Name'),
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
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (_productController.text.isNotEmpty &&
                        _priceController.text.isNotEmpty) {
                      _addProduct(
                        _productController.text,
                        double.parse(_priceController.text),
                      );
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _productList.length,
                itemBuilder: (context, index) {
                  final product = _productList[index];
                  return ListTile(
                    title: Text(product['product']),
                    subtitle: Text('\$${product['price']}'),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _saveCustomer,
                  child: Text('Save Customer'),
                ),
                ElevatedButton(
                  onPressed: _newCustomer,
                  child: Text('New Customer'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Saved Customers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _savedCustomers.length,
                itemBuilder: (context, index) {
                  final customer = _savedCustomers[index];
                  return ListTile(
                    title: Text(customer['customer']),
                    trailing: IconButton(
                      icon: Icon(Icons.picture_as_pdf),
                      onPressed: () => _generatePdf(
                        customer['customer'],
                        customer['products'],
                      ),
                    ),
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
    super.dispose();
  }
}
