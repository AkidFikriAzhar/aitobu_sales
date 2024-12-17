import 'package:aitobu_sales/controller/order_item.dart';
import 'package:aitobu_sales/model/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ControllerReceiptDetails {
  List<OrderItem> groupedItems = [];
  List<Item> listItem = [];

  double calculateItem(int quantity, double itemPrice) {
    double result = 0;
    result = itemPrice * quantity;

    return result;
  }

  String setEmployee(String user) {
    String result = '';
    if (user == 'akidfikriazhar@gmail.com') {
      result = 'Developer';
    } else if (user == 'zulkarnaincareer@gmail.com') {
      result = 'Owner';
    } else if (user == 'hazimzamzam4@gmail.com') {
      result = 'Owner';
    } else {
      return 'Worker';
    }
    return result;
  }

  Future<void> itemList(List<String> items) async {
    List<String> itemName = [];
    for (var id in items) {
      final itemRef = await FirebaseFirestore.instance.collection('items').doc(id).get();
      Item item = Item.fromFirestore(itemRef.data()!);
      listItem.add(item);
      itemName.add(item.name);
      groupedItems = OrderItem.groupedItem(itemName);
    }

    groupedItems.toSet().toList();
  }
}
