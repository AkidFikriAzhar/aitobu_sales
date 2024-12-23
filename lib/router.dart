import 'package:aitobu_sales/controller/controller_sales_report.dart';
import 'package:aitobu_sales/model/item.dart';
import 'package:aitobu_sales/model/receipt.dart';
import 'package:aitobu_sales/model/ticket.dart';
import 'package:aitobu_sales/view/dashboard/view_daily_dashboard.dart';
import 'package:aitobu_sales/view/home.dart';
import 'package:aitobu_sales/view/items/view_config_item.dart';
import 'package:aitobu_sales/view/items/view_all_items.dart';
import 'package:aitobu_sales/view/view_checkout.dart';
import 'package:aitobu_sales/view/view_cup.dart';
import 'package:aitobu_sales/view/view_login.dart';
import 'package:aitobu_sales/view/view_pdf_sales.dart';
import 'package:aitobu_sales/view/view_receipt_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class MyRouter {
  static const home = '/';
  static const login = '/login';
  static const items = '/item';
  static const configItems = '/config';
  static const checkOut = '/checkout';
  static const receiptDetails = '/details';
  static const cup = '/cup';
  static const report = '/report';
  static const pdfDailySales = '/pdf_daily';

  final router = GoRouter(
    initialLocation: FirebaseAuth.instance.currentUser == null ? login : home,
    routes: [
      GoRoute(
        path: home,
        builder: (context, state) => const Home(),
        routes: [
          GoRoute(
            path: items,
            builder: (context, state) => ViewAllItems(),
          ),
          GoRoute(
            path: cup,
            builder: (context, state) => ViewCup(),
          ),
          GoRoute(
            path: configItems,
            builder: (context, state) => ViewConfigItem(currentItem: state.extra as Item?),
          ),
          GoRoute(
            path: checkOut,
            builder: (context, state) => ViewCheckout(listItem: state.extra as List<Ticket>),
          ),
          GoRoute(
            path: receiptDetails,
            builder: (context, state) => ViewReceiptDetails(receipt: state.extra as Receipt),
          ),
          GoRoute(
            path: report,
            builder: (context, state) => ViewDailyDashboard(currentDate: state.extra as DateTime),
          ),
        ],
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const ViewLogin(),
      ),
      GoRoute(
        path: pdfDailySales,
        builder: (context, state) => ViewPdfSales(controller: state.extra as ControllerSalesReport),
      ),
    ],
  );
}
