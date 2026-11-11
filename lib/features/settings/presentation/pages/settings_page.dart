import 'package:flutter/material.dart';

/// Settings placeholder for Phase 1.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        children: const <Widget>[
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Tentang Frenooze'),
            subtitle: Text('Versi 1.0.0'),
          ),
        ],
      ),
    );
  }
}