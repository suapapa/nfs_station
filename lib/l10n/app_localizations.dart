import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko'),
    Locale('pl'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'NFS Station'**
  String get appTitle;

  /// No description provided for @addMountPoint.
  ///
  /// In en, this message translates to:
  /// **'Add Mount Point'**
  String get addMountPoint;

  /// No description provided for @editMountPoint.
  ///
  /// In en, this message translates to:
  /// **'Edit Mount Point'**
  String get editMountPoint;

  /// No description provided for @deleteMountPoint.
  ///
  /// In en, this message translates to:
  /// **'Delete Mount Point'**
  String get deleteMountPoint;

  /// No description provided for @deleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \'{name}\'?'**
  String deleteConfirmation(String name);

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @serverAddress.
  ///
  /// In en, this message translates to:
  /// **'Server Address'**
  String get serverAddress;

  /// No description provided for @serverPath.
  ///
  /// In en, this message translates to:
  /// **'Server Directory'**
  String get serverPath;

  /// No description provided for @localPath.
  ///
  /// In en, this message translates to:
  /// **'Mount Directory'**
  String get localPath;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @mount.
  ///
  /// In en, this message translates to:
  /// **'Mount'**
  String get mount;

  /// No description provided for @unmount.
  ///
  /// In en, this message translates to:
  /// **'Unmount'**
  String get unmount;

  /// No description provided for @mounting.
  ///
  /// In en, this message translates to:
  /// **'Mounting...'**
  String get mounting;

  /// No description provided for @unmounting.
  ///
  /// In en, this message translates to:
  /// **'Unmounting...'**
  String get unmounting;

  /// No description provided for @mountSuccess.
  ///
  /// In en, this message translates to:
  /// **'Mount Success'**
  String get mountSuccess;

  /// No description provided for @unmountSuccess.
  ///
  /// In en, this message translates to:
  /// **'Unmount Success'**
  String get unmountSuccess;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String error(String message);

  /// No description provided for @noMountPoints.
  ///
  /// In en, this message translates to:
  /// **'No mount points registered.'**
  String get noMountPoints;

  /// No description provided for @editSettings.
  ///
  /// In en, this message translates to:
  /// **'Edit settings'**
  String get editSettings;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @importConfig.
  ///
  /// In en, this message translates to:
  /// **'Import Config'**
  String get importConfig;

  /// No description provided for @exportConfig.
  ///
  /// In en, this message translates to:
  /// **'Export Config'**
  String get exportConfig;

  /// No description provided for @duplicateNameError.
  ///
  /// In en, this message translates to:
  /// **'A configuration with this name already exists.'**
  String get duplicateNameError;

  /// No description provided for @duplicatePathError.
  ///
  /// In en, this message translates to:
  /// **'A configuration using this mount directory already exists.'**
  String get duplicatePathError;

  /// No description provided for @invalidJsonError.
  ///
  /// In en, this message translates to:
  /// **'Invalid configuration file.'**
  String get invalidJsonError;

  /// No description provided for @validationError.
  ///
  /// In en, this message translates to:
  /// **'Validation Error'**
  String get validationError;

  /// No description provided for @nfsVersion.
  ///
  /// In en, this message translates to:
  /// **'NFS Version'**
  String get nfsVersion;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
    case 'pl':
      return AppLocalizationsPl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
