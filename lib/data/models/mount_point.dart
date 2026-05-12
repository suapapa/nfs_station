import 'package:yaml/yaml.dart';

class MountPoint {
  final String id;
  String name;
  String serverAddress;
  String serverPath;
  String localPath;
  bool isMounted;
  int nfsVersion;

  MountPoint({
    required this.id,
    required this.name,
    required this.serverAddress,
    required this.serverPath,
    required this.localPath,
    this.isMounted = false,
    this.nfsVersion = 4,
  });

  MountPoint copyWith({
    String? id,
    String? name,
    String? serverAddress,
    String? serverPath,
    String? localPath,
    bool? isMounted,
    int? nfsVersion,
  }) {
    return MountPoint(
      id: id ?? this.id,
      name: name ?? this.name,
      serverAddress: serverAddress ?? this.serverAddress,
      serverPath: serverPath ?? this.serverPath,
      localPath: localPath ?? this.localPath,
      isMounted: isMounted ?? this.isMounted,
      nfsVersion: nfsVersion ?? this.nfsVersion,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'serverAddress': serverAddress,
      'serverPath': serverPath,
      'localPath': localPath,
      'nfsVersion': nfsVersion,
    };
  }

  factory MountPoint.fromJson(Map<String, dynamic> json) {
    return MountPoint(
      id: json['id'] as String,
      name: json['name'] as String,
      serverAddress: json['serverAddress'] as String,
      serverPath: json['serverPath'] as String,
      localPath: json['localPath'] as String,
      isMounted: false,
      nfsVersion: json['nfsVersion'] as int? ?? 4,
    );
  }

  Map<String, dynamic> toYamlMap() {
    return {
      'name': name,
      'server_address': serverAddress,
      'server_path': serverPath,
      'local_path': localPath,
      'nfs_version': nfsVersion,
    };
  }

  factory MountPoint.fromYamlMap(Map yaml) {
    return MountPoint(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: yaml['name'] as String,
      serverAddress: yaml['server_address'] as String,
      serverPath: yaml['server_path'] as String,
      localPath: yaml['local_path'] as String,
      nfsVersion: yaml['nfs_version'] as int? ?? 4,
    );
  }

  static String mountPointsToYaml(List<MountPoint> mountPoints) {
    final buffer = StringBuffer();
    buffer.writeln('mount_points:');
    for (final mp in mountPoints) {
      buffer.writeln('  - name: "${mp.name}"');
      buffer.writeln('    server_address: "${mp.serverAddress}"');
      buffer.writeln('    server_path: "${mp.serverPath}"');
      buffer.writeln('    local_path: "${mp.localPath}"');
      buffer.writeln('    nfs_version: ${mp.nfsVersion}');
    }
    return buffer.toString();
  }

  static List<MountPoint> mountPointsFromYaml(String yamlString) {
    final doc = loadYaml(yamlString);
    if (doc is! YamlMap || doc['mount_points'] is! YamlList) {
      throw const FormatException('Invalid YAML format');
    }
    final list = doc['mount_points'] as YamlList;
    return list.map((item) => MountPoint.fromYamlMap(item as YamlMap)).toList();
  }
}
