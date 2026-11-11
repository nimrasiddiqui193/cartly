import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService({FirebaseAuth? firebaseAuth})
    : _auth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  // ---------------------------------------------------------------------------
  // CURRENT USER
  // ---------------------------------------------------------------------------

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ---------------------------------------------------------------------------
  // REGISTER
  // ---------------------------------------------------------------------------

  Future<UserCredential> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final trimmedName = name.trim();
    final trimmedEmail = email.trim();

    if (trimmedName.isEmpty) {
      throw ArgumentError('Name cannot be empty.');
    }

    if (trimmedEmail.isEmpty) {
      throw ArgumentError('Email cannot be empty.');
    }

    if (password.length < 6) {
      throw ArgumentError('Password must contain at least 6 characters.');
    }

    final credential = await _auth.createUserWithEmailAndPassword(
      email: trimmedEmail,
      password: password,
    );

    await credential.user?.updateDisplayName(trimmedName);
    await credential.user?.reload();

    return credential;
  }

  // ---------------------------------------------------------------------------
  // LOGIN
  // ---------------------------------------------------------------------------

  Future<UserCredential> login({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  // ---------------------------------------------------------------------------
  // LOGOUT
  // ---------------------------------------------------------------------------

  Future<void> logout() {
    return _auth.signOut();
  }

  // ---------------------------------------------------------------------------
  // PASSWORD RESET
  // ---------------------------------------------------------------------------

  Future<void> resetPassword(String email) {
    return _auth.sendPasswordResetEmail(email: email.trim());
  }

  // ---------------------------------------------------------------------------
  // UPDATE PROFILE NAME
  // ---------------------------------------------------------------------------

  Future<void> updateName(String name) async {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      throw ArgumentError('Name cannot be empty.');
    }

    final user = _requireCurrentUser();

    await user.updateDisplayName(trimmedName);
    await user.reload();
  }

  // ---------------------------------------------------------------------------
  // UPDATE EMAIL
  // ---------------------------------------------------------------------------

  Future<void> updateEmail(String email) async {
    final trimmedEmail = email.trim();

    if (trimmedEmail.isEmpty) {
      throw ArgumentError('Email cannot be empty.');
    }

    final user = _requireCurrentUser();

    await user.verifyBeforeUpdateEmail(trimmedEmail);
  }

  // ---------------------------------------------------------------------------
  // UPDATE PASSWORD
  // ---------------------------------------------------------------------------

  Future<void> updatePassword(String newPassword) async {
    if (newPassword.length < 6) {
      throw ArgumentError('Password must contain at least 6 characters.');
    }

    final user = _requireCurrentUser();

    await user.updatePassword(newPassword);
  }

  // ---------------------------------------------------------------------------
  // REAUTHENTICATE
  // ---------------------------------------------------------------------------

  Future<void> reauthenticate({required String password}) async {
    final user = _requireCurrentUser();
    final email = user.email;

    if (email == null || email.isEmpty) {
      throw FirebaseAuthException(
        code: 'missing-email',
        message: 'The current account does not have an email address.',
      );
    }

    final credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );

    await user.reauthenticateWithCredential(credential);
  }

  // ---------------------------------------------------------------------------
  // REAUTHENTICATE AND UPDATE PASSWORD
  // ---------------------------------------------------------------------------

  Future<void> reauthenticateAndUpdatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (newPassword.length < 6) {
      throw ArgumentError('New password must contain at least 6 characters.');
    }

    await reauthenticate(password: currentPassword);

    final user = _requireCurrentUser();

    await user.updatePassword(newPassword);
  }

  // ---------------------------------------------------------------------------
  // REAUTHENTICATE AND DELETE ACCOUNT
  // ---------------------------------------------------------------------------

  Future<void> reauthenticateAndDeleteAccount({
    required String password,
  }) async {
    await reauthenticate(password: password);

    final user = _requireCurrentUser();

    await user.delete();
  }

  // ---------------------------------------------------------------------------
  // DELETE ACCOUNT
  // ---------------------------------------------------------------------------

  Future<void> deleteAccount() async {
    final user = _requireCurrentUser();

    await user.delete();
  }

  // ---------------------------------------------------------------------------
  // HELPER
  // ---------------------------------------------------------------------------

  User _requireCurrentUser() {
    final user = _auth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'No user is currently signed in.',
      );
    }

    return user;
  }
}
