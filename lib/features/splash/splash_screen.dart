import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routes/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      context.go(AppRouter.home);
    } else {
      context.go(AppRouter.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 105,
              width: 105,
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.25),
                    blurRadius: 22,
                    offset: const Offset(0, 9),
                  ),
                ],
              ),
              child: const Icon(
                Icons.shopping_bag_rounded,
                color: Colors.white,
                size: 55,
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Cartly',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your shopping, simplified.',
              style: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 35),
            SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
