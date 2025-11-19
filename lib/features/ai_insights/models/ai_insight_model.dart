import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_insight_model.freezed.dart';
part 'ai_insight_model.g.dart';

@freezed
class AIInsightModel with _$AIInsightModel {
  const factory AIInsightModel({
    required List<String> insights,
  }) = _AIInsightModel;

  factory AIInsightModel.fromJson(Map<String, dynamic> json) =>
      _$AIInsightModelFromJson(json);
}
