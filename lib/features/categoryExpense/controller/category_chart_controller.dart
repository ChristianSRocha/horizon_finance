import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/category_expense.dart';
import '../repository/report_repository.dart';

part 'category_chart_controller.freezed.dart';

@freezed
class CategoryChartState with _$CategoryChartState {
  const factory CategoryChartState({
    @Default(false) bool isLoading,
    @Default([]) List<CategoryExpense> data,
    String? error,
  }) = _CategoryChartState;
}

class CategoryChartController extends StateNotifier<CategoryChartState> {
  final ReportRepository repository;

  CategoryChartController(this.repository)
      : super(const CategoryChartState());

  Future<void> load(int year, int month) async {
  try {
    state = state.copyWith(isLoading: true, error: null);

    final result = await repository.fetchExpensesByCategory(year, month);

    state = state.copyWith(
      isLoading: false,
      data: result,
    );
  } catch (e) {
    state = state.copyWith(
      isLoading: false,
      error: e.toString(),
    );
  }
}
}
