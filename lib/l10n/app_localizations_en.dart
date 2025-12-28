// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'NFS Mounter';

  @override
  String get addMountPoint => 'Add Mount Point';

  @override
  String get editMountPoint => 'Edit Mount Point';

  @override
  String get deleteMountPoint => 'Delete Mount Point';

  @override
  String deleteConfirmation(String name) {
    return 'Are you sure you want to delete \'$name\'?';
  }

  @override
  String get name => 'Name';

  @override
  String get serverAddress => 'Server Address';

  @override
  String get serverPath => 'Server Directory';

  @override
  String get localPath => 'Mount Directory';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get delete => 'Delete';

  @override
  String get mount => 'Mount';

  @override
  String get unmount => 'Unmount';

  @override
  String get mounting => 'Mounting...';

  @override
  String get unmounting => 'Unmounting...';

  @override
  String get mountSuccess => 'Mount Success';

  @override
  String get unmountSuccess => 'Unmount Success';

  @override
  String error(String message) {
    return 'Error: $message';
  }

  @override
  String get noMountPoints => 'No mount points registered.';

  @override
  String get editSettings => 'Edit settings';

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';
}
