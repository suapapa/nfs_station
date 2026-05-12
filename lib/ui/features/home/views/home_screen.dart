import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:nfs_mounter/l10n/app_localizations.dart';
import 'package:nfs_mounter/data/models/mount_point.dart';
import 'package:nfs_mounter/ui/core/theme_view_model.dart';
import '../view_models/home_view_model.dart';
import 'mount_point_dialog.dart';
import 'mount_point_list_item.dart';

class HomeScreen extends StatelessWidget {
  final ThemeViewModel themeViewModel;
  final HomeViewModel viewModel;

  const HomeScreen({
    super.key,
    required this.themeViewModel,
    required this.viewModel,
  });

  void _addMountPoint(BuildContext context) async {
    final result = await showDialog<MountPoint>(
      context: context,
      builder: (context) => MountPointDialog(
        existingMountPoints: viewModel.mountPoints,
      ),
    );

    if (result != null) {
      viewModel.addMountPoint(result);
    }
  }

  void _editMountPoint(BuildContext context, int index) async {
    final result = await showDialog<MountPoint>(
      context: context,
      builder: (context) => MountPointDialog(
        mountPoint: viewModel.mountPoints[index],
        existingMountPoints: viewModel.mountPoints,
      ),
    );

    if (result != null) {
      viewModel.updateMountPoint(index, result);
    }
  }

  void _deleteMountPoint(BuildContext context, int index) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteMountPoint),
        content: Text(
          AppLocalizations.of(
            context,
          )!.deleteConfirmation(viewModel.mountPoints[index].name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );

    if (confirm == true) {
      viewModel.deleteMountPoint(index);
    }
  }

  Future<void> _toggleMount(BuildContext context, int index) async {
    final mountPoint = viewModel.mountPoints[index];
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            mountPoint.isMounted
                ? AppLocalizations.of(context)!.unmounting
                : AppLocalizations.of(context)!.mounting,
          ),
          duration: const Duration(seconds: 1),
        ),
      );

      await viewModel.toggleMount(index);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            !mountPoint.isMounted
                ? AppLocalizations.of(context)!.mountSuccess
                : AppLocalizations.of(context)!.unmountSuccess,
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.error(e.toString())),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _exportToYaml(BuildContext context) async {
    final yamlString = MountPoint.mountPointsToYaml(viewModel.mountPoints);
    final result = await FilePicker.saveFile(
      dialogTitle: AppLocalizations.of(context)!.exportConfig,
      fileName: 'nfs_mount_points.yaml',
      type: FileType.custom,
      allowedExtensions: ['yaml', 'yml'],
    );
    if (result == null) return;

    final file = File(result);
    await file.writeAsString(yamlString);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.exportSuccess),
      ),
    );
  }

  Future<void> _importFromYaml(BuildContext context) async {
    final result = await FilePicker.pickFiles(
      dialogTitle: AppLocalizations.of(context)!.importConfig,
      type: FileType.custom,
      allowedExtensions: ['yaml', 'yml'],
    );
    if (result == null || result.files.single.path == null) return;

    try {
      final file = File(result.files.single.path!);
      final yamlString = await file.readAsString();
      final imported = MountPoint.mountPointsFromYaml(yamlString);

      if (!context.mounted) return;

      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.importConfig),
          content: Text(
            AppLocalizations.of(context)!.importConfirmation(imported.length),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(AppLocalizations.of(context)!.confirm),
            ),
          ],
        ),
      );

      if (confirm == true) {
        await viewModel.importMountPoints(imported);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.importSuccess),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.invalidYamlError),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return ListenableBuilder(
          listenable: themeViewModel,
          builder: (context, _) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.settings),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.theme,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  RadioGroup<ThemeMode>(
                    groupValue: themeViewModel.themeMode,
                    onChanged: (val) {
                      if (val != null) {
                        themeViewModel.updateThemeMode(val);
                      }
                    },
                    child: Column(
                      children: ThemeMode.values.map((mode) {
                        return RadioListTile<ThemeMode>(
                          title: Text(_getThemeModeName(context, mode)),
                          value: mode,
                        );
                      }).toList(),
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.configData,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _exportToYaml(context);
                          },
                          icon: const Icon(Icons.upload_file),
                          label: Text(
                            AppLocalizations.of(context)!.exportConfig,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _importFromYaml(context);
                          },
                          icon: const Icon(Icons.download),
                          label: Text(
                            AppLocalizations.of(context)!.importConfig,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(AppLocalizations.of(context)!.confirm),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _getThemeModeName(BuildContext context, ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return AppLocalizations.of(context)!.system;
      case ThemeMode.light:
        return AppLocalizations.of(context)!.light;
      case ThemeMode.dark:
        return AppLocalizations.of(context)!.dark;
    }
  }

  void _openInFinder(String path) {
    if (Platform.isMacOS) {
      String resolvedPath = path;
      if (path.startsWith('~/')) {
        final home = Platform.environment['HOME'];
        if (home != null) {
          resolvedPath = path.replaceFirst('~', home);
        }
      } else if (path == '~') {
        final home = Platform.environment['HOME'];
        if (home != null) {
          resolvedPath = home;
        }
      }

      debugPrint('Opening in Finder: $resolvedPath');
      Process.run('open', [resolvedPath]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                const Icon(Icons.dns),
                const SizedBox(width: 8),
                Text(AppLocalizations.of(context)!.appTitle),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => _showSettingsDialog(context),
                tooltip: AppLocalizations.of(context)!.settings,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: FilledButton.icon(
                  onPressed: () => _addMountPoint(context),
                  icon: const Icon(Icons.add),
                  label: Text(AppLocalizations.of(context)!.addMountPoint),
                ),
              ),
            ],
          ),
          body: viewModel.mountPoints.isEmpty
              ? Center(child: Text(AppLocalizations.of(context)!.noMountPoints))
              : ReorderableListView.builder(
                  buildDefaultDragHandles: false,
                  itemCount: viewModel.mountPoints.length,
                  onReorder: viewModel.reorderMountPoints,
                  itemBuilder: (context, index) {
                    final mountPoint = viewModel.mountPoints[index];
                    return MountPointListItem(
                      key: ValueKey(mountPoint.id),
                      index: index,
                      mountPoint: mountPoint,
                      onEdit: () => _editMountPoint(context, index),
                      onDelete: () => _deleteMountPoint(context, index),
                      onToggleMount: () => _toggleMount(context, index),
                      onOpenFinder: () => _openInFinder(mountPoint.localPath),
                    );
                  },
                ),
        );
      },
    );
  }
}
