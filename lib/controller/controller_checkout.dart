import 'package:aitobu_sales/model/receipt.dart';
import 'package:aitobu_sales/model/ticket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ControllerCheckout {
  final inputCashReceived = TextEditingController();

  double totalPrice(List<Ticket> listItem) {
    double result = 0;
    for (var total in listItem) {
      result += total.item.price;
    }

    return result;
  }

  double totalChange(List<Ticket> listItem) {
    double result = 0;
    double cashReceived = double.parse(inputCashReceived.text);
    double totalSales = totalPrice(listItem);
    result = cashReceived - totalSales;
    return result;
  }

  bool isCash = false;

  Future<String> generateRunningNum() async {
    String result = '#000000';
    final int year = DateTime.now().year % 100;
    const String branch = '01';
    int currentID = 0;
    final receiptRef = await FirebaseFirestore.instance.collection('receipt').get();

    currentID = receiptRef.docs.length;
    result = '#$year$branch${currentID.toString().padLeft(2, '0')}';
    return result;
  }

  Future<void> submitData(List<Ticket> listItem) async {
    final userAcc = FirebaseAuth.instance.currentUser;
    final String currentRunningNum = await generateRunningNum();
    List<String> itemId = [];
    for (var getId in listItem) {
      itemId.add(getId.item.id);
    }
    final receiptRef = FirebaseFirestore.instance.collection('receipt').doc(currentRunningNum);
    final Receipt receipt = Receipt(
      user: userAcc!.email.toString(),
      runningNum: currentRunningNum,
      isCash: isCash,
      totalPrice: totalPrice(listItem),
      cashReceived: double.parse(inputCashReceived.text),
      timestamp: Timestamp.now(),
      items: itemId,
      isReturn: false,
    );
    await receiptRef.set(receipt.toFirestore());
  }
}
