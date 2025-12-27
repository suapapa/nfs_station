import 'package:flutter/material.dart';
import 'package:nfs_mounter/models/mount_point.dart';

class MountPointListItem extends StatefulWidget {
  final MountPoint mountPoint;
  final VoidCallback onEdit;
  final VoidCallback onToggleMount;

  const MountPointListItem({
    super.key,
    required this.mountPoint,
    required this.onEdit,
    required this.onToggleMount,
  });

  @override
  State<MountPointListItem> createState() => _MountPointListItemState();
}

class _MountPointListItemState extends State<MountPointListItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.mountPoint.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: '설정 변경',
                  onPressed: widget.onEdit,
                ),
                const SizedBox(width: 8),
                FilledButton.tonal(
                  onPressed: widget.onToggleMount,
                  child: Text(widget.mountPoint.isMounted ? '언마운트' : '마운트'),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                ),
              ],
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Divider(),
                  _buildDetailRow('서버 주소', widget.mountPoint.serverAddress),
                  _buildDetailRow('서버 디렉터리', widget.mountPoint.serverPath),
                  _buildDetailRow('마운트 디렉터리', widget.mountPoint.localPath),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
