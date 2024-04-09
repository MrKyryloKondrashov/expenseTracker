import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _category = Category.leisure;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final date = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);
    setState(() {
      _selectedDate = date;
    });
  }

  void _submitData() {
    final enteredAmount = double.tryParse(_amountController.text);
    bool isAmountInvalid = enteredAmount == null || enteredAmount < 0;
    if (_titleController.text.trim().isEmpty ||
        isAmountInvalid ||
        _selectedDate == null) {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('Invalid input'),
              content: const Text('Plase make input valid'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: const Text('Okay'))
              ],
            );
          });
      return;
    }
    widget.onAddExpense(Expense(
        title: _titleController.text.trim(),
        amount: enteredAmount,
        date: _selectedDate!,
        category: _category));
    Navigator.pop(context);
  }

  
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constrains) {
      final width = constrains.maxWidth;
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(children: [
            if (width >= 600)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _titleController,
                      maxLength: 50,
                      decoration: const InputDecoration(label: Text('Title')),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                      child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        label: Text('Amount'), prefix: Text('\$')),
                  )),
                ],
              )
            else
              TextField(
                controller: _titleController,
                maxLength: 50,
                decoration: const InputDecoration(label: Text('Title')),
              ),
            const SizedBox(
              height: 15,
            ),
            if (width >= 600)
              Row(
                children: [
                     DropdownButton(
                    value: _category,
                    items: Category.values
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.name.toUpperCase()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _category = value;
                      });
                    }),
                  const Spacer(),
                  Expanded(
                      child: Row(
                    children: [
                      Text(_selectedDate == null
                          ? 'No date selected'
                          : formater.format(_selectedDate!)),
                      IconButton(
                        icon: const Icon(Icons.calendar_month),
                        onPressed: _presentDatePicker,
                      )
                    ],
                  )),
                ],
              )
            else
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          label: Text('Amount'), prefix: Text('\$')),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                      child: Row(
                    children: [
                      Text(_selectedDate == null
                          ? 'No date selected'
                          : formater.format(_selectedDate!)),
                      IconButton(
                        icon: const Icon(Icons.calendar_month),
                        onPressed: _presentDatePicker,
                      )
                    ],
                  )),
                ],
              ),
            if(width >= 600)
            Row(
              children: [
                const Spacer(),
                ElevatedButton(
                    onPressed: _submitData, child: const Text('Save Expanse')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Clear Expanse'))
              ],)
            else 
            Row(
              children: [
                DropdownButton(
                    value: _category,
                    items: Category.values
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.name.toUpperCase()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _category = value;
                      });
                    }),
                const Spacer(),
                ElevatedButton(
                    onPressed: _submitData, child: const Text('Save Expanse')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Clear Expanse'))
              ],
            )
          ]),
        ),
      );
    });
  }
}
