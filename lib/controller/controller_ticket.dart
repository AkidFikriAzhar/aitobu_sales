import 'package:aitobu_sales/model/ticket.dart';

class ControllerTicket {
  List<Ticket> ticket = [];

  double amount() {
    double result = 0;
    for (var tick in ticket) {
      result += tick.totalPrice;
    }
    return result;
  }
}
