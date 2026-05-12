import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';

class SettingsRepository {
  static const String _themeKey = 'theme_mode';
  final LocalStorageService _storage;

  SettingsRepository(this._storage);

  ThemeMode getThemeMode() {
    final String? themeStr = _storage.getString(_themeKey);
    if (themeStr == null) return ThemeMode.system;

    return ThemeMode.values.firstWhere(
      (e) => e.name == themeStr,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _storage.setString(_themeKey, mode.name);
  }
}
