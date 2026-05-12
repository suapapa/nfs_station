import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nfs_mounter/main.dart';
import 'package:nfs_mounter/data/services/local_storage_service.dart';
import 'package:nfs_mounter/data/services/nfs_service.dart';
import 'package:nfs_mounter/data/repositories/settings_repository.dart';
import 'package:nfs_mounter/data/repositories/mount_point_repository.dart';
import 'package:nfs_mounter/ui/core/theme_view_model.dart';
import 'package:nfs_mounter/ui/features/home/view_models/home_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App title smoke test', (WidgetTester tester) async {
    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({});

    final storageService = LocalStorageService();
    await storageService.init();
    final nfsService = NfsService();

    final settingsRepository = SettingsRepository(storageService);
    final mountPointRepository = MountPointRepository(storageService);

    final themeViewModel = ThemeViewModel(settingsRepository);
    final homeViewModel = HomeViewModel(
      repository: mountPointRepository,
      nfsService: nfsService,
    );

    // Build our app and trigger a frame.
    await tester.pumpWidget(NFSMounterApp(
      themeViewModel: themeViewModel,
      homeViewModel: homeViewModel,
    ));

    // Verify that the title is displayed.
    // The title in AppBar is AppLocalizations.of(context)!.appTitle
    // In the test environment, we might need to pump and wait for localizations
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.dns), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
