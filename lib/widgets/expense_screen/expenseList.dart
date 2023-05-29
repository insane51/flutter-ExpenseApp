import 'package:expense/models/databaseProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'expenseCard.dart';

class ExpenseList extends StatefulWidget {
  const ExpenseList({super.key});

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, db, __) {
        var exList = db.expense;
        return exList.isNotEmpty
            ? ListView.builder(
                itemCount: exList.length,
                itemBuilder: (context, index) => ExpenseCard(exList[index]))
            : const Center(child: Text('No Expense Added'));
      },
    );
  }
}
