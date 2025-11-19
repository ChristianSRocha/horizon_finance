import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider global para guardar a API KEY do Gemini.
/// O main.dart vai sobrescrever este valor.
final geminiApiKeyProvider = Provider<String>((ref) {
  throw UnimplementedError(
      "geminiApiKeyProvider deve ser sobrescrito no ProviderScope do main.dart");
});
