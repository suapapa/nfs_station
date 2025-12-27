import 'package:flutter/material.dart';
import 'package:nfs_mounter/models/mount_point.dart';
import 'package:nfs_mounter/l10n/app_localizations.dart';

class MountPointListItem extends StatefulWidget {
  final MountPoint mountPoint;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleMount;

  const MountPointListItem({
    super.key,
    required this.mountPoint,
    required this.onEdit,
    required this.onDelete,
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
                  tooltip: AppLocalizations.of(context)!.editSettings,
                  onPressed: widget.onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: AppLocalizations.of(context)!.delete,
                  onPressed: widget.onDelete,
                ),
                const SizedBox(width: 8),
                FilledButton.tonal(
                  onPressed: widget.onToggleMount,
                  child: Text(
                    widget.mountPoint.isMounted
                        ? AppLocalizations.of(context)!.unmount
                        : AppLocalizations.of(context)!.mount,
                  ),
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
                  _buildDetailRow(
                    AppLocalizations.of(context)!.serverAddress,
                    widget.mountPoint.serverAddress,
                  ),
                  _buildDetailRow(
                    AppLocalizations.of(context)!.serverPath,
                    widget.mountPoint.serverPath,
                  ),
                  _buildDetailRow(
                    AppLocalizations.of(context)!.localPath,
                    widget.mountPoint.localPath,
                  ),
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
