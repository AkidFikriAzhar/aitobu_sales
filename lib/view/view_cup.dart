import 'package:aitobu_sales/model/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../controller/controller_cup_management.dart';

class ViewCup extends StatelessWidget {
  ViewCup({super.key});
  final _controllerCup = ControllerCupManagement();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cup Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('dashboard').doc('global').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator.adaptive(),
                      SizedBox(height: 10),
                      Text('Retrieving data...'),
                    ],
                  );
                }
                final Data data = Data.fromFirestore(snapshot.data);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_drink, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: 10),
                    Text(
                      'Current Cup',
                      style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 20),
                    ),
                    Text(
                      data.totalCup.toString(),
                      style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    FilledButton.icon(
                      onPressed: () {
                        _controllerCup.addCupDialog(context);
                      },
                      label: const Text('Add Cup'),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
