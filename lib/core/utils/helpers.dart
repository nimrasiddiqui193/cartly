import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppHelpers {
  AppHelpers._();

  static void showSuccess(BuildContext context, String message) {
    _showMessage(
      context,
      message,
      backgroundColor: const Color(0xFF21865B),
      icon: Icons.check_circle_outline_rounded,
    );
  }

  static void showError(BuildContext context, String message) {
    _showMessage(
      context,
      message,
      backgroundColor: const Color(0xFFC94040),
      icon: Icons.error_outline_rounded,
    );
  }

  static void showInfo(BuildContext context, String message) {
    _showMessage(
      context,
      message,
      backgroundColor: const Color(0xFF343434),
      icon: Icons.info_outline_rounded,
    );
  }

  static void _showMessage(
    BuildContext context,
    String message, {
    required Color backgroundColor,
    required IconData icon,
  }) {
    if (!context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(icon, color: Colors.white, size: 21),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
  }

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static Future<void> copyToClipboard(String value) async {
    await Clipboard.setData(ClipboardData(text: value));
  }

  static Future<bool> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: Text(cancelText),
            ),
            ElevatedButton(
              style:
                  isDestructive
                      ? ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                      )
                      : null,
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: Text(confirmText),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  static Future<void> showLoadingDialog(
    BuildContext context, {
    String message = 'Please wait...',
  }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            content: Row(
              children: [
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                ),
                const SizedBox(width: 18),
                Expanded(child: Text(message)),
              ],
            ),
          ),
        );
      },
    );
  }

  static void closeLoadingDialog(BuildContext context) {
    if (!context.mounted) return;

    final navigator = Navigator.of(context);

    if (navigator.canPop()) {
      navigator.pop();
    }
  }

  static Future<T?> showAppBottomSheet<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool isScrollControlled = false,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: Theme.of(context).colorScheme.surface,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: builder,
    );
  }

  static String readableError(Object error) {
    final message = error.toString();

    if (message.contains('SocketException')) {
      return 'No internet connection. Please try again.';
    }

    if (message.contains('TimeoutException')) {
      return 'The request took too long. Please try again.';
    }

    if (message.contains('permission-denied')) {
      return 'You do not have permission to perform this action.';
    }

    if (message.contains('network-request-failed')) {
      return 'Network error. Please check your internet connection.';
    }

    return 'Something went wrong. Please try again.';
  }
}
