import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_expense.freezed.dart';
part 'category_expense.g.dart';

@freezed
class CategoryExpense with _$CategoryExpense {
  const factory CategoryExpense({
    required String category,
    required double totalAmount,
  }) = _CategoryExpense;

  factory CategoryExpense.fromJson(Map<String, dynamic> json) =>
      _$CategoryExpenseFromJson(json);
}
