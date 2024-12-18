class Data {
  final int totalCup;
  final int totalReceipt;

  Data({required this.totalCup, required this.totalReceipt});

  factory Data.fromFirestore(dynamic doc) {
    return Data(
      totalCup: doc['totalCup'],
      totalReceipt: doc['totalReceipt'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'totalCup': totalCup,
      'totalReceipt': totalReceipt,
    };
  }
}
