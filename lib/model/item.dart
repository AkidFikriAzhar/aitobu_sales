import 'package:aitobu_sales/model/section.dart';

class Item {
  final String id;
  final String name;
  final double price;
  final double? cost;
  final int? stock;
  final int totalSold;
  final String? imgUrl;
  final int colors;
  final Section? category;

  Item({
    required this.id,
    required this.name,
    required this.price,
    required this.cost,
    required this.stock,
    required this.imgUrl,
    required this.colors,
    required this.totalSold,
    required this.category,
  });

  factory Item.fromFirestore(dynamic doc) {
    return Item(
      id: doc['id'],
      name: doc['name'],
      price: double.parse(doc['price'].toString()),
      cost: doc['cost'],
      stock: doc['stock'],
      imgUrl: doc['imgUrl'],
      colors: doc['color'],
      totalSold: doc['totalSold'],
      category: doc['category'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'cost': cost,
      'stock': stock,
      'imgUrl': imgUrl,
      'color': colors,
      'category': category,
      'totalSold': totalSold,
    };
  }
}
