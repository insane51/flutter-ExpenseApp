import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/databaseProvider.dart';
import '../expense_screen/expenseCard.dart';

class AllExpensesList extends StatefulWidget {
  const AllExpensesList({super.key});

  @override
  State<AllExpensesList> createState() => _AllExpensesListState();
}

class _AllExpensesListState extends State<AllExpensesList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (_, db, __) {
        var list = db.expense;
        return list.isNotEmpty
            ? ListView.builder(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: list.length,
                itemBuilder: (context, index) => ExpenseCard(list[index]))
            : const Center(
                child: Text('No Entries Found'),
              );
      },
    );
  }
}
