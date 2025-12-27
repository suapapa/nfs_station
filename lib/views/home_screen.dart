import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nfs_mounter/models/mount_point.dart';
import 'package:nfs_mounter/views/mount_point_dialog.dart';
import 'package:nfs_mounter/views/mount_point_list_item.dart';
import 'package:nfs_mounter/services/nfs_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
        title: const Text('마운트 포인트 삭제'),
        content: Text('\'${_mountPoints[index].name}\'을(를) 정말 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('삭제'),
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
          content: Text(mountPoint.isMounted ? '언마운트 중...' : '마운트 중...'),
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
                ? '마운트 성공'
                : '언마운트 성공', // 토글 전 상태 기준 메시지 (mounted=false -> 마운트 성공)
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류: $e'), backgroundColor: Colors.red),
      );
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
                  onDelete: () => _deleteMountPoint(index),
                  onToggleMount: () => _toggleMount(index),
                );
              },
            ),
    );
  }
}
