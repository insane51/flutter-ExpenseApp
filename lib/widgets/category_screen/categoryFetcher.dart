import 'package:expense/widgets/category_screen/category_list.dart';
import 'package:expense/widgets/category_screen/total_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/databaseProvider.dart';
import '../../screens/allExpenseScreen.dart';

class categoryFetcher extends StatefulWidget {
  const categoryFetcher({super.key});

  @override
  State<categoryFetcher> createState() => _categoryFetcherState();
}

class _categoryFetcherState extends State<categoryFetcher> {
  late Future _categoryList;
  Future _getCategoryList() async {
    final provider = Provider.of<DatabaseProvider>(this.context, listen: false);
    return await provider.fetchCategories();
  }

  @override
  void initState() {
    _categoryList = _getCategoryList();
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
      //in future parameter the parameter which is changing
      future: _categoryList,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          //If Connection has done  then check for errors or return the result
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: 250.0,
                    child: TotalChart(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Expenses',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(AllExpenseScreen.name);
                          },
                          child: Text('View All'))
                    ],
                  ),
                  Expanded(child: CategoryList())
                ],
              ),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
