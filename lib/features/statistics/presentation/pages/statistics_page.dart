import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Statistics placeholder for Phase 1.
class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistik')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.insights, size: 48),
              SizedBox(height: AppSpacing.md),
              Text('Statistik belum tersedia.', style: AppTypography.heading3),
              SizedBox(height: AppSpacing.xs),
              Text(
                'Statistik akan muncul setelah ada sesi tidur selesai.',
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