import 'package:aitobu_sales/controller/controller_ticket.dart';
import 'package:aitobu_sales/model/ticket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import '../model/item.dart';

class ViewSales extends StatefulWidget {
  const ViewSales({super.key});

  @override
  State<ViewSales> createState() => _ViewSalesState();
}

class _ViewSalesState extends State<ViewSales> {
  final controllerTicket = ControllerTicket();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: controllerTicket.ticket.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () {},
              label: Text('Charge ${controllerTicket.ticket.length}'),
              icon: const Icon(Icons.shopping_bag),
            ),
      appBar: AppBar(
        title: const Text('Sales'),
        leading: const Icon(Icons.confirmation_num),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                    onTap: () {
                      setState(() {
                        controllerTicket.ticket = [];
                      });
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.clear),
                        SizedBox(width: 10),
                        Text('Clear charge'),
                      ],
                    )),
              ];
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: controllerTicket.items.length,
        itemBuilder: (context, i) {
          Item listItem = controllerTicket.items[i];
          int itemNo = controllerTicket.ticket.where((e) {
            return e.item.id == listItem.id;
          }).length;
          return ListTile(
            visualDensity: const VisualDensity(horizontal: 3),
            leading: AdvancedAvatar(
              size: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: listItem.colors,
              ),
              children: [
                itemNo <= 0
                    ? const SizedBox()
                    : Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              itemNo.toString(),
                              style: TextStyle(color: Theme.of(context).colorScheme.onTertiary),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
            // leading: CircleAvatar(
            //   backgroundColor: listItem.colors,q
            //   radius: 15,
            //   child: Text(controllerTicket.ticket
            //       .where((e) {
            //         return e.item.id == listItem.id;
            //       })
            //       .length
            //       .toString()),
            // ),
            title: Text(listItem.name),
            subtitle: listItem.stock == null ? const Text('--') : Text('Stock: ${listItem.stock.toString()}'),
            trailing: Text(
              'RM${listItem.price}',
              style: const TextStyle(fontSize: 12),
            ),
            onTap: () {
              setState(() {
                controllerTicket.ticket.add(Ticket(item: listItem, totalPrice: listItem.price));
              });
            },
          );
        },
      ),
    );
  }
}
