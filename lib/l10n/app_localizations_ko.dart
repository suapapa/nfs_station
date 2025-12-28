// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'NFS Station';

  @override
  String get addMountPoint => '마운트 포인트 추가';

  @override
  String get editMountPoint => '마운트 포인트 수정';

  @override
  String get deleteMountPoint => '마운트 포인트 삭제';

  @override
  String deleteConfirmation(String name) {
    return '\'$name\'을(를) 정말 삭제하시겠습니까?';
  }

  @override
  String get name => '이름';

  @override
  String get serverAddress => '서버 주소';

  @override
  String get serverPath => '서버 디렉터리';

  @override
  String get localPath => '마운트 디렉터리';

  @override
  String get cancel => '취소';

  @override
  String get confirm => '확인';

  @override
  String get delete => '삭제';

  @override
  String get mount => '마운트';

  @override
  String get unmount => '언마운트';

  @override
  String get mounting => '마운트 중...';

  @override
  String get unmounting => '언마운트 중...';

  @override
  String get mountSuccess => '마운트 성공';

  @override
  String get unmountSuccess => '언마운트 성공';

  @override
  String error(String message) {
    return '오류: $message';
  }

  @override
  String get noMountPoints => '등록된 마운트 포인트가 없습니다.';

  @override
  String get editSettings => '설정 변경';

  @override
  String get settings => '설정';

  @override
  String get theme => '테마';

  @override
  String get system => '시스템 설정';

  @override
  String get light => '밝은 테마';

  @override
  String get dark => '어두운 테마';
}
