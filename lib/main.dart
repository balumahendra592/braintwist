import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/game_storage.dart';
import 'services/ad_manager.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await GameStorage.init();
  await AdManager.initialize();

  runApp(const BrainTwistApp());
}

class BrainTwistApp extends StatelessWidget {
  const BrainTwistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brain Twist',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const SplashScreen(),
    );
  }
}