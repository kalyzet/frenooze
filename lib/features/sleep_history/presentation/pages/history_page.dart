import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Sleep history placeholder for Phase 1.
class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Tidur')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.history, size: 48),
              SizedBox(height: AppSpacing.md),
              Text('Belum ada riwayat tidur.', style: AppTypography.heading3),
              SizedBox(height: AppSpacing.xs),
              Text(
                'Mulai catat tidur pertamamu dari dashboard.',
                style: AppTypography.secondary,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}