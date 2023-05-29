import 'package:expense/constants/icons.dart';
import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'package:provider/provider.dart';
import '../models/databaseProvider.dart';
import 'package:intl/intl.dart';

class ExpenseForm extends StatefulWidget {
  const ExpenseForm({super.key});

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  var _title = TextEditingController();
  var _amount = TextEditingController();
  DateTime? _date;
  String _initialValue = 'Others';

  //
  _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime.now());

    if (pickedDate != null) {
      setState(() {
        _date = pickedDate;
      });
    }
  }
  //

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            //Title of Expense
            TextField(
              controller: _title,
              decoration: InputDecoration(labelText: 'Title of Expense'),
            ),
            const SizedBox(
              height: 20.0,
            ),
            //Amount of Expense
            TextField(
              controller: _amount,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Amount'),
            ),
            const SizedBox(
              height: 20.0,
            ),
            //Date Picker
            Row(
              children: [
                Expanded(
                  child: Text(_date != null
                      ? DateFormat('MMMM,DD,YYYY').format(_date!)
                      : 'Select Date'),
                ),
                IconButton(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_month),
                )
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            //Category
            Row(
              children: [
                const Expanded(child: Text('Category')),
                Expanded(
                  child: DropdownButton(
                    items: icons.keys
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ),
                        )
                        .toList(),
                    value: _initialValue,
                    onChanged: (newValue) {
                      setState(() {
                        _initialValue = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton.icon(
                onPressed: () {
                  if (_title.text != '' && _amount.text != '') {
                    //Make an expense object
                    final file = Expense(
                        id: 0,
                        title: _title.text,
                        amount: double.parse(_amount.text),
                        date: _date != null ? _date! : DateTime.now(),
                        category: _initialValue);

                    //Add  it to the database
                    provider.addExpense(file);
                    //Close the BottomSheet
                    Navigator.of(context).pop();
                  }
                },
                icon: const Icon(Icons.add),
                label: Text('Add Expense'))
          ],
        ),
      ),
    );
  }
}
