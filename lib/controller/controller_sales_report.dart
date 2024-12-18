import 'package:aitobu_sales/controller/order_item.dart';
import 'package:aitobu_sales/model/item.dart';
import 'package:aitobu_sales/model/receipt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ControllerSalesReport {
  double totalSales = 0;
  int receiptOpen = 0;
  int productSold = 0;
  List<OrderItem> breakdownProductName = [];
  List<Receipt> receiptList = [];
  List<Receipt> dailyReceipt = [];
  List<Item> itemList = [];

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
  }
}
