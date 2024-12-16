import 'package:aitobu_sales/model/item.dart';
import 'package:aitobu_sales/view/home.dart';
import 'package:aitobu_sales/view/items/view_config_item.dart';
import 'package:aitobu_sales/view/items/view_all_items.dart';
import 'package:aitobu_sales/view/view_checkout.dart';
import 'package:aitobu_sales/view/view_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class MyRouter {
  static const home = '/';
  static const login = '/login';
  static const items = '/item';
  static const configItems = '/config';
  static const checkOut = '/checkout';

  final router = GoRouter(
    initialLocation: FirebaseAuth.instance.currentUser == null ? login : home,
    routes: [
      GoRoute(
        path: home,
        builder: (context, state) => const Home(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const ViewLogin(),
      ),
      GoRoute(
        path: items,
        builder: (context, state) => ViewAllItems(),
      ),
      GoRoute(
        path: configItems,
        builder: (context, state) => ViewConfigItem(currentItem: state.extra as Item?),
      ),
      GoRoute(
        path: checkOut,
        builder: (context, state) => ViewCheckout(listItem: state.extra as List<Item>),
      ),
    ],
  );
}
