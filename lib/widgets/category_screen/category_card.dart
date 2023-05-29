import 'package:expense/models/ex_category.dart';
import 'package:flutter/material.dart';
import '../../screens/expenseScreen.dart';
import 'package:intl/intl.dart';

class CategoryCard extends StatelessWidget {
  final ExpenseCategory category;
  const CategoryCard(this.category, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ExpenseScreen.name, arguments: category.title);
      },
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(category.icon),
      ),
      title: Text(category.title),
      subtitle: Text('enteries : ${category.entries}'),
      trailing: Text(NumberFormat.currency(locale: 'en_IN', symbol: '₹')
          .format(category.totalAmount)),
    );
  }
}
