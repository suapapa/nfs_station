// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'NFS Station';

  @override
  String get addMountPoint => 'Dodaj punkt montowania';

  @override
  String get editMountPoint => 'Edytuj punkt montowania';

  @override
  String get deleteMountPoint => 'Usuń punkt montowania';

  @override
  String deleteConfirmation(String name) {
    return 'Czy na pewno usunąć \'$name\'?';
  }

  @override
  String get name => 'Nazwa';

  @override
  String get serverAddress => 'Adres serwera';

  @override
  String get serverPath => 'Ścieżka serwera';

  @override
  String get localPath => 'Katalog montowania';

  @override
  String get cancel => 'Anuluj';

  @override
  String get confirm => 'Potwierdź';

  @override
  String get delete => 'Usuń';

  @override
  String get mount => 'Montuj';

  @override
  String get unmount => 'Odmontuj';

  @override
  String get mounting => 'Montowanie...';

  @override
  String get unmounting => 'Odmontowywanie...';

  @override
  String get mountSuccess => 'Pomyślnie zamontowano';

  @override
  String get unmountSuccess => 'Pomyślnie odmontowano';

  @override
  String error(String message) {
    return 'Błąd: $message';
  }

  @override
  String get noMountPoints => 'Brak zarejestrowanych punktów montowania.';

  @override
  String get editSettings => 'Edytuj ustawienia';

  @override
  String get settings => 'Ustawienia';

  @override
  String get theme => 'Motyw';

  @override
  String get system => 'Systemowy';

  @override
  String get light => 'Jasny';

  @override
  String get dark => 'Ciemny';
}
