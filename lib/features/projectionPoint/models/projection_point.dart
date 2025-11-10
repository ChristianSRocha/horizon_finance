import 'package:freezed_annotation/freezed_annotation.dart';

part 'projection_point.freezed.dart';
part 'projection_point.g.dart';

@freezed
class ProjectionPoint with _$ProjectionPoint {
  const factory ProjectionPoint({
    required DateTime date,
    required double balance,
  }) = _ProjectionPoint;

  factory ProjectionPoint.fromJson(Map<String, dynamic> json) =>
      _$ProjectionPointFromJson(json);
}
