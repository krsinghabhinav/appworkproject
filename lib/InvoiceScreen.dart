import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class InvoiceScreen extends StatefulWidget {
  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  final _customerController = TextEditingController();
  final _productController = TextEditingController();
  final _priceController = TextEditingController();
  List<Map<String, dynamic>> _productList = [];
  int? _customerId;
  double _totalPrice = 0.0;

  void _addProduct() {
    String productName = _productController.text.trim();
    double productPrice = double.tryParse(_priceController.text) ?? 0.0;

    if (_customerId != null && productName.isNotEmpty && productPrice > 0) {
      DatabaseHelper.instance
          .addProduct(_customerId!, productName, productPrice)
          .then((_) {
        setState(() {
          _productList.add({'name': productName, 'price': productPrice});
          _totalPrice += productPrice;
          _productController.clear();
          _priceController.clear();
        });
      });
    }
  }

  Future<void> _createInvoice() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Invoice',
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.BarcodeWidget(
                  barcode: pw.Barcode.code128(),
                  data: _customerId.toString(),
                  width: 100,
                  height: 50,
                ),
              ],
            ),
            pw.Divider(),
            pw.Text('Customer Name: ${_customerController.text}',
                style: pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 10),
            // ignore: deprecated_member_use
            pw.Table.fromTextArray(
              headers: ['Product', 'Price'],
              data: _productList
                  .map((p) => [p['name'], p['price'].toString()])
                  .toList(),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Total: $_totalPrice',
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          ],
        ),
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/invoice.pdf');
    await file.writeAsBytes(await pdf.save());

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Invoice'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _customerController,
              decoration: InputDecoration(labelText: 'Customer Name'),
              onSubmitted: (value) async {
                _customerId = await DatabaseHelper.instance.addCustomer(value);
              },
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _productController,
                    decoration: InputDecoration(labelText: 'Product Name'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _priceController,
                    decoration: InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addProduct,
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _productList.length,
                itemBuilder: (context, index) {
                  final product = _productList[index];
                  return ListTile(
                    title: Text(product['name']),
                    trailing: Text('₹${product['price']}'),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _createInvoice,
              child: Text('Generate PDF'),
            ),
          ],
        ),
      ),
    );
  }
}
