import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'screens/splash_screen.dart';
import 'utils/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: Consumer<AppProvider>(
        builder: (context, appProvider, _) {
    return MaterialApp(
            title: 'UUM SafeGuard',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getTheme(
              appProvider.isDarkMode,
              appProvider.isHighContrast,
            ),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}