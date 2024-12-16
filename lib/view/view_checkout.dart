import 'package:aitobu_sales/controller/currency_formater.dart';
import 'package:aitobu_sales/model/item.dart';
import 'package:flutter/material.dart';

class ViewCheckout extends StatefulWidget {
  final List<Item> listItem;
  const ViewCheckout({super.key, required this.listItem});

  @override
  State<ViewCheckout> createState() => _ViewCheckoutState();
}

class _ViewCheckoutState extends State<ViewCheckout> {
  double totalPrice() {
    double result = 0;
    for (var total in widget.listItem) {
      result += total.price;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(
              initialValue: '20.00',
              textAlign: TextAlign.center,
              inputFormatters: [
                CurrencyInputFormatter(),
              ],
              decoration: const  InputDecoration(
                labelText: 'Total Amount (RM)'
              ),
            ),
          ],
        ),
      ),
    );
  }
}
