import '../service/ai_insights_service.dart';
import '../models/ai_insight_model.dart';

class AIInsightsController {
  final AIInsightsService service;

  AIInsightsController(this.service);

  Future<AIInsightModel> loadInsights(String userId) async {
    final insights = await service.generateInsights(userId);

    return AIInsightModel(insights: insights);
  }
}
