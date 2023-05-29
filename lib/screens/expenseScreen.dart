import 'package:flutter/material.dart';
import '../widgets/expense_screen/expenseFetcher.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});
  static const name = '/expenseScreen';

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(title: Text('${category} Expense Screen')),
      body: ExpenseFetcher(category),
    );
  }
}
