import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/customer_controller.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CustomerListPage extends StatelessWidget {
  final CustomerController customerController = Get.find<CustomerController>();

  Future<void> generatePdf(
      String customerName, List<Map<String, dynamic>> products) async {
    final pdf = pw.Document();

    // Calculate total price of the products
    double totalPrice = products.fold(0.0, (sum, item) => sum + item['price']);

    // QR Code data
    String qrData = 'Customer: $customerName\n'
        'Total Products: ${products.length}\n'
        'Total Price: \$${totalPrice.toStringAsFixed(2)}';

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
                    fontSize: 26,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue,
                  ),
                ),
                // QR Code on the right
                pw.Container(
                  width: 70,
                  height: 70,
                  child: pw.BarcodeWidget(
                    barcode: pw.Barcode.qrCode(),
                    data: qrData,
                    drawText: false,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 20),

            // Customer Name
            pw.Text(
              'Customer: $customerName',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.black,
              ),
            ),
            pw.SizedBox(height: 10),

            // Products List Title
            pw.Text('Products:',
                style: pw.TextStyle(fontSize: 18, color: PdfColors.black)),
            pw.SizedBox(height: 10),

            // Table for Products and Prices
            pw.Table(
              border: pw.TableBorder.all(
                color: PdfColors.black,
                width: 1,
              ),
              children: [
                // Table Header Row
                pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey300,
                  ),
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child: pw.Text(
                        'Product',
                        style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black),
                      ),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child: pw.Text(
                        'Price',
                        style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black),
                      ),
                    ),
                  ],
                ),
                // Loop through products and display each
                ...products.map((product) {
                  return pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: products.indexOf(product) % 2 == 0
                          ? PdfColors.grey100
                          : PdfColors.white,
                    ),
                    children: [
                      pw.Padding(
                        padding: pw.EdgeInsets.all(8),
                        child: pw.Text(product['product']),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(8),
                        child: pw.Text('\$${product['price']}'),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
            pw.SizedBox(height: 20),

            // Total Price Calculation
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Total',
                  style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.black),
                ),
                pw.Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.green),
                ),
              ],
            ),
            pw.SizedBox(height: 20),

            // Footer with additional details or a thank-you note
            pw.Align(
              alignment: pw.Alignment.center,
              child: pw.Text(
                'Thank you for your business!',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // Generate and display the PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white, size: 30),
        backgroundColor: Colors.blue,
        title: Text(
          'Saved Customers',
          style: TextStyle(
              fontSize: 26, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      body: Obx(() => ListView.builder(
            itemCount: customerController.savedCustomers.length,
            itemBuilder: (context, index) {
              final customer = customerController.savedCustomers[index];
              return ListTile(
                title: Text(customer['customer']),
                trailing: IconButton(
                  icon: Icon(Icons.picture_as_pdf),
                  onPressed: () => generatePdf(
                    customer['customer'],
                    customer['products'],
                  ),
                ),
              );
            },
          )),
    );
  }
}
