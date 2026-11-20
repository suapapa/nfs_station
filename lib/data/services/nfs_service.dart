import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/mount_point.dart';

class NfsService {
  static const List<String> _linuxMountHelperPaths = [
    '/usr/bin/mount.nfs',
    '/sbin/mount.nfs',
    '/usr/sbin/mount.nfs',
  ];

  /// 마운트 상태 확인
  Future<bool> isMounted(String localPath) async {
    final resolvedLocalPath = resolvePath(localPath);

    if (Platform.isMacOS) {
      final result = await Process.run('mount', []);
      if (result.exitCode != 0) {
        // mount 명령 실패 시 false 반환 (보수적 접근)
        return false;
      }

      final output = result.stdout.toString();
      // 정확한 매칭을 위해 ' on path (' 패턴 사용
      return output.contains(' on $resolvedLocalPath (');
    }

    if (Platform.isLinux) {
      try {
        final result = await Process.run('findmnt', [
          '-n',
          '-o',
          'TARGET',
          '--mountpoint',
          resolvedLocalPath,
        ]);
        return result.exitCode == 0 &&
            result.stdout.toString().trim().isNotEmpty;
      } on ProcessException {
        final result = await Process.run('mount', []);
        if (result.exitCode != 0) {
          return false;
        }
        final lines = result.stdout.toString().split('\n');
        return lines.any((line) => line.contains(' on $resolvedLocalPath type '));
      }
    }

    return false;
  }

  /// 마운트 실행
  ///
  /// 1. 로컬 디렉토리가 없으면 생성 (현재 사용자 권한)
  /// 2. 플랫폼별 권한 상승 도구를 사용하여 mount 명령 실행
  Future<void> mount(MountPoint mountPoint) async {
    // 이미 마운트되어 있는지 확인
    if (await isMounted(mountPoint.localPath)) {
      return; // 이미 마운트됨
    }

    final resolvedLocalPath = resolvePath(mountPoint.localPath);

    // 1. 로컬 디렉토리 생성 (사용자 권한)
    final directory = Directory(resolvedLocalPath);
    if (!await directory.exists()) {
      try {
        await directory.create(recursive: true);
      } catch (e) {
        throw Exception('Failed to create local directory: $e');
      }
    }

    if (Platform.isMacOS) {
      // 2. 마운트 명령 구성
      // -o resvport: macOS에서 보안 포트 사용을 위해 필요
      // -o rw: 읽기/쓰기
      // -o nfc: 유니코드 정규화 (macOS/Linux 호환성)
      final command =
          'mount -t nfs -o nfsvers=${mountPoint.nfsVersion},resvport,rw,nfc "${mountPoint.serverAddress}:${mountPoint.serverPath}" "$resolvedLocalPath"';

      // 3. AppleScript로 실행 (관리자 암호 프롬프트 표시)
      // AppleScript 내부에서 사용할 때 command 내의 쌍따옴표를 이스케이프 처리해야 함
      final script =
          'do shell script "${command.replaceAll('"', '\\"')}" with administrator privileges';
      final processResult = await Process.run('osascript', ['-e', script]);

      if (processResult.exitCode != 0) {
        throw Exception('Mount failed: ${processResult.stderr}');
      }
      return;
    }

    if (Platform.isLinux) {
      if (!await _hasLinuxMountNfsHelper()) {
        throw Exception(
          'NFS mount helper (mount.nfs) not found. Please install nfs-utils (e.g. sudo pacman -S nfs-utils).',
        );
      }

      final processResult = await Process.run(
        'pkexec',
        buildLinuxMountArgs(mountPoint, resolvedLocalPath),
      );

      if (processResult.exitCode != 0) {
        final errorMsg = _extractPkexecError(processResult);
        throw Exception('Mount failed: $errorMsg');
      }
      return;
    }

    throw UnsupportedError(
      'Unsupported platform: ${Platform.operatingSystem}',
    );
  }

  /// 언마운트 실행
  Future<void> unmount(MountPoint mountPoint) async {
    // 이미 언마운트되어 있는지 확인
    if (!await isMounted(mountPoint.localPath)) {
      return; // 이미 언마운트됨
    }

    final resolvedLocalPath = resolvePath(mountPoint.localPath);

    if (Platform.isMacOS) {
      // 언마운트 명령 구성
      final command = 'umount -f "$resolvedLocalPath"';

      // AppleScript로 실행
      final script =
          'do shell script "${command.replaceAll('"', '\\"')}" with administrator privileges';
      final processResult = await Process.run('osascript', ['-e', script]);

      if (processResult.exitCode != 0) {
        // 언마운트 실패 시, 이미 언마운트된 상태일 수 있으므로 재확인
        if (!await isMounted(mountPoint.localPath)) {
          return;
        }
        throw Exception('Unmount failed: ${processResult.stderr}');
      }
      return;
    }

    if (Platform.isLinux) {
      final processResult = await Process.run(
        'pkexec',
        buildLinuxUnmountArgs(resolvedLocalPath),
      );

      if (processResult.exitCode != 0) {
        // 언마운트 실패 시, 이미 언마운트된 상태일 수 있으므로 재확인
        if (!await isMounted(mountPoint.localPath)) {
          return;
        }
        final errorMsg = _extractPkexecError(processResult);
        throw Exception('Unmount failed: $errorMsg');
      }
      return;
    }

    throw UnsupportedError(
      'Unsupported platform: ${Platform.operatingSystem}',
    );
  }

  /// 로컬 디렉터리를 시스템 파일 관리자로 열기
  Future<void> openDirectory(String localPath) async {
    final resolvedPath = resolvePath(localPath);
    if (Platform.isMacOS) {
      await Process.run('open', [resolvedPath]);
    } else if (Platform.isLinux) {
      await Process.start(
        'xdg-open',
        [resolvedPath],
        mode: ProcessStartMode.detached,
      );
    }
  }

  @visibleForTesting
  List<String> buildLinuxMountArgs(
    MountPoint mountPoint,
    String resolvedLocalPath,
  ) {
    return [
      'mount',
      '-t',
      'nfs',
      '-o',
      'nfsvers=${mountPoint.nfsVersion},rw',
      '${mountPoint.serverAddress}:${mountPoint.serverPath}',
      resolvedLocalPath,
    ];
  }

  @visibleForTesting
  List<String> buildLinuxUnmountArgs(String resolvedLocalPath) {
    return ['umount', '-f', resolvedLocalPath];
  }

  @visibleForTesting
  String resolvePath(String path) {
    var resolved = path;
    final home = Platform.environment['HOME'];
    if (home != null) {
      if (resolved.startsWith('~/')) {
        resolved = resolved.replaceFirst('~', home);
      } else if (resolved == '~') {
        resolved = home;
      }
    }

    while (resolved.length > 1 && resolved.endsWith('/')) {
      resolved = resolved.substring(0, resolved.length - 1);
    }
    return resolved;
  }

  Future<bool> _hasLinuxMountNfsHelper() async {
    for (final helperPath in _linuxMountHelperPaths) {
      if (await File(helperPath).exists()) {
        return true;
      }
    }
    return false;
  }

  String _extractPkexecError(ProcessResult result) {
    final stderrText = result.stderr.toString().trim();
    if (stderrText.isNotEmpty) {
      return stderrText;
    }
    final stdoutText = result.stdout.toString().trim();
    if (stdoutText.isNotEmpty) {
      return stdoutText;
    }
    if (result.exitCode == 126) {
      return 'Authentication canceled';
    }
    return 'Exit code ${result.exitCode}';
  }
}
