import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/projection_point.dart';

part 'projection_state.freezed.dart';
part 'projection_state.g.dart';

@freezed
class ProjectionState with _$ProjectionState {
  const factory ProjectionState({
    @Default(false) bool isLoading,
    @Default([]) List<ProjectionPoint> points,
    String? errorMessage,
  }) = _ProjectionState;

  factory ProjectionState.fromJson(Map<String, dynamic> json) =>
      _$ProjectionStateFromJson(json);
}
