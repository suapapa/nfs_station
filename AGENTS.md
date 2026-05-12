# AGENTS.md - NFS Mounter

AI-native context for building, maintaining, and scaling the **NFS Mounter** (NFS Station) macOS GUI.

## 1. Quick Context
| Attribute | Value |
| :--- | :--- |
| **Goal** | macOS GUI for managing NFS mounts. |
| **Stack** | Flutter (macOS), Dart, MVC-ish. |
| **State** | `setState` + `SharedPreferences` + `ThemeController`. |
| **L10n** | `en`, `ko`, `pl` via `.arb` files. |

## 2. Architecture & Boundaries
- **Models** (`lib/models/`): Data classes (e.g., `MountPoint`).
- **Views** (`lib/views/`): Screens and widgets. Keep logic minimal.
- **Services** (`lib/services/`): Side-effects: shell commands, persistence.
- **Controllers** (`lib/controllers/`): App-wide state (e.g., `ThemeController`).
- **L10n** (`lib/l10n/`): Strings. Run `flutter gen-l10n` after edits.

## 3. Procedural Workflows

### 3.1. Adding a New UI String
1. Update `lib/l10n/app_en.arb`, `app_ko.arb`, and `app_pl.arb`.
2. Run `flutter gen-l10n` to update generated classes.
3. Access in UI via `AppLocalizations.of(context)!.keyName`.

### 3.2. Modifying NFS Logic
1. Update `lib/services/nfs_service.dart`.
2. Use `osascript` for commands requiring sudo (mount/unmount).
3. Verify via `flutter test`.

## 4. Decision Table
| If you need to... | Use... | Avoid... |
| :--- | :--- | :--- |
| Persist user settings | `SharedPreferences` | SQLite/Files directly |
| Run shell commands | `NfsService` | `Process.run` in Views |
| Manage theme | `ThemeController` | Local `setState` for brightness |

## 5. Patterns & Snippets

### NFS Mount Command Pattern
```dart
final command = 'mount -t nfs -o nfsvers=${mp.nfsVersion},resvport,rw,nfc "${mp.serverAddress}:${mp.serverPath}" "$localPath"';
// Use osascript for sudo
final script = 'do shell script "$command" with administrator privileges';
```

### L10n Placeholder Pattern
```json
"deleteConfirmation": "Are you sure you want to delete '{name}'?",
"@deleteConfirmation": { "placeholders": { "name": { "type": "String" } } }
```

## 6. Guards & Constraints
| DON'T | DO |
| :--- | :--- |
| Block UI with shell commands. | Use `async/await` and show loaders in UI. |
| Hardcode UI strings. | Add to `.arb` files and use `AppLocalizations`. |
| Put complex logic in `build()`. | Move logic to `Services` or `Controllers`. |
| Bypass `ThemeController`. | Wrap root with `ListenableBuilder` using `ThemeController`. |
