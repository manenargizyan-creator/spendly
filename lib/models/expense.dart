import 'category.dart';

class Expense {
  final String id;
  final String title;
  final int amount;
  final Category category;

  const Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
  });

  Expense copyWith({String? title, int? amount, Category? category}) {
    return Expense(
      id: id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
    );
  }
}
