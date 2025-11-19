import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../repository/ai_insights_repository.dart';
import '../service/ai_insights_service.dart';
import '../controller/ai_insights_controller.dart';
import '../models/ai_insight_model.dart';
import 'gemini_api_key_provider.dart';


/// Client do supabase — igual ao seu auth
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});


/// Repository
final aiInsightsRepositoryProvider = Provider((ref) {
  final supabase = ref.watch(supabaseClientProvider);

  return AIInsightsRepository(
    supabase: supabase,
    geminiApiKey: ref.watch(geminiApiKeyProvider),
  );
});


/// Service
final aiInsightsServiceProvider = Provider((ref) {
  return AIInsightsService(
    repository: ref.watch(aiInsightsRepositoryProvider),
  );
});


/// Controller
final aiInsightsControllerProvider = Provider((ref) {
  return AIInsightsController(
    ref.watch(aiInsightsServiceProvider),
  );
});


/// FutureProvider → consumido pela UI
final aiInsightsProvider = FutureProvider<AIInsightModel>((ref) async {
  final supabase = ref.watch(supabaseClientProvider);
  final userId = supabase.auth.currentUser?.id;

  if (userId == null) {
    throw Exception("Usuário não autenticado");
  }

  final controller = ref.watch(aiInsightsControllerProvider);
  return controller.loadInsights(userId);
});
