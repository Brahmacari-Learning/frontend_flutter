import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/app_theme.dart';
import 'package:vedanta_frontend/src/providers/chat_provider.dart';
import 'package:vedanta_frontend/src/providers/gita_provider.dart';
import 'package:vedanta_frontend/src/providers/theme_provider.dart';
// import 'package:vedanta_frontend/src/screens/detail_sloka_screen.dart';
import 'package:vedanta_frontend/src/screens/register_screen.dart';
import 'package:vedanta_frontend/src/screens/splash_screen.dart';
import 'src/screens/login_screen.dart';
import 'src/screens/home_screen.dart';
import 'src/providers/auth_provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(
            create: (context) => ThemeProvider(AppTheme.lightTheme)),
        ChangeNotifierProvider(create: (context) => ChatProvider()),
        ChangeNotifierProvider(create: (context) => GitaProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: themeProvider.themeData,
            home: const SplashScreen(),
            routes: {
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/home': (context) => const HomeScreen(),
            },
          );
        },
      ),
    );
  }
}
