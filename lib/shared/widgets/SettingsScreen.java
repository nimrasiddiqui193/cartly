
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode>? onThemeChanged;
  final VoidCallback? onChangePassword;
  final VoidCallback? onPrivacyPolicy;
  final VoidCallback? onTerms;
  final VoidCallback? onDeleteAccount;

  const SettingsScreen({
    super.key,
    this.themeMode = ThemeMode.system,
    this.onThemeChanged,
    this.onChangePassword,
    this.onPrivacyPolicy,
    this.onTerms,
    this.onDeleteAccount,
  });

  String _themeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System Default';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Appearance',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.palette_outlined,
                color: Color(0xFFC96B2C),
              ),
              title: const Text('App Theme'),
              subtitle: Text(_themeName(themeMode)),
              trailing: DropdownButton<ThemeMode>(
                value: themeMode,
                underline: const SizedBox(),
                items: ThemeMode.values.map((mode) {
                  return DropdownMenuItem(
                    value: mode,
                    child: Text(_themeName(mode)),
                  );
                }).toList(),
                onChanged: (mode) {
                  if (mode != null) {
                    onThemeChanged?.call(mode);
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            'Account & Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _SettingsOption(
            icon: Icons.lock_outline,
            title: 'Change Password',
            onTap: onChangePassword,
          ),
          _SettingsOption(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: onPrivacyPolicy,
          ),
          _SettingsOption(
            icon: Icons.description_outlined,
            title: 'Terms & Conditions',
            onTap: onTerms,
          ),
          const SizedBox(height: 25),
          const Text(
            'Danger Zone',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _SettingsOption(
            icon: Icons.delete_outline,
            title: 'Delete Account',
            iconColor: Colors.red,
            textColor: Colors.red,
            onTap: onDeleteAccount,
          ),
        ],
      ),
    );
  }
}

class _SettingsOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? textColor;

  const _SettingsOption({
    required this.icon,
    required this.title,
    this.onTap,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 9),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: iconColor ?? const Color(0xFFC96B2C),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
