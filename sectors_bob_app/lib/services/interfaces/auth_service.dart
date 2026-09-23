import '../models/user_models.dart';

/// Authentication contract. The mock implementation lives under services/mock.
/// A real backend implementation can replace it without touching the UI.
abstract class AuthService {
  Future<AppUser> signInWithEmail(String email, String password);

  Future<AppUser> signUpWithEmail(String email, String password, String name);

  Future<AppUser> signInWithGoogle();

  Future<void> signOut();

  /// The current user read synchronously, or null when signed out. Splash uses
  /// this to decide whether to skip onboarding. The mock does not persist a
  /// session across launches, so it returns null on a cold start.
  AppUser? currentUser();

  /// Emits the current user, or null when signed out.
  Stream<AppUser?> authState();
}
