import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registerExpenses = [
    Expense(
        title: 'Fluuter Course',
        amount: 99,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: 'Dark souls 3',
        amount: 33.33,
        date: DateTime.now(),
        category: Category.leisure)
  ];

  _openAddExpenseOverlay() {
    showModalBottomSheet(
        isScrollControlled: true,
        constraints: const BoxConstraints(maxWidth: double.infinity, minHeight: double.infinity),
        useSafeArea: true,
        context: context,
        builder: (ctx) {
          return NewExpense(
            onAddExpense: _addExpense,
          );
        });
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registerExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final index = _registerExpenses.indexOf(expense);
    setState(() {
      _registerExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Expense deleted'),
        duration: const Duration(seconds: 10),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _registerExpenses.insert(index, expense);
              });
            })));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Widget content;
    if(_registerExpenses.isEmpty){
      content = const Center(child: Text('No expenses yet!'));
    }
    else{
      List<Widget> children =  [
              Expanded(child: Chart(expenses: _registerExpenses)),
              Expanded(
                  child: ExpensesList(
                expenses: _registerExpenses,
                removeExpense: _removeExpense,
              ))
            ];
      content = width < 600 ? Column(children: [... children]) :Row(children: [... children],);
    }


    

    return Scaffold(
        appBar: AppBar(
          title: const Text("Flutter ExpenseTracker"),
          actions: [
            IconButton(
                onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add))
          ],
        ),
        body: content);
  }
}
