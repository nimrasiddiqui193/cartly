import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/utils/validators.dart';

class EditProfileScreen extends StatefulWidget {
  final String initialName;
  final String initialEmail;

  final Future<String?> Function({required String name, required String email})?
  onSave;

  const EditProfileScreen({
    super.key,
    this.initialName = '',
    this.initialEmail = '',
    this.onSave,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  static const Color _orange = Color(0xFFE68A45);
  static const Color _deepOrange = Color(0xFFB95F2D);
  static const Color _darkBrown = Color(0xFF713817);
  static const Color _warmBackground = Color(0xFFFFF8F1);

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.initialName);
    _emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_isSaving) return;

    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final saveCallback = widget.onSave;

    if (saveCallback == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to save profile changes.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final message = await saveCallback(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
      );

      if (!mounted) return;

      Navigator.of(context).pop(message ?? 'Profile updated successfully.');
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;

      _showError(error.message ?? 'Unable to update your profile.');
    } catch (error) {
      if (!mounted) return;

      _showError('Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor =
        isDark ? theme.scaffoldBackgroundColor : _warmBackground;

    final cardColor = theme.cardColor;

    final primaryText =
        isDark ? const Color(0xFFF5F1EC) : const Color(0xFF29231F);

    final secondaryText =
        isDark ? const Color(0xFFBDB5AD) : const Color(0xFF77716B);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: backgroundColor,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: primaryText,
            fontSize: 21,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),

                const SizedBox(height: 28),

                Text(
                  'Personal Information',
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  'Manage the personal details connected to your Cartly account.',
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 22),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: _orange.withValues(alpha: 0.13)),
                    boxShadow: [
                      BoxShadow(
                        color:
                            isDark
                                ? Colors.black.withValues(alpha: 0.15)
                                : _darkBrown.withValues(alpha: 0.06),
                        blurRadius: 22,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel(
                        'FULL NAME',
                        Icons.person_outline_rounded,
                        isDark,
                      ),

                      const SizedBox(height: 10),

                      TextFormField(
                        controller: _nameController,
                        validator: Validators.validateName,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        enabled: !_isSaving,
                        decoration: _decoration(
                          hint: 'Enter your full name',
                          icon: Icons.person_outline_rounded,
                          isDark: isDark,
                        ),
                      ),

                      const SizedBox(height: 25),

                      _buildLabel(
                        'EMAIL ADDRESS',
                        Icons.email_outlined,
                        isDark,
                      ),

                      const SizedBox(height: 10),

                      TextFormField(
                        controller: _emailController,
                        validator: Validators.validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        enabled: !_isSaving,
                        decoration: _decoration(
                          hint: 'Enter your email address',
                          icon: Icons.email_outlined,
                          isDark: isDark,
                        ),
                        onFieldSubmitted: (_) => _save(),
                      ),

                      const SizedBox(height: 18),

                      Container(
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: _orange.withValues(alpha: 0.09),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.info_outline_rounded,
                              color: _orange,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'If you change your email address, Firebase will send a verification email to confirm the new address.',
                                style: TextStyle(
                                  color: secondaryText,
                                  fontSize: 11,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [_orange, _deepOrange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: _deepOrange.withValues(alpha: 0.25),
                          blurRadius: 14,
                          offset: const Offset(0, 7),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        disabledBackgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        disabledForegroundColor: Colors.white70,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child:
                          _isSaving
                              ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  color: Colors.white,
                                ),
                              )
                              : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle_outline_rounded,
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Save Changes',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Center(
                  child: Text(
                    'Your account information is protected.',
                    style: TextStyle(color: secondaryText, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final displayName = _nameController.text.trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF5AC6B), Color(0xFFE68A45), Color(0xFFB95F2D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _deepOrange.withValues(alpha: 0.22),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -12,
            top: -30,
            child: Icon(
              Icons.person_rounded,
              size: 150,
              color: Colors.white.withValues(alpha: 0.07),
            ),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.75),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 42,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  child: const Icon(
                    Icons.person_rounded,
                    size: 45,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                displayName.isEmpty ? 'Your Profile' : displayName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Keep your Cartly account updated',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label, IconData icon, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 18, color: _orange),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: isDark ? const Color(0xFFFFC18D) : _darkBrown,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
          ),
        ),
      ],
    );
  }

  InputDecoration _decoration({
    required String hint,
    required IconData icon,
    required bool isDark,
  }) {
    final fillColor =
        isDark ? const Color(0xFF292929) : const Color(0xFFFFFAF5);

    final borderRadius = BorderRadius.circular(14);

    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: isDark ? Colors.white38 : Colors.grey.shade500,
        fontSize: 13,
      ),
      prefixIcon: const Icon(
        Icons.person_outline_rounded,
        color: _orange,
        size: 21,
      ),
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      border: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: _orange.withValues(alpha: 0.16)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: _orange, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    ).copyWith(prefixIcon: Icon(icon, color: _orange, size: 21));
  }
}
