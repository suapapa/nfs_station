import 'package:flutter/material.dart';
import 'package:nfs_mounter/models/mount_point.dart';
import 'package:nfs_mounter/l10n/app_localizations.dart';

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
      title: Text(
        widget.mountPoint == null
            ? AppLocalizations.of(context)!.addMountPoint
            : AppLocalizations.of(context)!.editMountPoint,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.name,
              ),
            ),
            TextField(
              controller: _serverAddressController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.serverAddress,
              ),
            ),
            TextField(
              controller: _serverPathController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.serverPath,
              ),
            ),
            TextField(
              controller: _localPathController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.localPath,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.cancel),
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
          child: Text(AppLocalizations.of(context)!.confirm),
        ),
      ],
    );
  }
}
