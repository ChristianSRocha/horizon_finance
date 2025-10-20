// lib/features/auth/models/auth_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(false) bool isLoading,
    @Default(false) bool isAuthenticated,
    String? userId,
    String? email,
    String? name,
    String? errorMessage,
  }) = _AuthState;
}
