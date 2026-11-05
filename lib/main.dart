import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tombola/screens/regolamento_premi_screen.dart';

import 'providers/game_provider.dart';
import 'screens/home_screen.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configura orientamento e UI di sistema per fullscreen
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Nascondi barre di sistema per esperienza fullscreen
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const TombolaApp());
}

class TombolaApp extends StatelessWidget {
  const TombolaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = GameProvider();
        // Carica le impostazioni salvate all'avvio
        provider.loadSettings();
        return provider;
      },
      child: MaterialApp(
        title: 'Tombola Board',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const HomeScreen(),
        routes: {'/regolamento': (context) => const RegolamentoPremiScreen()},
      ),
    );
  }
}
