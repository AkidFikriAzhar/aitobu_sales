import 'package:aitobu_sales/controller/order_item.dart';
import 'package:aitobu_sales/model/item.dart';
import 'package:aitobu_sales/model/receipt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ControllerSalesReport {
  double totalSales = 0;
  int receiptOpen = 0;
  int productSold = 0;
  double cashPayment = 0;
  double qrPayment = 0;
  int totalCashPayment = 0;
  int totalQrPayment = 0;
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
}
