import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nfs_mounter/l10n/app_localizations.dart';
import 'package:nfs_mounter/models/mount_point.dart';
import 'package:nfs_mounter/views/mount_point_dialog.dart';
import 'package:nfs_mounter/views/mount_point_list_item.dart';
import 'package:nfs_mounter/services/nfs_service.dart';
import 'package:nfs_mounter/controllers/theme_controller.dart';

class HomeScreen extends StatefulWidget {
  final ThemeController? themeController;
  const HomeScreen({super.key, this.themeController});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Temporary state for demonstration
  List<MountPoint> _mountPoints = [];

  @override
  void initState() {
    super.initState();
    _loadMountPoints();
  }

  Future<void> _loadMountPoints() async {
    final prefs = await SharedPreferences.getInstance();
    final String? mountPointsJson = prefs.getString('mount_points');
    if (mountPointsJson != null) {
      final List<dynamic> decoded = jsonDecode(mountPointsJson);
      if (!mounted) return;
      setState(() {
        _mountPoints = decoded
            .map((json) => MountPoint.fromJson(json))
            .toList();
      });
      // 저장된 상태와 실제 시스템 상태 동기화
      _checkMountStatus();
    }
  }

  Future<void> _checkMountStatus() async {
    bool stateChanged = false;
    final List<MountPoint> updatedList = [];

    for (final mountPoint in _mountPoints) {
      final isMounted = await _nfsService.isMounted(mountPoint.localPath);
      if (mountPoint.isMounted != isMounted) {
        updatedList.add(mountPoint.copyWith(isMounted: isMounted));
        stateChanged = true;
      } else {
        updatedList.add(mountPoint);
      }
    }

    if (stateChanged && mounted) {
      setState(() {
        _mountPoints = updatedList;
        _saveMountPoints();
      });
    }
  }

  Future<void> _saveMountPoints() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(
      _mountPoints.map((m) => m.toJson()).toList(),
    );
    await prefs.setString('mount_points', encoded);
  }

  void _addMountPoint() async {
    final result = await showDialog<MountPoint>(
      context: context,
      builder: (context) => const MountPointDialog(),
    );

    if (result != null) {
      setState(() {
        _mountPoints.add(result);
        _saveMountPoints();
      });
    }
  }

  void _editMountPoint(int index) async {
    final result = await showDialog<MountPoint>(
      context: context,
      builder: (context) => MountPointDialog(mountPoint: _mountPoints[index]),
    );

    if (result != null) {
      setState(() {
        _mountPoints[index] = result;
        _saveMountPoints();
      });
    }
  }

  void _deleteMountPoint(int index) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteMountPoint),
        content: Text(
          AppLocalizations.of(
            context,
          )!.deleteConfirmation(_mountPoints[index].name),
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
      setState(() {
        _mountPoints.removeAt(index);
        _saveMountPoints();
      });
    }
  }

  final _nfsService = NfsService();

  Future<void> _toggleMount(int index) async {
    final mountPoint = _mountPoints[index];
    try {
      // 진행 중 표시 (옵션)
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

      if (mountPoint.isMounted) {
        await _nfsService.unmount(mountPoint);
      } else {
        await _nfsService.mount(mountPoint);
      }

      if (!mounted) return;

      setState(() {
        _mountPoints[index] = mountPoint.copyWith(
          isMounted: !mountPoint.isMounted,
        );
      });

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
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.error(e.toString())),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSettingsDialog() {
    if (widget.themeController == null) return;

    showDialog(
      context: context,
      builder: (context) {
        return ListenableBuilder(
          listenable: widget.themeController!,
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
                  ...ThemeMode.values.map((mode) {
                    return RadioListTile<ThemeMode>(
                      title: Text(_getThemeModeName(context, mode)),
                      value: mode,
                      groupValue: widget.themeController!.themeMode,
                      onChanged: (val) {
                        if (val != null) {
                          widget.themeController!.updateThemeMode(val);
                        }
                      },
                    );
                  }),
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
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.dns), // Logo placeholder
            SizedBox(width: 8),
            Text('NFS Mounter'),
          ],
        ),
        actions: [
          if (widget.themeController != null)
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: _showSettingsDialog,
              tooltip: AppLocalizations.of(context)!.settings,
            ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: FilledButton.icon(
              onPressed: _addMountPoint,
              icon: const Icon(Icons.add),
              label: Text(AppLocalizations.of(context)!.addMountPoint),
            ),
          ),
        ],
      ),
      body: _mountPoints.isEmpty
          ? Center(child: Text(AppLocalizations.of(context)!.noMountPoints))
          : ReorderableListView.builder(
              buildDefaultDragHandles: false,
              itemCount: _mountPoints.length,
              onReorder: _onReorder,
              itemBuilder: (context, index) {
                return MountPointListItem(
                  key: ValueKey(_mountPoints[index].id),
                  index: index,
                  mountPoint: _mountPoints[index],
                  onEdit: () => _editMountPoint(index),
                  onDelete: () => _deleteMountPoint(index),
                  onToggleMount: () => _toggleMount(index),
                  onOpenFinder: () =>
                      _openInFinder(_mountPoints[index].localPath),
                );
              },
            ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final MountPoint item = _mountPoints.removeAt(oldIndex);
      _mountPoints.insert(newIndex, item);
      _saveMountPoints();
    });
  }
}
