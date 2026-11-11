import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Dashboard placeholder for Phase 1.
///
/// Phase 2 replaces this with the sleep session state machine and the main
/// sleep action card.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Frenooze')),
      body: const Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Selamat malam',
              style: AppTypography.heading1,
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              'Catat tidurmu dengan satu ketukan.',
              style: AppTypography.secondary,
            ),
            SizedBox(height: AppSpacing.lg),
            Card(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: <Widget>[
                    Icon(Icons.bedtime, size: 48),
                    SizedBox(height: AppSpacing.md),
                    Text(
                      'Saya mau tidur',
                      style: AppTypography.heading2,
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      'Fitur pencatatan aktif pada Fase 2.',
                      style: AppTypography.caption,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}