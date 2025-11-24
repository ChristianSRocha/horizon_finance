import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horizon_finance/features/auth/services/auth_service.dart';
import 'package:horizon_finance/features/users/model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final userServiceProvider = NotifierProvider<UserService, Profile?>(() {
  return UserService();
});

class UserService extends Notifier<Profile?> {
  SupabaseClient get _supabase => ref.read(supabaseClientProvider);

  @override
  Profile? build() {
    return null;
  }

  Future<void> getProfile() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        state = null;
        return;
      }

      final response =
          await _supabase.from('profiles').select().eq('id', userId).single();

      final profile = Profile.fromJson(response);
      state = profile;
    } catch (e) {
      state = null;
    }
  }

  Future<void> updateAvatar(File imageFile) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('Usuário não autenticado');

      final fileName = '$userId-${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      await _supabase.storage.from('avatars').upload(
            fileName,
            imageFile,
            fileOptions: const FileOptions(upsert: true),
          );

      final imageUrl = _supabase.storage.from('avatars').getPublicUrl(fileName);

      await _supabase.from('profiles').update({
        'avatar_url': imageUrl,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', userId);

      await getProfile();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProfile({String? name, String? email}) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('Usuário não autenticado');

      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (name != null) updates['name'] = name;
      if (email != null) updates['email'] = email;

      await _supabase.from('profiles').update(updates).eq('id', userId);

      await getProfile();
    } catch (e) {
      rethrow;
    }
  }
}