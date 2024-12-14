import 'package:flutter/material.dart';

class ViewReceipt extends StatelessWidget {
  const ViewReceipt({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Receipt'),
          leading: const Icon(Icons.receipt),
        ),
        body: ListView.builder(
          itemCount: 30,
          itemBuilder: (context, i) {
            return ListTile(
              leading: const Icon(Icons.attach_money_outlined),
              trailing: Text('#$i'),
              title: const Text('RM 10'),
              onTap: () {},
              subtitle: const Text('2:39 PM'),
            );
          },
        ));
  }
}
