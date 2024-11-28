import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class Test3 extends StatefulWidget {
  @override
  _Test3State createState() => _Test3State();
}

class _Test3State extends State<Test3> {
  final _customerController = TextEditingController();
  final _productController = TextEditingController();
  final _priceController = TextEditingController();
  String? _currentCustomer;
  List<Map<String, dynamic>> _productList = [];

  void _addProduct(String product, double price) {
    setState(() {
      _productList.add({'product': product, 'price': price});
    });
    _productController.clear();
    _priceController.clear();
  }

  double _calculateTotalPrice() {
    return _productList.fold(0, (sum, item) => sum + (item['price'] as double));
  }

  Future<void> _generatePdf(
      String customerName, List<Map<String, dynamic>> products) async {
    final pdf = pw.Document();

    // Example QR code data
    final qrCodeData = 'Customer: $customerName\n'
        'Total Products: ${products.length}\n'
        'Total Price: \$${_calculateTotalPrice().toStringAsFixed(2)}';

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header: Title and QR Code
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Invoice',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Container(
                  width: 50,
                  height: 50,
                  child: pw.BarcodeWidget(
                    barcode: pw.Barcode.qrCode(),
                    data: qrCodeData,
                    drawText: false,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 20),

            // Customer Name
            pw.Text(
              'Customer: $customerName',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),

            // Product Table Header
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Product',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  'Price',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
            pw.Divider(),

            // Product List
            ...products.map((product) {
              return pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(product['product']),
                  pw.Text('\$${product['price']}'),
                ],
              );
            }).toList(),
            pw.Divider(),

            // Total Price
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Total',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  '\$${_calculateTotalPrice().toStringAsFixed(2)}',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    // Show the PDF preview
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
            // Customer Name Input
            TextFormField(
              controller: _customerController,
              decoration: InputDecoration(labelText: 'Customer Name'),
              onChanged: (value) {
                setState(() {
                  _currentCustomer = value;
                });
              },
            ),

            // Product and Price Input
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

            // Product List Display
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

            // Generate PDF Button
            ElevatedButton(
              onPressed: () {
                if (_currentCustomer != null && _productList.isNotEmpty) {
                  _generatePdf(_currentCustomer!, _productList);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Add customer and products first!')),
                  );
                }
              },
              child: Text('Generate PDF'),
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
