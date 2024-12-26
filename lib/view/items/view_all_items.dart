import 'package:aitobu_sales/model/item.dart';
import 'package:aitobu_sales/router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:go_router/go_router.dart';

class ViewAllItems extends StatelessWidget {
  ViewAllItems({super.key});

  final queryItem = FirebaseFirestore.instance
      .collection('items')
      .where('isDelete', isEqualTo: false)
      .withConverter<Item>(fromFirestore: (snapshot, _) => Item.fromFirestore(snapshot.data()!), toFirestore: (item, _) => item.toFirestore());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(MyRouter.configItems);
        },
        heroTag: 'item',
        label: const Text('Add'),
        icon: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("All Items"),
      ),
      body: FirestoreListView(
          query: queryItem,
          itemBuilder: (context, snapshot) {
            final Item item = snapshot.data();
            return ListTile(
              visualDensity: const VisualDensity(vertical: 3),
              leading: AdvancedAvatar(
                size: 35,
                decoration: BoxDecoration(color: Color(item.colors), shape: BoxShape.circle),
              ),
              title: Text(item.name),
              subtitle: Text('RM ${item.price.toStringAsFixed(2)}'),
              onTap: () {
                context.push(MyRouter.configItems, extra: item);
              },
            );
          }),
    );
  }
}
