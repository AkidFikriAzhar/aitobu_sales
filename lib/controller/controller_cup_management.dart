import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ControllerCupManagement {
  final inputAddCup = TextEditingController();

  Color colorCup(int totalCup) {
    switch (totalCup) {
      case <= 200:
        return Colors.orange.shade700;

      case <= 100:
        return Colors.red;

      default:
        return Colors.green;
    }
  }

  Future<void> addingCup() async {
    final firestore = FirebaseFirestore.instance;
    final cupRef = firestore.collection('dashboard').doc('global');
    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(cupRef);
      final newCup = snapshot.get('totalCup') + int.parse(inputAddCup.text);

      transaction.update(cupRef, {
        'totalCup': newCup,
      });
    });
  }

  Future<void> addCupDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Cup'),
            content: TextField(
              controller: inputAddCup,
              keyboardType: TextInputType.number,
              onSubmitted: (value) {
                context.pop();
                addingCup();
              },
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  context.pop();
                  addingCup();
                },
                child: const Text('Add'),
              ),
            ],
          );
        });
  }
}
