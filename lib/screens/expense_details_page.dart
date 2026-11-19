import 'package:flutter/material.dart';
import '../models/expense.dart';

class ExpenseDetailsPage extends StatefulWidget {
  final Expense expense;

  const ExpenseDetailsPage({super.key, required this.expense});

  @override
  State<ExpenseDetailsPage> createState() => _ExpenseDetailsPageState();
}

class _ExpenseDetailsPageState extends State<ExpenseDetailsPage> {
  late TextEditingController amountController;

  @override
  void initState() {
    super.initState();

    amountController = TextEditingController(
      text: widget.expense.amount.toString(),
    );
  }

  void saveAmount() {
    final newAmount = int.tryParse(amountController.text.trim());

    if (newAmount == null || newAmount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Մուտքագրեք ճիշտ գումար։')));
      return;
    }

    Navigator.pop(context, newAmount);
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ծախսի մանրամասներ'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                widget.expense.category.emoji,
                style: const TextStyle(fontSize: 65),
              ),
            ),

            const SizedBox(height: 25),

            Text(
              'Անվանում՝ ${widget.expense.title}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Text(
              'Կատեգորիա՝ ${widget.expense.category.name}',
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 25),

            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Նոր գումար',
                suffixText: 'դր.',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.money),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveAmount,
                child: const Text('Պահպանել'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
