import 'package:flutter/material.dart';
import '../widgets/all_expense/all_expense_fetcher.dart';

class AllExpenseScreen extends StatefulWidget {
  const AllExpenseScreen({super.key});
  static const name = '/allExpenses';

  @override
  State<AllExpenseScreen> createState() => _AllExpenseScreenState();
}

class _AllExpenseScreenState extends State<AllExpenseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('All Expenses')),
        body: AllExpenseFetcher());
  }
}
