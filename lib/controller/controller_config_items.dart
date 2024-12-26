// ignore_for_file: deprecated_member_use

import 'package:aitobu_sales/model/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ControllerConfigItems {
  final inputName = TextEditingController();
  final inputPrice = TextEditingController();

  final nameFocus = FocusNode();
  final priceFocus = FocusNode();

  final frmKey = GlobalKey<FormState>();

  String id = DateTime.now().microsecondsSinceEpoch.toString();

  List<Color> posColor = [
    Colors.grey,
    Colors.orange,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.brown,
    Colors.purple,
    Colors.lime,
  ];

  Future<void> deleteFirebase(String id) async {
    final itemRef = FirebaseFirestore.instance.collection('items').doc(id);

    await itemRef.update({'isDelete': true});
  }

  Future<void> editFirebase(String id, int colorVal) async {
    final itemRef = FirebaseFirestore.instance.collection('items').doc(id);

    itemRef.update({
      'name': inputName.text,
      'price': double.parse(inputPrice.text),
      'color': colorVal,
    });
  }

  Future<void> submitToFirebase(Color color, BuildContext context) async {
    try {
      final colourVal = color.value;

      final itemRef = FirebaseFirestore.instance.collection('items').doc(id);
      final item = Item(
        id: id,
        name: inputName.text.trim(),
        price: double.parse(inputPrice.text),
        cost: null,
        stock: null,
        imgUrl: null,
        colors: colourVal,
        category: null,
        totalSold: 0,
        isDelete: false,
      );

      await itemRef.set(item.toFirestore());

      if (context.mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item has been added!')),
        );
      }
    } on FirebaseException catch (e) {
      if (context.mounted) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                icon: const Icon(Icons.warning),
                title: const Text('Server Error'),
                content: Text(e.toString()),
              );
            });
      }
    }
  }
}
