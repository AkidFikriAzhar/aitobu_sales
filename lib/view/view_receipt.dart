import 'package:aitobu_sales/component/caption_title.dart';
import 'package:aitobu_sales/model/receipt.dart';
import 'package:aitobu_sales/router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:jiffy/jiffy.dart';

class ViewReceipt extends StatelessWidget {
  const ViewReceipt({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Receipt'),
          leading: const Icon(Icons.receipt),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('receipt').orderBy('timestamp', descending: false).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator.adaptive(),
                      SizedBox(height: 10),
                      Text('Retreiving data...'),
                    ],
                  ),
                );
              }

              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.browser_not_supported,
                        size: 120,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Receipt not availabe! Please try again later',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final List<Receipt> receiptList = snapshot.data!.docs.map((doc) {
                return Receipt.fromFirestore(doc.data());
              }).toList();

              return GroupedListView<Receipt, DateTime>(
                elements: receiptList,
                groupBy: (element) {
                  return DateTime(element.timestamp.toDate().year, element.timestamp.toDate().month, element.timestamp.toDate().day);
                },
                groupSeparatorBuilder: (dateTime) => Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CaptionTitle(title: Jiffy.parseFromDateTime(dateTime).format(pattern: 'EEEE, d MMMM y')),
                      IconButton(
                        tooltip: 'Sales report',
                        onPressed: () {},
                        icon: const Icon(Icons.analytics),
                      ),
                    ],
                  ),
                ),
                itemBuilder: (context, Receipt receipt) {
                  return ListTile(
                    visualDensity: const VisualDensity(vertical: 2),
                    leading: CircleAvatar(child: Icon(receipt.isCash == true ? Icons.payments : Icons.qr_code)),
                    title: Text('RM ${receipt.totalPrice.toStringAsFixed(2)}'),
                    subtitle: Text(Jiffy.parseFromDateTime(receipt.timestamp.toDate()).format(pattern: 'hh:mm:ss a')),
                    trailing: Text(receipt.runningNum),
                    onTap: () {
                      context.push(MyRouter.receiptDetails, extra: receipt);
                    },
                  );
                },
                order: GroupedListOrder.DESC,
              );

              // return ListView.builder(
              //     itemCount: snapshot.data!.size,
              //     itemBuilder: (context, index) {
              //       final Receipt receipt = Receipt.fromFirestore(snapshot.data!.docs[index]);
              //       final date = Jiffy.parseFromDateTime(receipt.timestamp.toDate()).format(pattern: 'hh:mm:ss a');
              //       return ListTile(
              //         visualDensity: const VisualDensity(vertical: 2),
              //         leading: CircleAvatar(child: Icon(receipt.isCash == true ? Icons.payments : Icons.qr_code)),
              //         title: Text('RM ${receipt.totalPrice.toStringAsFixed(2)}'),
              //         subtitle: Text(date),
              //         trailing: Text(receipt.runningNum),
              //         onTap: () {
              //           context.push(MyRouter.receiptDetails, extra: receipt);
              //         },
              //       );
              //     });
            }));
  }
}
