import 'package:expense/constants/icons.dart';
import 'package:flutter/material.dart';

class ExpenseCategory {
  String title;
  int entries = 0;
  double totalAmount = 0.0;
  final IconData icon;
  // Constructor
  ExpenseCategory(
      {required this.title,
      required this.entries,
      required this.totalAmount,
      required this.icon});

  //To convert object into map to store in DB
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'entries': entries,
      'totalAmount': totalAmount.toString(),
    };
  }

  //From String to  ExpenseCatory object
  factory ExpenseCategory.fromString(Map<String, dynamic> value) {
    return ExpenseCategory(
        title: value['title'],
        entries: value['entries'],
        totalAmount: double.parse(value['totalAmount']),
        icon: icons[value['title']]);
  }
}
