import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/interfaces/auth_service.dart';
import '../../services/models/user_models.dart';
import '../../services/providers.dart';

/// Drives the auth screens. Wraps [AuthService] and exposes a loading and error
/// state through AsyncValue, so the login and sign up screens can show a spinner
/// during the mock latency and an inline error on failure.
///
/// The state holds the signed-in [AppUser] on success, or null before any
/// attempt. Screens listen for a non-null value to know when to route on.
class AuthController extends AutoDisposeAsyncNotifier<AppUser?> {
  @override
  Future<AppUser?> build() async => null;

  AuthService get _service => ref.read(authServiceProvider);

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue<AppUser?>.loading();
    state = await AsyncValue.guard<AppUser?>(
      () => _service.signInWithEmail(email.trim(), password),
    );
  }

  Future<void> signUp(String name, String email, String password) async {
    state = const AsyncValue<AppUser?>.loading();
    state = await AsyncValue.guard<AppUser?>(
      () => _service.signUpWithEmail(email.trim(), password, name.trim()),
    );
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncValue<AppUser?>.loading();
    state = await AsyncValue.guard<AppUser?>(_service.signInWithGoogle);
  }
}

final AutoDisposeAsyncNotifierProvider<AuthController, AppUser?>
    authControllerProvider =
    AsyncNotifierProvider.autoDispose<AuthController, AppUser?>(
  AuthController.new,
);
