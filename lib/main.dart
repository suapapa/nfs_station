import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nfs_mounter/data/repositories/mount_point_repository.dart';
import 'package:nfs_mounter/data/repositories/settings_repository.dart';
import 'package:nfs_mounter/data/services/local_storage_service.dart';
import 'package:nfs_mounter/data/services/nfs_service.dart';
import 'package:nfs_mounter/l10n/app_localizations.dart';
import 'package:nfs_mounter/ui/core/theme_view_model.dart';
import 'package:nfs_mounter/ui/features/home/view_models/home_view_model.dart';
import 'package:nfs_mounter/ui/features/home/views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Data Layer
  final storageService = LocalStorageService();
  await storageService.init();
  final nfsService = NfsService();

  final settingsRepository = SettingsRepository(storageService);
  final mountPointRepository = MountPointRepository(storageService);

  // Initialize ViewModels
  final themeViewModel = ThemeViewModel(settingsRepository);
  final homeViewModel = HomeViewModel(
    repository: mountPointRepository,
    nfsService: nfsService,
  );

  runApp(NFSMounterApp(
    themeViewModel: themeViewModel,
    homeViewModel: homeViewModel,
  ));
}

class NFSMounterApp extends StatelessWidget {
  final ThemeViewModel themeViewModel;
  final HomeViewModel homeViewModel;

  const NFSMounterApp({
    super.key,
    required this.themeViewModel,
    required this.homeViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeViewModel,
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
          themeMode: themeViewModel.themeMode,
          home: HomeScreen(
            themeViewModel: themeViewModel,
            viewModel: homeViewModel,
          ),
        );
      },
    );
  }
}
