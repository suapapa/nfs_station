import 'package:flutter/material.dart';
import '../../../data/repositories/settings_repository.dart';

class ThemeViewModel extends ChangeNotifier {
  final SettingsRepository _settingsRepository;
  late ThemeMode _themeMode;

  ThemeViewModel(this._settingsRepository) {
    _themeMode = _settingsRepository.getThemeMode();
  }

  ThemeMode get themeMode => _themeMode;

  Future<void> updateThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    await _settingsRepository.setThemeMode(mode);
  }
}
