class MountPoint {
  final String id;
  String name;
  String serverAddress;
  String serverPath;
  String localPath;
  bool isMounted;

  MountPoint({
    required this.id,
    required this.name,
    required this.serverAddress,
    required this.serverPath,
    required this.localPath,
    this.isMounted = false,
  });

  MountPoint copyWith({
    String? id,
    String? name,
    String? serverAddress,
    String? serverPath,
    String? localPath,
    bool? isMounted,
  }) {
    return MountPoint(
      id: id ?? this.id,
      name: name ?? this.name,
      serverAddress: serverAddress ?? this.serverAddress,
      serverPath: serverPath ?? this.serverPath,
      localPath: localPath ?? this.localPath,
      isMounted: isMounted ?? this.isMounted,
    );
  }
}
