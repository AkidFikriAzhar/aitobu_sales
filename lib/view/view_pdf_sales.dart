import 'package:aitobu_sales/controller/controller_sales_report.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class ViewPdfSales extends StatelessWidget {
  final ControllerSalesReport controller;
  const ViewPdfSales({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('PDF Report'),
        ),
        body: PdfPreview(
          pdfFileName: 'Sales Report',
          pageFormats: const {'A4': PdfPageFormat.a4, 'A5': PdfPageFormat.a5},
          build: (PdfPageFormat format) => controller.generatePdf(),
          loadingWidget: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator.adaptive(),
              SizedBox(height: 15),
              Text('Generating PDF...'),
            ],
          ),
        ));
  }
}
