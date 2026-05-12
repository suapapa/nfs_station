# NFS Station

A Flutter-based desktop application that helps you easily mount and manage NFS (Network File System) directories on macOS.

![screenshot](docs/screenshot.png)

## Key Features

- **GUI-based Mount Management**: Mount and unmount NFS servers with an intuitive interface without using the command line.
- **NFS Version Selection**: Choose NFSv3 or NFSv4 per mount point.
- **Persist Mount Points**: Configured mount points (server address, path, etc.) are saved even after the app is closed, making them convenient to use when you restart.
- **Reorder Mount Points**: Easily change the order of mount points by dragging the hamburger menu icon.
- **Import/Export Configuration**: Export and import mount point settings as JSON files.
- **Theme Management**: Switch between system default, light, and dark themes.
- **Open in Finder**: Open mounted directories directly in Finder.
- **Multi-language Support**: Includes support for English (EN), Korean (KO), and Polish (PL).
- **Productivity**: Quickly connect and manage frequently used NFS paths.

## Getting Started

This project is developed as a macOS application. You need to have the Flutter SDK installed to run it.

1. Clone the repository.
2. Install dependencies.
   ```bash
   flutter pub get
   ```
3. Run the app with the macOS target.
   ```bash
   flutter run -d macos
   ```

## Requirements

- macOS
- Access permissions to an NFS server

## License

This project is distributed under the [MIT License](LICENSE).