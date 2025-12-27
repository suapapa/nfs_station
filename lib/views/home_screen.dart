import 'package:flutter/material.dart';
import 'package:nfs_mounter/l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.appTitle)),
      body: Center(child: Text(AppLocalizations.of(context)!.appTitle)),
    );
  }
}
