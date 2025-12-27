import 'package:flutter/material.dart';
import 'package:nfs_mounter/models/mount_point.dart';

class MountPointDialog extends StatefulWidget {
  final MountPoint? mountPoint;

  const MountPointDialog({super.key, this.mountPoint});

  @override
  State<MountPointDialog> createState() => _MountPointDialogState();
}

class _MountPointDialogState extends State<MountPointDialog> {
  late TextEditingController _nameController;
  late TextEditingController _serverAddressController;
  late TextEditingController _serverPathController;
  late TextEditingController _localPathController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.mountPoint?.name ?? '',
    );
    _serverAddressController = TextEditingController(
      text: widget.mountPoint?.serverAddress ?? '',
    );
    _serverPathController = TextEditingController(
      text: widget.mountPoint?.serverPath ?? '',
    );
    _localPathController = TextEditingController(
      text: widget.mountPoint?.localPath ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _serverAddressController.dispose();
    _serverPathController.dispose();
    _localPathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.mountPoint == null ? '마운트 포인트 추가' : '마운트 포인트 수정'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: '이름'),
            ),
            TextField(
              controller: _serverAddressController,
              decoration: const InputDecoration(labelText: '서버 주소'),
            ),
            TextField(
              controller: _serverPathController,
              decoration: const InputDecoration(labelText: '서버 디렉터리'),
            ),
            TextField(
              controller: _localPathController,
              decoration: const InputDecoration(labelText: '마운트 디렉터리'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: () {
            final mountPoint = MountPoint(
              id: widget.mountPoint?.id ?? DateTime.now().toString(),
              name: _nameController.text,
              serverAddress: _serverAddressController.text,
              serverPath: _serverPathController.text,
              localPath: _localPathController.text,
              isMounted: widget.mountPoint?.isMounted ?? false,
            );
            Navigator.of(context).pop(mountPoint);
          },
          child: const Text('확인'),
        ),
      ],
    );
  }
}
