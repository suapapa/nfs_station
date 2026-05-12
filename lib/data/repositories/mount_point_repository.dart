import 'dart:convert';
import '../models/mount_point.dart';
import '../services/local_storage_service.dart';

class MountPointRepository {
  static const String _storageKey = 'mount_points';
  final LocalStorageService _storage;

  MountPointRepository(this._storage);

  List<MountPoint> getMountPoints() {
    final String? jsonStr = _storage.getString(_storageKey);
    if (jsonStr == null) return [];

    try {
      final List<dynamic> decoded = jsonDecode(jsonStr);
      return decoded.map((json) => MountPoint.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveMountPoints(List<MountPoint> mountPoints) async {
    final String encoded = jsonEncode(
      mountPoints.map((m) => m.toJson()).toList(),
    );
    await _storage.setString(_storageKey, encoded);
  }
}
