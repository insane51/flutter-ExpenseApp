import 'package:expense/constants/icons.dart';
import 'package:expense/models/ex_category.dart';
import 'package:expense/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
// import 'package:provider/provider.dart';

class DatabaseProvider with ChangeNotifier {
  String _searchText = '';
  String get searchText => _searchText;
  set searchText(String value) {
    _searchText = value;
    notifyListeners();
  }

  //For store Categories in phone memory temperary
  List<ExpenseCategory> _categories = [];
  List<ExpenseCategory> get categories => _categories;
  List<Expense> _expense = [];
  List<Expense> get expense {
    return _searchText != ''
        ? _expense
            .where((e) =>
                e.title.toLowerCase().contains(_searchText.toLowerCase()))
            .toList()
        : _expense;
  }

  Database? _database;
  String _databaseName = 'expense.db';
  int _version = 1;

  static const cTable = 'categoryTable';
  static const eTable = 'expenseTable';

  // DatabaseProvider.privateConstructor();
  // static final DatabaseProvider instance =
  //     DatabaseProvider.privateConstructor();

  //CREATE Database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  initDatabase() async {
    final dirPath = await getDatabasesPath();
    final dbPath = join(dirPath, _databaseName);
    return await openDatabase(dbPath, version: _version, onCreate: onCreate);
  }

  Future onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE $cTable(
      title TEXT,
      entries INTEGER,
      totalAmount TEXT
    )''');

    await db.execute('''CREATE TABLE $eTable(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      amount TEXT,
      date TEXT,
      category TEXT
    )''');

    //Insert the initial categories

    for (int i = 0; i < icons.length; i++) {
      await db.insert(cTable, {
        'title': icons.keys.toList()[i],
        'entries': 0,
        'totalAmount': (0.0).toString()
      });
    }
  }

  // Method to fetch categories
  Future<List<ExpenseCategory>> fetchCategories() async {
    final db = await database;
    final response = await db.query(cTable);

    final converted = List<Map<String, dynamic>>.from(response);
    List<ExpenseCategory> nList = List.generate(converted.length,
        (index) => ExpenseCategory.fromString(converted[index]));
    _categories = nList;
    return _categories;
  }

  //Update Categories
  Future<void> updateCategory(
      String category, int entries, double totalAmount) async {
    final db = await database;
    await db
        .update(cTable,
            {'entries': entries, 'totalAmount': (totalAmount).toString()},
            where: 'title == ?', whereArgs: [category])
        .then((value) {
      final file =
          _categories.firstWhere((element) => element.title == category);
      file.entries = entries;
      file.totalAmount = totalAmount;
      notifyListeners();
    });
  }

  //Add Expense to the DB
  Future<void> addExpense(Expense exp) async {
    final db = await database;

    await db
        .insert(eTable, exp.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      final file = Expense(
          id: value,
          title: exp.title,
          amount: exp.amount,
          date: exp.date,
          category: exp.category);
      //Add the New Expense to the app memory
      _expense.add(file);
      //After adding notify listener to change state of  application
      notifyListeners();
      var cat = findCategory(exp.category);
      updateCategory(
          exp.category, cat.entries + 1, cat.totalAmount + exp.amount);
    });
  }

  Future<void> deleteExpense(
      Expense exp, String category, double amount) async {
    final db = await database;
    await db.delete(eTable, where: 'id==?', whereArgs: [exp.id]);
    _expense.removeWhere((element) => element.id == exp.id);
    notifyListeners();
    var ex = findCategory(category);
    updateCategory(category, ex.entries - 1, ex.totalAmount - amount);
  }

  ExpenseCategory findCategory(String title) {
    return _categories.firstWhere((element) => element.title == title);
  }

  //Fetch Expenses
  Future<List<Expense>> fetchExpenses(String category) async {
    final db = await database;
    final data =
        await db.query(eTable, where: 'category == ?', whereArgs: [category]);
    final converted = List<Map<String, dynamic>>.from(data);
    List<Expense> nList = List.generate(
        converted.length, (index) => Expense.fromString(converted[index]));
    _expense = nList;
    return _expense;
  }

  //Fetch All Expences List
  Future<List<Expense>> fetchAllExpenses() async {
    final db = await database;
    final response = await db.query(eTable);
    final converted = List<Map<String, dynamic>>.from(response);
    List<Expense> nList = List.generate(
        converted.length, (index) => Expense.fromString(converted[index]));
    _expense = nList;
    return _expense;
  }

  //Calculte Total Expences
  double calculateTotalAmount() {
    return _categories.fold(
        0.0, (previousValue, element) => previousValue + element.totalAmount);
  }

  //Calculate week  expenses
  List<Map<String, dynamic>> calculateWeekExpenses() {
    List<Map<String, dynamic>> data = [];

    for (int i = 0; i < 7; i++) {
      final weekDay = DateTime.now().subtract(Duration(days: i));
      double total = 0.0;
      //check how many transections happend that day
      for (int j = 0; j < _expense.length; j++) {
        if (_expense[j].date.year == weekDay.year &&
            _expense[j].date.month == weekDay.month &&
            _expense[j].date.day == weekDay.day) {
          total += _expense[j].amount;
        }
      }
      data.add({'day': weekDay, 'amount': total});
    }
    return data;
  }

  Map<String, dynamic> calculateEntriesAndAmount(String category) {
    double total = 0.0;
    var list = _expense.where((element) => element.category == category);
    for (final i in list) {
      total += i.amount;
    }
    return {'entries': list.length, 'totalAmount': total};
  }
}
