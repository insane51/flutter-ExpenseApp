import 'package:expense/widgets/all_expense/all_expenses_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/databaseProvider.dart';
import 'expense_search.dart';

class AllExpenseFetcher extends StatefulWidget {
  const AllExpenseFetcher({super.key});

  @override
  State<AllExpenseFetcher> createState() => _AllExpenseFetcherState();
}

class _AllExpenseFetcherState extends State<AllExpenseFetcher> {
  late Future _allExpensesList;

  Future _getAllExpenses() async {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return await provider.fetchAllExpenses();
  }

  @override
  void initState() {
    super.initState();
    _allExpensesList = _getAllExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _allExpensesList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            // return Text('All Expences');
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: const [
                  ExpenseSearch(),
                  Expanded(child: AllExpensesList()),
                ],
              ),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
