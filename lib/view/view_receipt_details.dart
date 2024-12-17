import 'package:aitobu_sales/component/caption_title.dart';
import 'package:aitobu_sales/controller/controller_receipt_details.dart';
import 'package:aitobu_sales/controller/order_item.dart';
import 'package:aitobu_sales/model/item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jiffy/jiffy.dart';

import '../model/receipt.dart';

class ViewReceiptDetails extends StatefulWidget {
  final Receipt receipt;
  const ViewReceiptDetails({super.key, required this.receipt});

  @override
  State<ViewReceiptDetails> createState() => _ViewReceiptDetailsState();
}

class _ViewReceiptDetailsState extends State<ViewReceiptDetails> {
  @override
  void initState() {
    getList = _controllerReceiptDetails.itemList(widget.receipt.items);
    super.initState();
  }

  final _controllerReceiptDetails = ControllerReceiptDetails();
  late Future getList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt details'),
        actions: [
          PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: const Row(
                      children: [
                        Icon(Icons.delete),
                        SizedBox(width: 10),
                        Text('Delete'),
                      ],
                    ),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              icon: const Icon(Icons.delete),
                              title: const Text('Delete Receipt'),
                              content: const Text('Are you sure want to delete this receipt?'),
                              actions: [
                                TextButton(
                                  onPressed: () => context.pop(),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    context.pop();
                                    context.pop();
                                    await _controllerReceiptDetails.deleteReceipt(widget.receipt.runningNum);
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            );
                          });
                    },
                  ),
                ];
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Text(
                  'RM ${widget.receipt.totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 35,
                  ),
                ),
                Text(
                  'Total',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(15),
                  width: MediaQuery.of(context).size.width / 1.2,
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text.rich(
                        TextSpan(text: 'Employee: ', children: [
                          TextSpan(
                            text: _controllerReceiptDetails.setEmployee(widget.receipt.user),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                      ),
                      const SizedBox(height: 5),
                      Text.rich(
                        TextSpan(text: 'Payment Method: ', children: [
                          TextSpan(
                            text: widget.receipt.isCash == true ? 'Cash 💵' : 'QR Payment 📷',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                      ),
                      const SizedBox(height: 5),
                      Text.rich(
                        TextSpan(text: 'Running Number: ', children: [
                          TextSpan(
                            text: widget.receipt.runningNum,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Take away',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: CaptionTitle(title: 'Items'),
                ),
                FutureBuilder(
                    future: getList,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 50),
                              CircularProgressIndicator.adaptive(),
                              SizedBox(height: 15),
                              Text('Retreving data..'),
                            ],
                          ),
                        );
                      }

                      return Column(
                        children: [
                          ListView.builder(
                              itemCount: _controllerReceiptDetails.groupedItems.length,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, i) {
                                final OrderItem item = _controllerReceiptDetails.groupedItems[i];
                                final Item itemList = _controllerReceiptDetails.listItem[i];
                                return ListTile(
                                  title: Text(item.item),
                                  subtitle: Text('${item.quantity} x RM${itemList.price.toStringAsFixed(2)}'),
                                  trailing: Text(
                                    'RM ${_controllerReceiptDetails.calculateItem(item.quantity, itemList.price).toStringAsFixed(2)}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                );
                              }),
                          const SizedBox(height: 20),
                          const Divider(),
                          ListTile(
                            title: const Text(
                              'Total',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: Text(
                              'RM ${widget.receipt.totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                          ListTile(
                            title: const Text('Payment Received'),
                            trailing: Text(
                              'RM ${widget.receipt.cashReceived.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            title: Text(
                              Jiffy.parseFromDateTime(widget.receipt.timestamp.toDate()).format(pattern: 'dd/MM/yyyy, hh:mm:ss a'),
                              style: const TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ),
                        ],
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
