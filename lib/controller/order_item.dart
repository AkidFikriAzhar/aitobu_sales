class OrderItem {
  final String item;
  final int quantity;

  OrderItem({required this.item, required this.quantity});

  static List<OrderItem> groupedItem(List<String> items) {
    Map<String, int> itemCount = {};

    for (var item in items) {
      itemCount[item] = (itemCount[item] ?? 0) + 1;
    }

    return itemCount.entries.map((entry) => OrderItem(item: entry.key, quantity: entry.value)).toList();
  }
}
