import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nfs_mounter/controllers/theme_controller.dart';
import 'package:nfs_mounter/l10n/app_localizations.dart';
import 'views/home_screen.dart';

void main() {
  runApp(const NFSMounterApp());
}

class NFSMounterApp extends StatefulWidget {
  const NFSMounterApp({super.key});

  @override
  State<NFSMounterApp> createState() => _NFSMounterAppState();
}

class _NFSMounterAppState extends State<NFSMounterApp> {
  final ThemeController _themeController = ThemeController();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _themeController,
      builder: (context, child) {
        return MaterialApp(
          title: 'NFS Station',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          themeMode: _themeController.themeMode,
          home: HomeScreen(themeController: _themeController),
        );
      },
    );
  }
}
