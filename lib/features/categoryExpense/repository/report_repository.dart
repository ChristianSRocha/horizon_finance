import '../models/category_expense.dart';
import '../services/report_service.dart';

class ReportRepository {
  final ReportService service;

  ReportRepository(this.service);

  Future<List<CategoryExpense>> fetchExpensesByCategory(int year, int month) {
    return service.getExpensesByCategory(year: year, month: month);
  }
}
