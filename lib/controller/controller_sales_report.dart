import 'dart:typed_data';

import 'package:aitobu_sales/controller/order_item.dart';
import 'package:aitobu_sales/model/item.dart';
import 'package:aitobu_sales/model/receipt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ControllerSalesReport {
  double totalSales = 0;
  int receiptOpen = 0;
  int productSold = 0;
  double cashPayment = 0;
  double qrPayment = 0;
  int totalCashPayment = 0;
  int totalQrPayment = 0;
  DateTime currentTime = DateTime.now();
  List<OrderItem> breakdownProductName = [];
  List<Receipt> receiptList = [];
  List<Receipt> dailyReceipt = [];
  List<Item> itemList = [];

  double getBreakdownUnit(int productSold, int unit) {
    return unit / productSold;
  }

  double percentCash() {
    return cashPayment / totalSales * 100;
  }

  double percentQr() {
    return qrPayment / totalSales * 100;
  }

  Future<void> getDailyReport(DateTime currentDate) async {
    final firestore = FirebaseFirestore.instance;
    currentTime = currentDate;
    final receiptRef = await firestore.collectionGroup('receipt').get();

    receiptList = receiptRef.docs.map((e) {
      return Receipt.fromFirestore(e);
    }).toList();

    dailyReceipt = receiptList.where((e) {
      return DateTime(
            e.timestamp.toDate().year,
            e.timestamp.toDate().month,
            e.timestamp.toDate().day,
          ) ==
          currentDate;
    }).toList();

//get total open receipt
    receiptOpen = dailyReceipt.length;
//get daily total sales
    for (var receipt in dailyReceipt) {
      totalSales += receipt.totalPrice;
//get product sold
      for (var items in receipt.items) {
        var getItem = await firestore.collection('items').doc(items).get();

        itemList.add(Item.fromFirestore(getItem.data()!));
      }
    }
    productSold = itemList.length;

    List<String> itemL = [];
    for (var stringItem in itemList) {
      itemL.add(stringItem.name);
    }
    breakdownProductName = OrderItem.groupedItem(itemL);

    breakdownProductName.toSet().toList();
    breakdownProductName.sort((a, b) => a.item.compareTo(b.item));

    List<Receipt> cashPay = dailyReceipt.where((e) => e.isCash == true).toList();

    for (var cash in cashPay) {
      cashPayment += cash.totalPrice;
    }
    totalCashPayment = cashPay.length;

    List<Receipt> qrPay = dailyReceipt.where((e) => e.isCash == false).toList();

    for (var qr in qrPay) {
      qrPayment += qr.totalPrice;
    }
    totalQrPayment = qrPay.length;
  }

  Future<Uint8List> generatePdf() async {
    final pdf = pw.Document();
    final date = Jiffy.parseFromDateTime(currentTime).format(pattern: 'EEEE, d MMMM y');
    final int findHighProduct = breakdownProductName.fold(0, (prev, e) => e.quantity > prev ? e.quantity : prev);
    final highProduct = breakdownProductName.where((e) => e.quantity == findHighProduct).toList();

    String paymentMethod = percentCash() > percentQr() ? 'cash transactions' : 'QR payments';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  'Aitobu Sales Report',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18),
                ),
              ),
              pw.Center(child: pw.Text(date)),
              pw.SizedBox(height: 50),
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                width: double.infinity,
                decoration: const pw.BoxDecoration(
                  color: PdfColors.green200,
                ),
                child: pw.Text('Executive Summary'),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                  'This sales report provides an overview of the revenue, payment distribution, and product performance for the selected period. Key insights include the dominance of $paymentMethod transactions and the high performance of the "${highProduct.first.item}" product. While the total sales for the day is RM ${totalSales.toStringAsFixed(2)}, the "${highProduct.first.item}" product accounts for ${getBreakdownUnit(productSold, highProduct.first.quantity * 100).toStringAsFixed(0)}% of total sales.'),
              pw.SizedBox(height: 30),
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                width: double.infinity,
                decoration: const pw.BoxDecoration(
                  color: PdfColors.green200,
                ),
                child: pw.Text('Key Metrics'),
              ),
              pw.SizedBox(height: 10),
              pw.RichText(
                text: pw.TextSpan(text: 'Total Sales: ', children: [
                  pw.TextSpan(
                    text: 'RM ${totalSales.toStringAsFixed(2)}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ]),
              ),
              pw.SizedBox(height: 5),
              pw.RichText(
                text: pw.TextSpan(text: 'Product Sold: ', children: [
                  pw.TextSpan(
                    text: '$productSold units',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ]),
              ),
              pw.SizedBox(height: 5),
              pw.RichText(
                text: pw.TextSpan(text: 'Receipt Open: ', children: [
                  pw.TextSpan(
                    text: '$receiptOpen transactions',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ]),
              ),
              pw.SizedBox(height: 30),
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                width: double.infinity,
                decoration: const pw.BoxDecoration(
                  color: PdfColors.green200,
                ),
                child: pw.Text('Payment Methods'),
              ),
              pw.SizedBox(height: 10),
              pw.RichText(
                text: pw.TextSpan(text: 'Cash: ', children: [
                  pw.TextSpan(
                    text: '$totalCashPayment payments - RM ${cashPayment.toStringAsFixed(2)} (${percentCash().toStringAsFixed(0)}%)',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ]),
              ),
              pw.SizedBox(height: 5),
              pw.RichText(
                text: pw.TextSpan(text: 'QR Payment: ', children: [
                  pw.TextSpan(
                    text: '$totalQrPayment payments - RM ${qrPayment.toStringAsFixed(2)} (${percentQr().toStringAsFixed(0)}%)',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ]),
              ),
              pw.SizedBox(height: 30),
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                width: double.infinity,
                decoration: const pw.BoxDecoration(
                  color: PdfColors.green200,
                ),
                child: pw.Text('Product Breakdown'),
              ),
              pw.SizedBox(height: 10),
              for (var item in breakdownProductName)
                pw.Column(
                  children: [
                    pw.RichText(
                      text: pw.TextSpan(text: '${item.item}: ', children: [
                        pw.TextSpan(
                          text: '${item.quantity} units (${getBreakdownUnit(productSold, item.quantity * 100).toStringAsFixed(0)}% of total sales)',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ]),
                    ),
                    pw.SizedBox(height: 5),
                  ],
                ),

              // ignore: deprecated_member_use
              // pw.Table.fromTextArray(
              //   context: context,
              //   cellAlignment: pw.Alignment.centerLeft,
              //   border: pw.TableBorder.all(color: PdfColors.white),
              //   data: <List<String>>[
              //     <String>['Product Name', 'Unit Sold'],
              //     ...breakdownProductName.map((e) => [e.item, e.quantity.toString()]),
              //   ],
              // ),
            ],
          ),
        ],
      ),
    );
    return await pdf.save();
  }
}
