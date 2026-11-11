import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';

class AuthRepository {
  AuthRepository({AuthService? authService})
    : _authService = authService ?? AuthService();

  final AuthService _authService;

  User? get currentUser => _authService.currentUser;

  Stream<User?> get authStateChanges => _authService.authStateChanges;

  Future<UserCredential> register({
    required String name,
    required String email,
    required String password,
  }) {
    return _authService.register(name: name, email: email, password: password);
  }

  Future<UserCredential> login({
    required String email,
    required String password,
  }) {
    return _authService.login(email: email, password: password);
  }

  Future<void> logout() => _authService.logout();

  Future<void> resetPassword(String email) {
    return _authService.resetPassword(email);
  }

  Future<void> updateName(String name) {
    return _authService.updateName(name);
  }

  Future<void> updateEmail(String email) {
    return _authService.updateEmail(email);
  }

  Future<void> updatePassword(String newPassword) {
    return _authService.updatePassword(newPassword);
  }

  Future<void> reauthenticate({required String password}) {
    return _authService.reauthenticate(password: password);
  }

  Future<void> reauthenticateAndUpdatePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    return _authService.reauthenticateAndUpdatePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  Future<void> reauthenticateAndDeleteAccount({required String password}) {
    return _authService.reauthenticateAndDeleteAccount(password: password);
  }

  Future<void> deleteAccount() => _authService.deleteAccount();
}
