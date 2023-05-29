import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/databaseProvider.dart';
import '../../models/expense.dart';

class ConfirmBox extends StatelessWidget {
  const ConfirmBox({
    super.key,
    required this.exp,
  });

  final Expense exp;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return AlertDialog(
      title: Text('Delete ${exp.title}?'),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel')),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                provider.deleteExpense(exp, exp.category, exp.amount);
              },
              child: Text('Delete'))
        ],
      ),
    );
  }
}
