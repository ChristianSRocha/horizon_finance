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
}