import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/app_theme.dart';
import 'package:vedanta_frontend/src/controllers/audio_recorder_controller.dart';
import 'package:vedanta_frontend/src/helper/audio_recerder_file_helper.dart';
import 'package:vedanta_frontend/src/helper/notification_helper.dart';
import 'package:vedanta_frontend/src/providers/alarm_povider.dart';
import 'package:vedanta_frontend/src/providers/chat_provider.dart';
import 'package:vedanta_frontend/src/providers/class_provider.dart';
import 'package:vedanta_frontend/src/providers/discussion_provider.dart';
import 'package:vedanta_frontend/src/providers/doa_provider.dart';
import 'package:vedanta_frontend/src/providers/gita_provider.dart';
import 'package:vedanta_frontend/src/providers/hadiah_provider.dart';
import 'package:vedanta_frontend/src/providers/mission_provider.dart';
import 'package:vedanta_frontend/src/providers/stage_provider.dart';
import 'package:vedanta_frontend/src/providers/theme_provider.dart';
import 'package:vedanta_frontend/src/providers/user_provider.dart';
import 'package:vedanta_frontend/src/screens/doa_detail_screen.dart';
import 'package:vedanta_frontend/src/screens/register_screen.dart';
import 'package:vedanta_frontend/src/screens/splash_screen.dart';
import 'package:vedanta_frontend/src/services/auth_wraper.dart';
import 'src/screens/login_screen.dart';
import 'src/screens/home_screen.dart';
import 'src/providers/auth_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void onDidReceiveNotificationResponse(
  NotificationResponse notificationResponse,
) {
  if (notificationResponse.payload != null) {
    print('notification payload: ${notificationResponse.payload}');
    navigatorKey.currentState
        ?.pushNamed('/doa_detail', arguments: notificationResponse.payload);
  }
  print('notification response');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationHelper.init(onDidReceiveNotificationResponse);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(255, 211, 22, 167),
    ),
  );

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
        ChangeNotifierProvider(create: (context) => DiscussionProvider()),
        ChangeNotifierProvider(create: (context) => ClassProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => DoaProvider()),
        ChangeNotifierProvider(create: (context) => AlarmProvider()),
        ChangeNotifierProvider(create: (context) => StageProvider()),
        ChangeNotifierProvider(create: (context) => HadiahProvider()),
        ChangeNotifierProvider(
          create: (context) => AudioRecorderController(
              AudioRecorderFileHelper(), (message) => print(message)),
        ),
        ChangeNotifierProvider(create: (context) => MissionProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            title: 'Vedanta',
            theme: themeProvider.themeData,
            home: const SplashScreen(),
            routes: {
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/home': (context) => const AuthWrapper(child: HomeScreen()),
              '/doa_detail': (context) => const ExctractIDDoa(),
            },
          );
        },
      ),
    );
  }
}

class ExctractIDDoa extends StatelessWidget {
  const ExctractIDDoa({super.key});

  @override
  Widget build(BuildContext context) {
    final idDoa =
        int.parse(ModalRoute.of(context)!.settings.arguments.toString());
    return DoaDetailScreen(idDoa: idDoa);
  }
}
