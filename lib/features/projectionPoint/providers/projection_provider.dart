import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/projection_state.dart';
import '../services/dashboard_service.dart';

final dashboardServiceProvider = Provider<DashboardService>((ref) {
  return DashboardService();
});

final projectionProvider =
    StateNotifierProvider<ProjectionNotifier, ProjectionState>((ref) {
  final service = ref.watch(dashboardServiceProvider);
  return ProjectionNotifier(service);
});

class ProjectionNotifier extends StateNotifier<ProjectionState> {
  final DashboardService _service;

  ProjectionNotifier(this._service) : super(const ProjectionState());

  Future<void> loadProjection() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final points = await _service.generate90DayProjection();
      state = state.copyWith(isLoading: false, points: points);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}
