import 'package:aitobu_sales/controller/controller_cup_management.dart';
import 'package:aitobu_sales/controller/controller_ticket.dart';
import 'package:aitobu_sales/model/data.dart';
import 'package:aitobu_sales/model/ticket.dart';
import 'package:aitobu_sales/router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:go_router/go_router.dart';
import '../model/item.dart';

class ViewSales extends StatefulWidget {
  const ViewSales({super.key});

  @override
  State<ViewSales> createState() => _ViewSalesState();
}

class _ViewSalesState extends State<ViewSales> {
  @override
  void initState() {
    _cupQuery = FirebaseFirestore.instance.collection('dashboard').doc('global').snapshots();
    super.initState();
  }

  final _controllerTicket = ControllerTicket();
  final _controllerCup = ControllerCupManagement();

  final _itemQuery = FirebaseFirestore.instance.collection('items').withConverter(
        fromFirestore: (snapshot, _) => Item.fromFirestore(snapshot.data()!),
        toFirestore: (item, _) => item.toFirestore(),
      );
  late Stream _cupQuery;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _controllerTicket.ticket.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () async {
                final bool? isPay = await context.push<bool>(MyRouter.checkOut, extra: _controllerTicket.ticket);

                if (isPay == true) {
                  await Future.delayed(const Duration(seconds: 1));
                  setState(() {
                    _controllerTicket.ticket = [];
                  });
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Payment completed!'),
                      duration: Duration(seconds: 1),
                    ));
                  }
                }
                setState(() {});
              },
              label: Text('Charge RM${_controllerTicket.amount().toStringAsFixed(2)}'),
              icon: const Icon(Icons.shopping_bag),
            ),
      appBar: AppBar(
        title: const Text('Sales'),
        leading: StreamBuilder(
            stream: _cupQuery,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return TextButton(
                  onPressed: () {},
                  child: const SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator.adaptive(),
                  ),
                );
              }
              final Data data = Data.fromFirestore(snapshot.data);
              return Tooltip(
                message: 'Total Cup',
                child: TextButton(
                  onPressed: () {
                    _controllerCup.addCupDialog(context);
                  },
                  child: FittedBox(
                    child: Text(
                      data.totalCup.toString(),
                      style: TextStyle(fontSize: 17, color: _controllerCup.colorCup(data.totalCup, context)),
                    ),
                  ),
                ),
              );
            }),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                    onTap: () {
                      setState(() {
                        _controllerTicket.ticket = [];
                      });
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.clear),
                        SizedBox(width: 10),
                        Text('Clear ticket'),
                      ],
                    )),
              ];
            },
          )
        ],
      ),
      body: FirestoreListView(
          query: _itemQuery,
          itemBuilder: (context, snapshot) {
            final myItem = snapshot.data();
            int itemNo = _controllerTicket.ticket.where((e) {
              return e.item.id == myItem.id;
            }).length;
            return ListTile(
              visualDensity: const VisualDensity(horizontal: 3),
              leading: AdvancedAvatar(
                size: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(myItem.colors),
                ),
              ),
              title: Text(myItem.name),
              subtitle: Text('RM${myItem.price.toStringAsFixed(2)}'),
              trailing: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                curve: Curves.bounceInOut,
                height: itemNo <= 0 ? 0 : 25,
                width: itemNo <= 0 ? 0 : 25,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: FittedBox(
                    child: Text(
                      itemNo.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ),
              ),
              onTap: () {
                setState(() {
                  _controllerTicket.ticket.add(Ticket(item: myItem, totalPrice: myItem.price));
                });
              },
            );
          }),
      // body: ListView.builder(
      //   itemCount: controllerTicket.items.length,
      //   itemBuilder: (context, i) {
      //     Item listItem = controllerTicket.items[i];
      //     int itemNo = controllerTicket.ticket.where((e) {
      //       return e.item.id == listItem.id;
      //     }).length;
      //     return ListTile(
      //       visualDensity: const VisualDensity(horizontal: 3),
      //       leading: AdvancedAvatar(
      //         size: 35,
      //         decoration: BoxDecoration(
      //           shape: BoxShape.circle,
      //           color: Color(listItem.colors),
      //         ),
      //         children: [
      //           itemNo <= 0
      //               ? const SizedBox()
      //               : Align(
      //                   alignment: Alignment.topRight,
      //                   child: Container(
      //                     height: 15,
      //                     width: 15,
      //                     decoration: BoxDecoration(
      //                       color: Theme.of(context).colorScheme.tertiary,
      //                       shape: BoxShape.circle,
      //                     ),
      //                     child: Center(
      //                       child: Text(
      //                         itemNo.toString(),
      //                         style: TextStyle(color: Theme.of(context).colorScheme.onTertiary),
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //         ],
      //       ),
      //       // leading: CircleAvatar(
      //       //   backgroundColor: listItem.colors,q
      //       //   radius: 15,
      //       //   child: Text(controllerTicket.ticket
      //       //       .where((e) {
      //       //         return e.item.id == listItem.id;
      //       //       })
      //       //       .length
      //       //       .toString()),
      //       // ),
      //       title: Text(listItem.name),
      //       subtitle: listItem.stock == null ? const Text('--') : Text('Stock: ${listItem.stock.toString()}'),
      //       trailing: Text(
      //         'RM${listItem.price.toStringAsFixed(2)}',
      //         style: const TextStyle(fontSize: 12),
      //       ),
      //       onTap: () {
      //         setState(() {
      //           controllerTicket.ticket.add(Ticket(item: listItem, totalPrice: listItem.price));
      //         });
      //       },
      //     );
      //   },
      // ),
    );
  }
}
