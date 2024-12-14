import 'package:aitobu_sales/view/view_profile.dart';
import 'package:aitobu_sales/view/view_receipt.dart';
import 'package:aitobu_sales/view/view_sales.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transitioned_indexed_stack/transitioned_indexed_stack.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    Color navColor = ElevationOverlay.applySurfaceTint(Theme.of(context).colorScheme.surface, Theme.of(context).colorScheme.surfaceTint, 3);
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        systemNavigationBarContrastEnforced: true,
        systemNavigationBarColor: navColor,
        systemNavigationBarDividerColor: navColor,
        systemNavigationBarIconBrightness: Theme.of(context).brightness == Brightness.light ? Brightness.dark : Brightness.light,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.light ? Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
        body: FadeIndexedStack(
          index: _index,
          children: [
            const ViewSales(),
            const ViewReceipt(),
            ViewProfile(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          // labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.confirmation_num), label: 'Sales'),
            NavigationDestination(icon: Icon(Icons.receipt), label: 'Receipt'),
            NavigationDestination(icon: Icon(Icons.account_circle), label: 'Profile'),
          ],
          onDestinationSelected: (value) {
            setState(() {
              _index = value;
            });
          },
        ),
      ),
    );
  }
}
