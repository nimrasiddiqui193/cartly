import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
    required this.onChangePassword,
    required this.onPrivacyPolicy,
    required this.onTerms,
    required this.onDeleteAccount,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;
  final VoidCallback onChangePassword;
  final VoidCallback onPrivacyPolicy;
  final VoidCallback onTerms;
  final VoidCallback onDeleteAccount;

  static const Color primaryOrange = Color(0xFFE68A45);
  static const Color darkOrange = Color(0xFFB95F2D);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: darkOrange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
        children: [
          _buildSectionTitle('Appearance', theme),
          const SizedBox(height: 10),
          Card(
            elevation: 2,
            shadowColor: Colors.black.withValues(alpha: 0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _iconContainer(Icons.palette_outlined),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Theme',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.system,
                        label: Text('System'),
                        icon: Icon(Icons.settings_suggest_outlined),
                      ),
                      ButtonSegment(
                        value: ThemeMode.light,
                        label: Text('Light'),
                        icon: Icon(Icons.light_mode_outlined),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        label: Text('Dark'),
                        icon: Icon(Icons.dark_mode_outlined),
                      ),
                    ],
                    selected: {themeMode},
                    onSelectionChanged: (selection) {
                      onThemeChanged(selection.first);
                    },
                    showSelectedIcon: false,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),
          _buildSectionTitle('Account & Security', theme),
          const SizedBox(height: 10),
          Card(
            elevation: 2,
            shadowColor: Colors.black.withValues(alpha: 0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildSettingTile(
                  icon: Icons.lock_reset_rounded,
                  title: 'Change Password',
                  subtitle: 'Update your account password',
                  onTap: onChangePassword,
                ),
                _buildDivider(theme),
                _buildSettingTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  subtitle: 'Learn how your information is handled',
                  onTap: onPrivacyPolicy,
                ),
                _buildDivider(theme),
                _buildSettingTile(
                  icon: Icons.description_outlined,
                  title: 'Terms & Conditions',
                  subtitle: 'Review the terms of using Cartly',
                  onTap: onTerms,
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          _buildSectionTitle('Danger Zone', theme),
          const SizedBox(height: 10),
          Card(
            elevation: 2,
            shadowColor: Colors.black.withValues(alpha: 0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: _buildSettingTile(
              icon: Icons.delete_forever_outlined,
              title: 'Delete Account',
              subtitle: 'Permanently delete your Cartly account',
              iconColor: theme.colorScheme.error,
              titleColor: theme.colorScheme.error,
              onTap: onDeleteAccount,
              showArrow: true,
            ),
          ),
          const SizedBox(height: 25),
          Center(
            child: Column(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: primaryOrange.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.shopping_bag_rounded,
                    color: primaryOrange,
                    size: 27,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Cartly',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: primaryOrange,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Shop smarter. Live better.',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w800,
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _iconContainer(IconData icon) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: primaryOrange.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.palette_outlined, color: primaryOrange, size: 21),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    Color? titleColor,
    bool showArrow = true,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: (iconColor ?? primaryOrange).withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor ?? primaryOrange, size: 21),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: titleColor,
        ),
      ),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 11)),
      trailing:
          showArrow ? const Icon(Icons.chevron_right_rounded, size: 21) : null,
      onTap: onTap,
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Divider(
      height: 1,
      indent: 70,
      endIndent: 16,
      color: theme.dividerColor.withValues(alpha: 0.35),
    );
  }
}
