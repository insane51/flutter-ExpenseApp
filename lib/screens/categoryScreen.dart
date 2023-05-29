import 'package:expense/widgets/category_screen/categoryFetcher.dart';
import 'package:expense/widgets/expense_form.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});
  static const name = '/category_screen'; // for routes

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catagory'),
      ),
      body: categoryFetcher(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (_) => const ExpenseForm()),
      ),
    );
  }
}
