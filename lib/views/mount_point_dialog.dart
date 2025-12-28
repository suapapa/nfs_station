import 'package:flutter/material.dart';
import 'package:nfs_mounter/models/mount_point.dart';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:nfs_mounter/l10n/app_localizations.dart';

class MountPointDialog extends StatefulWidget {
  final MountPoint? mountPoint;
  final List<MountPoint> existingMountPoints;

  const MountPointDialog({
    super.key,
    this.mountPoint,
    this.existingMountPoints = const [],
  });

  @override
  State<MountPointDialog> createState() => _MountPointDialogState();
}

class _MountPointDialogState extends State<MountPointDialog> {
  late TextEditingController _nameController;
  late TextEditingController _serverAddressController;
  late TextEditingController _serverPathController;
  late TextEditingController _localPathController;

  Future<void> _exportConfig() async {
    if (widget.mountPoint == null) return;

    try {
      final jsonString = jsonEncode(widget.mountPoint!.toJson());
      final fileName =
          'nfs_config_${widget.mountPoint!.name.replaceAll(' ', '_')}.json';

      final String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: AppLocalizations.of(context)!.exportConfig,
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (outputFile != null) {
        final file = File(outputFile);
        await file.writeAsString(jsonString);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.error(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _importConfig() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final jsonString = await file.readAsString();
        final json = jsonDecode(jsonString);
        final mountPoint = MountPoint.fromJson(json);

        setState(() {
          _nameController.text = mountPoint.name;
          _serverAddressController.text = mountPoint.serverAddress;
          _serverPathController.text = mountPoint.serverPath;
          _localPathController.text = mountPoint.localPath;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.invalidJsonError),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String? _validate() {
    final name = _nameController.text.trim();
    final localPath = _localPathController.text.trim();

    if (name.isEmpty ||
        _serverAddressController.text.isEmpty ||
        _serverPathController.text.isEmpty ||
        localPath.isEmpty) {
      return AppLocalizations.of(context)!.validationError;
    }

    for (final point in widget.existingMountPoints) {
      // Create/Add mode: check all. Edit mode: skip itself (check ID)
      if (widget.mountPoint != null && point.id == widget.mountPoint!.id) {
        continue;
      }

      if (point.name == name) {
        return AppLocalizations.of(context)!.duplicateNameError;
      }
      if (point.localPath == localPath) {
        return AppLocalizations.of(context)!.duplicatePathError;
      }
    }
    return null;
  }

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
      title: Row(
        children: [
          Expanded(
            child: Text(
              widget.mountPoint == null
                  ? AppLocalizations.of(context)!.addMountPoint
                  : AppLocalizations.of(context)!.editMountPoint,
            ),
          ),
          if (widget.mountPoint != null)
            IconButton(
              icon: const Icon(Icons.save_as),
              tooltip: AppLocalizations.of(context)!.exportConfig,
              onPressed: _exportConfig,
            )
          else
            IconButton(
              icon: const Icon(Icons.file_upload),
              tooltip: AppLocalizations.of(context)!.importConfig,
              onPressed: _importConfig,
            ),
        ],
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
            final error = _validate();
            if (error != null) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(AppLocalizations.of(context)!.error(error)),
                  content: Text(error), // Reusing message as content
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(AppLocalizations.of(context)!.confirm),
                    ),
                  ],
                ),
              );
              return;
            }

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
