import 'package:flutter/material.dart';
import 'package:nfs_mounter/models/mount_point.dart';
import 'package:nfs_mounter/views/mount_point_dialog.dart';
import 'package:nfs_mounter/views/mount_point_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Temporary state for demonstration
  final List<MountPoint> _mountPoints = [];

  void _addMountPoint() async {
    final result = await showDialog<MountPoint>(
      context: context,
      builder: (context) => const MountPointDialog(),
    );

    if (result != null) {
      setState(() {
        _mountPoints.add(result);
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
      });
    }
  }

  void _toggleMount(int index) {
    setState(() {
      _mountPoints[index].isMounted = !_mountPoints[index].isMounted;
    });
    // TODO: Implement actual mount/unmount logic
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
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: FilledButton.icon(
              onPressed: _addMountPoint,
              icon: const Icon(Icons.add),
              label: const Text('마운트 포인트 추가'),
            ),
          ),
        ],
      ),
      body: _mountPoints.isEmpty
          ? const Center(child: Text('등록된 마운트 포인트가 없습니다.'))
          : ListView.builder(
              itemCount: _mountPoints.length,
              itemBuilder: (context, index) {
                return MountPointListItem(
                  mountPoint: _mountPoints[index],
                  onEdit: () => _editMountPoint(index),
                  onToggleMount: () => _toggleMount(index),
                );
              },
            ),
    );
  }
}
