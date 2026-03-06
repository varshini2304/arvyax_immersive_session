import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'navigation/app_router.dart';
import 'shared/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: ArvyaXApp()));
}

class ArvyaXApp extends StatelessWidget {
  const ArvyaXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ArvyaX',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      initialRoute: '/loading',
      onGenerateRoute: AppRouter.generate,
    );
  }
}
