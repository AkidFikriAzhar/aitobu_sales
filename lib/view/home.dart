import 'package:aitobu_sales/view/view_item.dart';
import 'package:aitobu_sales/view/view_receipt.dart';
import 'package:aitobu_sales/view/view_ticket.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: <Widget>[
        const ViewTicket(),
        const ViewProfile(),
        const ViewItem(),
      ][_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        // labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.confirmation_num), label: 'Ticket'),
          NavigationDestination(icon: Icon(Icons.receipt), label: 'Receipt'),
          NavigationDestination(icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
        onDestinationSelected: (value) {
          setState(() {
            _index = value;
          });
        },
      ),
    );
  }
}
