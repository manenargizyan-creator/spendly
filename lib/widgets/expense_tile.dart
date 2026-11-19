import 'package:flutter/material.dart';
import '../models/expense.dart';

class ExpenseTile extends StatelessWidget {
  final Expense expense;
  final VoidCallback onTap;

  const ExpenseTile({super.key, required this.expense, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        child: Text(
          expense.category.emoji,
          style: const TextStyle(fontSize: 22),
        ),
      ),
      title: Text(
        expense.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(expense.category.name),
      trailing: Text(
        '${expense.amount} դր.',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}
