import 'dart:convert';

import '../repository/ai_insights_repository.dart';

class AIInsightsService {
  final AIInsightsRepository repository;

  AIInsightsService({required this.repository});

  Future<List<String>> generateInsights(String userId) async {
    final transactions = await repository.fetchUserTransactions(userId);

    final prompt = """
Você é um assistente financeiro. Analise as transações e gere exatamente 3 insights úteis.

REGRAS CRÍTICAS:
- Considere SOMENTE transações com "status": "ativo"
- Ignore transações com status "inativo"
- Seja direto e prático
- NÃO mencione status, código ou estruturas técnicas
- NÃO use markdown, blocos de código ou formatação
- Retorne APENAS um array JSON válido, exemplo: ["Insight 1", "Insight 2", "Insight 3"]

Transações para análise:
${jsonEncode(transactions.map((t) => t.toJson()).toList())}

Retorne SOMENTE o array JSON, sem texto adicional:
""";
    
    return await repository.getInsightsFromGemini(prompt);
  }
}