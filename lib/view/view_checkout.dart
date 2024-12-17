import 'package:aitobu_sales/component/caption_title.dart';
import 'package:aitobu_sales/controller/controller_checkout.dart';
import 'package:aitobu_sales/controller/currency_formater.dart';
import 'package:aitobu_sales/model/ticket.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ViewCheckout extends StatefulWidget {
  final List<Ticket> listItem;
  const ViewCheckout({super.key, required this.listItem});

  @override
  State<ViewCheckout> createState() => _ViewCheckoutState();
}

class _ViewCheckoutState extends State<ViewCheckout> with TickerProviderStateMixin {
  @override
  void initState() {
    _controllerCheckout.inputCashReceived.text = _controllerCheckout.totalPrice(widget.listItem).toStringAsFixed(2);
    super.initState();
  }

  final _controllerCheckout = ControllerCheckout();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return BottomSheet(
                    showDragHandle: true,
                    animationController: BottomSheet.createAnimationController(this),
                    onClosing: () {},
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Select Payment Method',
                              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Choose a payment option below to complete the transaction for the customer.',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    _controllerCheckout.isCash = false;
                                    context.pop();
                                    context.pop(true);
                                    _controllerCheckout.submitData(widget.listItem);
                                  },
                                  label: const Text('QR Payment'),
                                  icon: const Icon(Icons.qr_code),
                                ),
                                const SizedBox(width: 30),
                                FilledButton.icon(
                                  onPressed: () {
                                    _controllerCheckout.isCash = true;
                                    context.pop();
                                    context.pop(true);
                                    _controllerCheckout.submitData(widget.listItem);
                                  },
                                  label: const Text('Cash'),
                                  icon: const Icon(Icons.payments),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      );
                    });
              });
        },
        label: const Text('Make Payment'),
        icon: const Icon(Icons.payments),
      ),
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: CaptionTitle(title: 'Cash Received (RM)'),
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: _controllerCheckout.inputCashReceived,
                textAlign: TextAlign.center,
                keyboardType: const TextInputType.numberWithOptions(),
                onChanged: (value) {
                  setState(() {});
                },
                inputFormatters: [
                  CurrencyInputFormatter(),
                ],
                // decoration: const InputDecoration(labelText: 'Cash Received'),
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: CaptionTitle(title: 'Item Details'),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 15,
                  child: ListView.builder(
                      itemCount: widget.listItem.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        final item = widget.listItem[i].item;
                        return ListTile(
                          visualDensity: const VisualDensity(vertical: 3),
                          leading: CircleAvatar(
                            backgroundColor: Color(item.colors),
                          ),
                          title: Text(item.name),
                          subtitle: Text('RM ${item.price.toStringAsFixed(2)}'),
                          trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  widget.listItem.removeAt(i);
                                  _controllerCheckout.inputCashReceived.text = _controllerCheckout.totalPrice(widget.listItem).toStringAsFixed(2);
                                });
                              },
                              icon: const Icon(Icons.delete)),
                        );
                      }),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.spaceAround,
                    runAlignment: WrapAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total:',
                            style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 18),
                          ),
                          Text(
                            'RM ${_controllerCheckout.totalPrice(widget.listItem).toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Change:',
                            style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 18),
                          ),
                          Text(
                            _controllerCheckout.totalChange(widget.listItem) <= 0 ? '--' : 'RM ${_controllerCheckout.totalChange(widget.listItem).toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}
