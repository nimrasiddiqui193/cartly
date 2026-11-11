import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: CartlyApp()));
}

class CartlyApp extends StatefulWidget {
  const CartlyApp({super.key});

  @override
  State<CartlyApp> createState() => _CartlyAppState();
}

class _CartlyAppState extends State<CartlyApp> {
  late final ThemeController _themeController;

  @override
  void initState() {
    super.initState();

    _themeController = ThemeController();

    AppRouter.configure(themeController: _themeController);

    _themeController.loadTheme();
  }

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _themeController,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Cartly',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: _themeController.themeMode,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
