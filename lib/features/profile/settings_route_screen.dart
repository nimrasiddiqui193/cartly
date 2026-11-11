import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routes/app_router.dart';
import '../../core/theme/theme_controller.dart';
import '../../data/repositories/auth_repository.dart';
import 'settings_screen.dart';

class SettingsRouteScreen extends StatelessWidget {
  SettingsRouteScreen({super.key, required this.themeController});

  final ThemeController themeController;
  final AuthRepository _authRepository = AuthRepository();

  // ---------------------------------------------------------------------------
  // CHANGE PASSWORD
  // ---------------------------------------------------------------------------

  Future<void> _changePassword(BuildContext context) async {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    String? validationError;

    try {
      final passwords = await showDialog<({String current, String next})>(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: const Text('Change Password'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: currentController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Current Password',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: newController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'New Password',
                          prefixIcon: Icon(Icons.lock_reset),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: confirmController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Confirm New Password',
                          prefixIcon: Icon(Icons.verified_user_outlined),
                        ),
                      ),
                      if (validationError != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          validationError!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final current = currentController.text;
                      final next = newController.text;
                      final confirm = confirmController.text;

                      String? error;

                      if (current.isEmpty || next.isEmpty || confirm.isEmpty) {
                        error = 'Please complete all fields.';
                      } else if (next.length < 6) {
                        error = 'Password must contain at least 6 characters.';
                      } else if (next != confirm) {
                        error = 'New passwords do not match.';
                      } else if (next == current) {
                        error = 'Choose a different password.';
                      }

                      if (error != null) {
                        setDialogState(() {
                          validationError = error;
                        });
                        return;
                      }

                      Navigator.pop(dialogContext, (
                        current: current,
                        next: next,
                      ));
                    },
                    child: const Text('Update Password'),
                  ),
                ],
              );
            },
          );
        },
      );

      if (passwords == null || !context.mounted) return;

      try {
        await _authRepository.reauthenticateAndUpdatePassword(
          currentPassword: passwords.current,
          newPassword: passwords.next,
        );

        if (context.mounted) {
          _showMessage(context, 'Password updated successfully.');
        }
      } on FirebaseAuthException catch (error) {
        if (context.mounted) {
          _showMessage(context, error.message ?? 'Unable to update password.');
        }
      } catch (error) {
        if (context.mounted) {
          _showMessage(context, 'Unable to update password: $error');
        }
      }
    } finally {
      currentController.dispose();
      newController.dispose();
      confirmController.dispose();
    }
  }

  // ---------------------------------------------------------------------------
  // DELETE ACCOUNT
  // ---------------------------------------------------------------------------

  Future<void> _deleteAccount(BuildContext context) async {
    final passwordController = TextEditingController();

    try {
      final password = await showDialog<String>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Verify Your Identity'),
            content: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  if (passwordController.text.isNotEmpty) {
                    Navigator.pop(dialogContext, passwordController.text);
                  }
                },
                child: const Text('Delete Account'),
              ),
            ],
          );
        },
      );

      if (password == null || !context.mounted) return;

      try {
        await _authRepository.reauthenticateAndDeleteAccount(
          password: password,
        );

        if (!context.mounted) return;

        context.go(AppRouter.login);

        if (context.mounted) {
          _showMessage(context, 'Your account has been deleted.');
        }
      } on FirebaseAuthException catch (error) {
        if (context.mounted) {
          _showMessage(context, error.message ?? 'Unable to delete account.');
        }
      } catch (error) {
        if (context.mounted) {
          _showMessage(context, 'Unable to delete account: $error');
        }
      }
    } finally {
      passwordController.dispose();
    }
  }

  // ---------------------------------------------------------------------------
  // INFORMATION DIALOG
  // ---------------------------------------------------------------------------

  void _showInformation(BuildContext context, String title, String message) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // SNACKBAR MESSAGE
  // ---------------------------------------------------------------------------

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return SettingsScreen(
      themeMode: themeController.themeMode,
      onThemeChanged: themeController.changeTheme,
      onChangePassword: () => _changePassword(context),
      onPrivacyPolicy: () {
        _showInformation(
          context,
          'Privacy Policy',
          'Cartly uses your account information to provide shopping, '
              'wishlist, cart, and order services. Your account information '
              'is handled through Firebase services.',
        );
      },
      onTerms: () {
        _showInformation(
          context,
          'Terms & Conditions',
          'Use Cartly responsibly. Product availability, prices, and '
              'order information may change. Orders are subject to '
              'the applicable store policies.',
        );
      },
      onDeleteAccount: () => _deleteAccount(context),
    );
  }
}
