import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/report_service.dart';
import '../repository/report_repository.dart';
import '../controller/category_chart_controller.dart';

// Supabase client provider
final supabaseProvider = Provider((ref) => Supabase.instance.client);

// Service provider
final reportServiceProvider = Provider(
  (ref) => ReportService(ref.watch(supabaseProvider)),
);

// Repository provider
final reportRepositoryProvider = Provider(
  (ref) => ReportRepository(ref.watch(reportServiceProvider)),
);

// Controller provider (StateNotifier)
final categoryChartControllerProvider = 
    StateNotifierProvider<CategoryChartController, CategoryChartState>(
  (ref) => CategoryChartController(
    ref.watch(reportRepositoryProvider),
  ),
);
