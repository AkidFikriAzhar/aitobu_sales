import 'package:aitobu_sales/model/section.dart';

class Item {
  final String id;
  final String name;
  final double price;
  final double? cost;
  final int? stock;
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
    required this.category,
  });

  factory Item.fromFirestore(dynamic doc) {
    return Item(
      id: doc['id'],
      name: doc['name'],
      price: doc['price'],
      cost: doc['cost'],
      stock: doc['stock'],
      imgUrl: doc['imgUrl'],
      colors: doc['color'],
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
    };
  }
}
