import 'package:flutter/material.dart';

class ViewItem extends StatelessWidget {
  const ViewItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item'),
        leading: const Icon(Icons.inventory),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Items'),
            leading: const Icon(Icons.menu),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Sections'),
            leading: const Icon(Icons.menu),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
