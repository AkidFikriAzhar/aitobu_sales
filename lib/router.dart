import 'package:aitobu_sales/view/home.dart';
import 'package:aitobu_sales/view/view_items.dart';
import 'package:aitobu_sales/view/view_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class MyRouter {
  static const home = '/';
  static const login = '/login';
  static const items = '/item';

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
    ],
  );
}
