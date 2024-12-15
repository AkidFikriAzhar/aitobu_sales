import 'package:aitobu_sales/view/home.dart';
import 'package:aitobu_sales/view/items/view_config_item.dart';
import 'package:aitobu_sales/view/items/view_items.dart';
import 'package:aitobu_sales/view/view_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class MyRouter {
  static const home = '/';
  static const login = '/login';
  static const items = '/item';
  static const addItems = '/add';

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
        builder: (context, state) => const ViewAllItems(),
      ),
      GoRoute(
        path: addItems,
        builder: (context, state) => const ViewConfigItem(),
      ),
    ],
  );
}
