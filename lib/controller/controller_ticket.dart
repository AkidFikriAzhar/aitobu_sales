import 'package:aitobu_sales/model/item.dart';
import 'package:aitobu_sales/model/ticket.dart';
import 'package:flutter/material.dart';

class ControllerTicket {
  List<Item> items = [
    Item(id: '0', name: 'Nasi kerabu bajet', price: 5, cost: 3, stock: 10, imgUrl: null, colors: Colors.red, category: null),
    Item(id: '1', name: 'Teh o ais', price: 2, cost: 1, stock: null, imgUrl: null, colors: Colors.orange, category: null),
  ];

  List<Ticket> ticket = [];
}