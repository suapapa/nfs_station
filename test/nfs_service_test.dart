import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:nfs_mounter/data/models/mount_point.dart';
import 'package:nfs_mounter/data/services/nfs_service.dart';

void main() {
  late NfsService nfsService;

  setUp(() {
    nfsService = NfsService();
  });

  group('resolvePath', () {
    test('expands tilde and strips trailing slashes', () {
      final home = Platform.environment['HOME'];
      expect(home, isNotNull);

      expect(nfsService.resolvePath('~'), equals(home));
      expect(nfsService.resolvePath('~/mounts/nas'), equals('$home/mounts/nas'));
      expect(
        nfsService.resolvePath('~/mounts/nas///'),
        equals('$home/mounts/nas'),
      );
      expect(nfsService.resolvePath('/mnt/data/'), equals('/mnt/data'));
      expect(nfsService.resolvePath('/'), equals('/'));
    });
  });

  group('Linux command builders', () {
    test('buildLinuxMountArgs builds nfsvers=3,rw without macOS flags', () {
      final mp = MountPoint(
        id: '1',
        name: 'Media',
        serverAddress: '192.168.1.10',
        serverPath: '/export/media',
        localPath: '~/mnt/my media',
        nfsVersion: 3,
      );

      final args = nfsService.buildLinuxMountArgs(mp, '/home/user/mnt/my media');
      expect(args, [
        'mount',
        '-t',
        'nfs',
        '-o',
        'nfsvers=3,rw',
        '192.168.1.10:/export/media',
        '/home/user/mnt/my media',
      ]);
      expect(args.join(' '), isNot(contains('nfc')));
      expect(args.join(' '), isNot(contains('resvport')));
    });

    test('buildLinuxMountArgs builds nfsvers=4,rw', () {
      final mp = MountPoint(
        id: '2',
        name: 'Backups',
        serverAddress: 'nas.local',
        serverPath: '/srv/backups',
        localPath: '/mnt/backups',
        nfsVersion: 4,
      );

      final args = nfsService.buildLinuxMountArgs(mp, '/mnt/backups');
      expect(args, [
        'mount',
        '-t',
        'nfs',
        '-o',
        'nfsvers=4,rw',
        'nas.local:/srv/backups',
        '/mnt/backups',
      ]);
    });

    test('buildLinuxUnmountArgs builds umount -f with resolved path', () {
      expect(
        nfsService.buildLinuxUnmountArgs('/home/user/mnt/my media'),
        ['umount', '-f', '/home/user/mnt/my media'],
      );
    });
  });

  group('isMounted on Linux', () {
    test('detects mounted root and non-mounted bogus path', () async {
      if (!Platform.isLinux) {
        return;
      }

      expect(await nfsService.isMounted('/'), isTrue);
      expect(
        await nfsService.isMounted('/nonexistent/nfs_station_test_mount_point'),
        isFalse,
      );
    });
  });
}
