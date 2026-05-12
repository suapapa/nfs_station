import 'package:flutter/material.dart';
import '../../../../data/models/mount_point.dart';
import '../../../../data/repositories/mount_point_repository.dart';
import '../../../../data/services/nfs_service.dart';

class HomeViewModel extends ChangeNotifier {
  final MountPointRepository _repository;
  final NfsService _nfsService;

  List<MountPoint> _mountPoints = [];
  final bool _isLoading = false;

  HomeViewModel({
    required MountPointRepository repository,
    required NfsService nfsService,
  })  : _repository = repository,
        _nfsService = nfsService {
    _loadMountPoints();
  }

  List<MountPoint> get mountPoints => _mountPoints;
  bool get isLoading => _isLoading;

  void _loadMountPoints() {
    _mountPoints = _repository.getMountPoints();
    _checkMountStatus();
    notifyListeners();
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

    if (stateChanged) {
      _mountPoints = updatedList;
      _repository.saveMountPoints(_mountPoints);
      notifyListeners();
    }
  }

  Future<void> addMountPoint(MountPoint mountPoint) async {
    _mountPoints.add(mountPoint);
    await _repository.saveMountPoints(_mountPoints);
    notifyListeners();
  }

  Future<void> updateMountPoint(int index, MountPoint mountPoint) async {
    _mountPoints[index] = mountPoint;
    await _repository.saveMountPoints(_mountPoints);
    notifyListeners();
  }

  Future<void> deleteMountPoint(int index) async {
    _mountPoints.removeAt(index);
    await _repository.saveMountPoints(_mountPoints);
    notifyListeners();
  }

  Future<void> reorderMountPoints(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final MountPoint item = _mountPoints.removeAt(oldIndex);
    _mountPoints.insert(newIndex, item);
    await _repository.saveMountPoints(_mountPoints);
    notifyListeners();
  }

  Future<void> toggleMount(int index) async {
    final mountPoint = _mountPoints[index];

    if (mountPoint.isMounted) {
      await _nfsService.unmount(mountPoint);
    } else {
      await _nfsService.mount(mountPoint);
    }

    // After successful mount/unmount, update the state
    _mountPoints[index] = mountPoint.copyWith(
      isMounted: !mountPoint.isMounted,
    );
    await _repository.saveMountPoints(_mountPoints);
    notifyListeners();
  }

  Future<void> importMountPoints(List<MountPoint> imported) async {
    _mountPoints = imported;
    await _repository.saveMountPoints(_mountPoints);
    notifyListeners();
  }
}
