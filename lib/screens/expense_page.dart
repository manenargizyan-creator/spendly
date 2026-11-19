import 'package:flutter/material.dart';

import 'expense_details_page.dart';
import '../models/expense.dart';
import '../models/category.dart';
import '../data/expense_data.dart';
import '../widgets/expense_tile.dart';

class ExpenseListPage extends StatefulWidget {
  const ExpenseListPage({super.key});

  @override
  State<ExpenseListPage> createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends State<ExpenseListPage> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  final List<Expense> expenses = [...initialExpenses];

  Category selectedCategory = Category.food;
  Category? selectedFilter;

  List<Expense> get filteredExpenses {
    if (selectedFilter == null) {
      return expenses;
    }

    return expenses
        .where((expense) => expense.category == selectedFilter)
        .toList();
  }

  int get totalAmount {
    return filteredExpenses.fold(0, (sum, expense) => sum + expense.amount);
  }

  void addExpense() {
    final title = titleController.text.trim();
    final amount = int.tryParse(amountController.text.trim());

    if (title.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Մուտքագրեք ճիշտ անվանում և գումար։')),
      );
      return;
    }

    final expense = Expense(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      amount: amount,
      category: selectedCategory,
    );

    setState(() {
      expenses.add(expense);
    });

    titleController.clear();
    amountController.clear();
    FocusScope.of(context).unfocus();
  }

  void deleteExpense(Expense expense, int index) {
    setState(() {
      expenses.remove(expense);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Ծախսը ջնջվեց։'),
        action: SnackBarAction(
          label: 'Վերադարձնել',
          onPressed: () {
            setState(() {
              final safeIndex = index.clamp(0, expenses.length);
              expenses.insert(safeIndex, expense);
            });
          },
        ),
      ),
    );
  }

  Future<void> openDetails(Expense expense) async {
    final newAmount = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (context) => ExpenseDetailsPage(expense: expense),
      ),
    );

    if (!mounted) return;

    if (newAmount != null) {
      setState(() {
        final index = expenses.indexWhere((item) => item.id == expense.id);

        if (index != -1) {
          expenses[index] = expense.copyWith(amount: newAmount);
        }
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ընդամենը՝ $totalAmount դր.'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Անվանում',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.edit),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Գումար',
                    suffixText: 'դր.',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.money),
                  ),
                ),

                const SizedBox(height: 12),

                Wrap(
                  spacing: 8,
                  children: Category.values.map((category) {
                    return ChoiceChip(
                      label: Text('${category.emoji} ${category.name}'),
                      selected: selectedCategory == category,
                      onSelected: (selected) {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: addExpense,
                    icon: const Icon(Icons.add),
                    label: const Text('Ավելացնել ծախս'),
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: const Text('Բոլորը'),
                    selected: selectedFilter == null,
                    onSelected: (selected) {
                      setState(() {
                        selectedFilter = null;
                      });
                    },
                  ),
                ),

                ...Category.values.map((category) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text('${category.emoji} ${category.name}'),
                      selected: selectedFilter == category,
                      onSelected: (selected) {
                        setState(() {
                          selectedFilter = selected ? category : null;
                        });
                      },
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: filteredExpenses.isEmpty
                ? const Center(
                    child: Text(
                      'Ծախսեր դեռ չկան։',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.separated(
                    itemCount: filteredExpenses.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final expense = filteredExpenses[index];
                      final originalIndex = expenses.indexOf(expense);

                      return Dismissible(
                        key: ValueKey(expense.id),
                        direction: DismissDirection.horizontal,

                        onDismissed: (direction) {
                          deleteExpense(expense, originalIndex);
                        },

                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),

                        secondaryBackground: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),

                        child: ExpenseTile(
                          expense: expense,
                          onTap: () => openDetails(expense),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
