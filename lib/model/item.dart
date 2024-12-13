import 'dart:ui';

import 'package:aitobu_sales/model/section.dart';

class Item {
  final String id;
  final String name;
  final double price;
  final double cost;
  final int? stock;
  final String? imgUrl;
  final Color colors;
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
}
