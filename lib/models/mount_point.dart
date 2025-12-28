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
      isMounted: false, // Default to false when loaded
      nfsVersion: json['nfsVersion'] as int? ?? 4,
    );
  }
}
