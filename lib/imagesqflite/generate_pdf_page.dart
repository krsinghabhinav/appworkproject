import 'package:appworkproject/imagesqflite/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class GeneratePDFPage extends StatelessWidget {
  const GeneratePDFPage({super.key});

  Future<void> _generatePDF(BuildContext context) async {
    final products = await DBHelper().fetchProducts();
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Table(
            border: pw.TableBorder.all(),
            children: [
              // Add table header with correct color
              pw.TableRow(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.deepOrange100),

                  // color: pw.a.fromInt(0xFFEEEEEE), // Light grey color
                  // color: pw.Color.fromInt(0xFFEEEEEE), // Light grey color
                ),
                children: [
                  pw.Text('Image',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Name',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Description',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Price',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Quantity',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
              // Add table rows for products
              ...products.map((product) {
                return pw.TableRow(
                  children: [
                    pw.Container(
                      height: 50,
                      width: 50,
                      alignment: pw.Alignment.center,
                      child: pw.Image(
                        pw.MemoryImage(product.image),
                        fit: pw.BoxFit.contain,
                      ),
                    ),
                    pw.Text(product.name ?? ''),
                    pw.Text(product.description ?? ''),
                    pw.Text('\$${product.price.toString()}'),
                    pw.Text(product.quantity.toString()),
                  ],
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'products.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Generate PDF')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _generatePDF(context),
          child: const Text('Generate PDF'),
        ),
      ),
    );
  }
}
