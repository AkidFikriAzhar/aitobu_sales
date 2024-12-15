import 'package:aitobu_sales/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ViewAllItems extends StatelessWidget {
  const ViewAllItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(MyRouter.addItems);
        },
        heroTag: 'item',
        label: const Text('Add Item'),
        icon: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("All Items"),
      ),
    );
  }
}
