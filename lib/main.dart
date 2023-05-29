import 'package:expense/screens/allExpenseScreen.dart';
import 'package:expense/screens/categoryScreen.dart';
import 'package:expense/screens/expenseScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './models/databaseProvider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => DatabaseProvider(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: CategoryScreen.name,
      routes: {
        CategoryScreen.name: (_) => const CategoryScreen(),
        ExpenseScreen.name: (_) => const ExpenseScreen(),
        AllExpenseScreen.name: (_) => const AllExpenseScreen()
      },
    );
  }
}
