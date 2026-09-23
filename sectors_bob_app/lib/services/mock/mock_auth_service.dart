import 'dart:async';

import '../interfaces/auth_service.dart';
import '../models/user_models.dart';

/// In-memory mock auth. Simulates network latency and keeps a broadcast stream
/// so the router can react to sign-in and sign-out.
class MockAuthService implements AuthService {
  MockAuthService();

  final StreamController<AppUser?> _controller =
      StreamController<AppUser?>.broadcast();

  AppUser? _current;

  static const Duration _latency = Duration(milliseconds: 900);

  String _nameFromEmail(String email) {
    final String local = email.contains('@') ? email.split('@').first : email;
    if (local.isEmpty) {
      return 'Investor';
    }
    final String cleaned = local.replaceAll(RegExp(r'[._-]+'), ' ').trim();
    return cleaned
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((part) => part[0].toUpperCase() + part.substring(1))
        .join(' ');
  }

  @override
  Future<AppUser> signInWithEmail(String email, String password) async {
    await Future<void>.delayed(_latency);
    final AppUser user = AppUser(
      id: 'user-${email.hashCode.toUnsigned(20)}',
      email: email,
      displayName: _nameFromEmail(email),
    );
    _current = user;
    _controller.add(user);
    return user;
  }

  @override
  Future<AppUser> signUpWithEmail(
    String email,
    String password,
    String name,
  ) async {
    await Future<void>.delayed(_latency);
    final AppUser user = AppUser(
      id: 'user-${email.hashCode.toUnsigned(20)}',
      email: email,
      displayName: name.trim().isEmpty ? _nameFromEmail(email) : name.trim(),
    );
    _current = user;
    _controller.add(user);
    return user;
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    await Future<void>.delayed(_latency);
    const AppUser user = AppUser(
      id: 'google-mock-001',
      email: 'investor@gmail.com',
      displayName: 'Investor Google',
      isGoogle: true,
    );
    _current = user;
    _controller.add(user);
    return user;
  }

  @override
  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _current = null;
    _controller.add(null);
  }

  @override
  AppUser? currentUser() => _current;

  @override
  Stream<AppUser?> authState() {
    return _controller.stream;
  }

  void dispose() {
    _controller.close();
  }
}
