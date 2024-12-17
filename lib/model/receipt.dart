import 'package:cloud_firestore/cloud_firestore.dart';

class Receipt {
  final String user;
  final String runningNum;
  final bool isCash;
  final bool isReturn;
  final double totalPrice;
  final double cashReceived;
  final Timestamp timestamp;
  final List<String> items;

  Receipt({
    required this.user,
    required this.runningNum,
    required this.isCash,
    required this.totalPrice,
    required this.isReturn,
    required this.cashReceived,
    required this.timestamp,
    required this.items,
  });

  factory Receipt.fromFirestore(dynamic doc) {
    return Receipt(
      user: doc['user'].toString(),
      runningNum: doc['runningNum'],
      isCash: doc['isCash'],
      totalPrice: doc['totalPrice'],
      cashReceived: doc['cashReceived'],
      timestamp: doc['timestamp'],
      isReturn: doc['isReturn'],
      items: List<String>.from(doc['items']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'user': user,
      'runningNum': runningNum,
      'isCash': isCash,
      'totalPrice': totalPrice,
      'cashReceived': cashReceived,
      'timestamp': timestamp,
      'items': items,
      'isReturn': isReturn,
    };
  }
}
