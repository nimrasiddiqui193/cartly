import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routes/app_router.dart';
import '../../data/repositories/auth_repository.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthRepository _authRepository = AuthRepository();

  bool _isUpdating = false;
  bool _isLoggingOut = false;

  User? get _user => _authRepository.currentUser;

  String get _displayName {
    final name = _user?.displayName?.trim();
    return name == null || name.isEmpty ? 'Cartly User' : name;
  }

  String get _email => _user?.email ?? 'No email available';

  static const Color _orange = Color(0xFFE68A45);
  static const Color _deepOrange = Color(0xFFB95F2D);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile'), centerTitle: false),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 15),

          Center(
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _orange, width: 2),
              ),
              child: CircleAvatar(
                radius: 48,
                backgroundColor: _orange,
                backgroundImage:
                    _user?.photoURL != null
                        ? NetworkImage(_user!.photoURL!)
                        : null,
                child:
                    _user?.photoURL == null
                        ? const Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                          size: 50,
                        )
                        : null,
              ),
            ),
          ),

          const SizedBox(height: 16),

          Center(
            child: Text(
              _displayName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
          ),

          const SizedBox(height: 6),

          Center(
            child: Text(
              _email,
              style: TextStyle(color: theme.hintColor, fontSize: 14),
            ),
          ),

          const SizedBox(height: 25),

          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _isUpdating ? null : _editProfile,
              icon: const Icon(Icons.edit_outlined),
              label: const Text(
                'Edit Profile',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _orange,
                foregroundColor: Colors.white,
                disabledBackgroundColor: _orange.withValues(alpha: 0.5),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            'My Account',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),

          const SizedBox(height: 14),

          _ProfileOption(
            icon: Icons.receipt_long_outlined,
            title: 'My Orders',
            color: _orange,
            onTap: () => context.push(AppRouter.orders),
          ),

          _ProfileOption(
            icon: Icons.favorite_border_rounded,
            title: 'My Wishlist',
            color: _orange,
            onTap: () => context.push(AppRouter.wishlist),
          ),

          _ProfileOption(
            icon: Icons.settings_outlined,
            title: 'Settings',
            color: _orange,
            onTap: () => context.push(AppRouter.settings),
          ),

          const SizedBox(height: 22),

          Container(
            decoration: BoxDecoration(
              color:
                  isDark
                      ? Colors.red.withValues(alpha: 0.08)
                      : Colors.red.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              onTap: _isLoggingOut ? null : _confirmLogout,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 5,
              ),
              leading: const Icon(Icons.logout_rounded, color: Colors.red),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing:
                  _isLoggingOut
                      ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.red,
                        ),
                      )
                      : const Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.red,
                      ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _editProfile() async {
    final currentUser = _user;

    if (currentUser == null) {
      _showMessage('Please sign in again to edit your profile.');
      return;
    }

    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder:
            (_) => EditProfileScreen(
              initialName: currentUser.displayName ?? '',
              initialEmail: currentUser.email ?? '',
              onSave: _saveProfile,
            ),
      ),
    );

    if (!mounted || result == null) return;

    setState(() {});

    _showMessage(result);
  }

  Future<String?> _saveProfile({
    required String name,
    required String email,
  }) async {
    final currentUser = _user;

    if (currentUser == null) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'Please sign in again before updating your profile.',
      );
    }

    final oldName = currentUser.displayName?.trim() ?? '';
    final oldEmail = currentUser.email?.trim() ?? '';

    final nameChanged = name.trim() != oldName;
    final emailChanged = email.trim().toLowerCase() != oldEmail.toLowerCase();

    if (!nameChanged && !emailChanged) {
      return 'No changes were made to your profile.';
    }

    setState(() => _isUpdating = true);

    try {
      if (nameChanged) {
        await _authRepository.updateName(name.trim());
      }

      if (emailChanged) {
        await _authRepository.updateEmail(email.trim());

        return nameChanged
            ? 'Name updated. Please verify your new email address using the link sent to you.'
            : 'Verification email sent. Confirm your new email address to complete the change.';
      }

      return 'Your profile was updated successfully.';
    } finally {
      if (mounted) {
        setState(() => _isUpdating = false);
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: _deepOrange,
        ),
      );
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text(
            'Are you sure you want to log out of your Cartly account?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isLoggingOut = true);

    try {
      await _authRepository.logout();

      if (!mounted) return;

      context.go(AppRouter.login);
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;

      setState(() => _isLoggingOut = false);

      _showMessage(error.message ?? 'Logout failed. Please try again.');
    } catch (_) {
      if (!mounted) return;

      setState(() => _isLoggingOut = false);

      _showMessage('Logout failed. Please try again.');
    }
  }
}

class _ProfileOption extends StatelessWidget {
  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}
