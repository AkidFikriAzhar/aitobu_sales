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
        appBar: AppBar(),
        body: PdfPreview(
          pdfFileName: 'Sales Report',
          build: (PdfPageFormat format) => controller.generatePdf(),
        ));
  }
}
