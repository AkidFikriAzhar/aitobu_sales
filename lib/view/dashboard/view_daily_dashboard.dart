import 'package:aitobu_sales/controller/controller_sales_report.dart';
import 'package:aitobu_sales/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ViewDailyDashboard extends StatefulWidget {
  final DateTime currentDate;
  const ViewDailyDashboard({super.key, required this.currentDate});

  @override
  State<ViewDailyDashboard> createState() => _ViewDailyDashboardState();
}

class _ViewDailyDashboardState extends State<ViewDailyDashboard> {
  @override
  void initState() {
    _generateReport = _controller.getDailyReport(widget.currentDate);
    super.initState();
  }

  late Future _generateReport;
  final _controller = ControllerSalesReport();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sales Report'),
          actions: [
            IconButton(
                onPressed: () {
                  context.push(MyRouter.pdfDailySales, extra: _controller);
                },
                icon: const Icon(Icons.picture_as_pdf)),
          ],
        ),
        body: FutureBuilder(
            future: _generateReport,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator.adaptive(),
                      SizedBox(height: 10),
                      Text('Generating sales report...'),
                    ],
                  ),
                );
              }

              return Center(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await _controller.getDailyReport(widget.currentDate);
                  },
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: 900,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        runAlignment: WrapAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              cardReport(
                                title: 'Total Sales',
                                icon: Icons.wallet,
                                content: 'RM ${_controller.totalSales.toStringAsFixed(2)}',
                                subtitle: 'Total revenue generate',
                              ),
                              cardReport(
                                title: 'Product Sold',
                                icon: Icons.local_drink_outlined,
                                content: '${_controller.productSold}',
                                subtitle: 'Total unit sold',
                              ),
                              cardReport(
                                title: 'Receipt Open',
                                icon: Icons.receipt,
                                content: '${_controller.receiptOpen}',
                                subtitle: 'Total todays transaction',
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Card(
                                  elevation: 10,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: SizedBox(
                                      width: 300,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Payment Methods', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                                          const Text(
                                            'Revenue by payment type',
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                          const SizedBox(height: 10),
                                          ListTile(
                                            leading: const CircleAvatar(child: Icon(Icons.payments)),
                                            title: Text('${_controller.totalCashPayment} Cash'),
                                            trailing: Text(
                                              'RM ${_controller.cashPayment.toStringAsFixed(2)}',
                                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Text('${_controller.percentCash().toStringAsFixed(0)}% of sales'),
                                          ),
                                          ListTile(
                                            leading: const CircleAvatar(child: Icon(Icons.qr_code)),
                                            title: Text('${_controller.totalQrPayment} Qr Payment'),
                                            trailing: Text(
                                              'RM ${_controller.qrPayment.toStringAsFixed(2)}',
                                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Text('${_controller.percentQr().toStringAsFixed(0)}% of sales'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Card(
                                  elevation: 10,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: SizedBox(
                                      width: 300,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Product breakdown', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                                          const Text(
                                            'Detail breakdown of product sold',
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                          const SizedBox(height: 10),
                                          ListView.builder(
                                              itemCount: _controller.breakdownProductName.length,
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, i) {
                                                final breakDown = _controller.breakdownProductName[i];
                                                return ListTile(
                                                  title: Text(breakDown.item),
                                                  subtitle: LinearProgressIndicator(
                                                    value: _controller.getBreakdownUnit(_controller.productSold, breakDown.quantity),
                                                  ),
                                                  trailing: Text('${breakDown.quantity.toString()} units'),
                                                );
                                              })
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }));
  }

  Padding cardReport({
    required String title,
    required String content,
    required String subtitle,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SizedBox(
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Icon(icon, color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  content,
                  style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
