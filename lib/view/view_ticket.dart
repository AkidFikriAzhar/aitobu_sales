import 'package:flutter/material.dart';
import '../model/item.dart';

class ViewTicket extends StatefulWidget {
  const ViewTicket({super.key});

  @override
  State<ViewTicket> createState() => _ViewTicketState();
}

class _ViewTicketState extends State<ViewTicket> {
  // final List<Section> _category = [
  //   Section(name: 'No Category', id: '0'),
  //   Section(name: 'Food', id: '1'),
  //   Section(name: 'Drink', id: '2'),
  // ];
  final List<Item> _items = [
    Item(id: '0', name: 'Nasi kerabu bajet', price: 5, cost: 3, stock: 10, imgUrl: null, colors: Colors.red, category: null),
    Item(id: '1', name: 'Teh o ais', price: 2, cost: 1, stock: null, imgUrl: null, colors: Colors.orange, category: null),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket'),
        leading: const Icon(Icons.confirmation_num),
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, i) {
          Item listItem = _items[i];
          return ListTile(
            visualDensity: const VisualDensity(horizontal: 3),
            leading: CircleAvatar(
              backgroundColor: listItem.colors,
              radius: 15,
            ),
            title: Text(listItem.name),
            subtitle: listItem.stock == null ? const Text('--') : Text('Stock: ${listItem.stock.toString()}'),
            trailing: Text('RM${listItem.price}'),
            onTap: () {},
          );
        },
      ),
    );
  }
}
