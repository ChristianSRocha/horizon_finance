import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../transactions/models/transactions.dart';
import '../../metas/models/metas.dart';

class AIInsightsRepository {
  final SupabaseClient supabase;
  final String geminiApiKey;

  AIInsightsRepository({
    required this.supabase,
    required this.geminiApiKey,
  });


  Future<List<Transaction>>  fetchUserTransactions(String userId) async {
    final data = await supabase
        .from("transactions")
        .select()
        .eq("usuario_id", userId);

    return data.map<Transaction>((t) => Transaction.fromJson(t)).toList();
  }

  Future<List<Meta>> fetchUserGoals(String userId) async {
    final data = await supabase
        .from("metas")
        .select()
        .eq("usuario_id", userId)
        .eq("Ativo", true);
      
    return data.map<Meta>((t) => Meta.fromJson(t)).toList();
  }

  Future<List<String>> getInsightsFromGemini(String prompt) async {
    final url = Uri.parse(
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$geminiApiKey",
    );

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": prompt}
            ]
          }
        ]
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Gemini Error: ${response.body}");
    }

    final json = jsonDecode(response.body);

    final candidates = json["candidates"];
    if (candidates == null || candidates.isEmpty) {
      throw Exception("Resposta inválida do Gemini.");
    }

    String rawText = candidates[0]["content"]["parts"][0]["text"];

    rawText = _cleanMarkdown(rawText);

    // Tentar parsear como JSON
    try {
      final parsed = jsonDecode(rawText);
      if (parsed is List) {
        return List<String>.from(parsed);
      }
      throw Exception("Gemini não retornou uma lista");
    } catch (e) {
      // Fallback: separar por linhas
      return rawText
          .split("\n")
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty && !line.startsWith('[') && !line.startsWith(']'))
          .toList();
    }
  }

  /// Remove blocos de código Markdown e limpa o texto
  String _cleanMarkdown(String text) {
    // Remove ```json ou ``` no início/fim
    text = text.replaceAll(RegExp(r'^```json\s*', multiLine: true), '');
    text = text.replaceAll(RegExp(r'^```\s*', multiLine: true), '');
    text = text.replaceAll(RegExp(r'\s*```$', multiLine: true), '');
    
    return text.trim();
  }
}