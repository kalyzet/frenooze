import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/widgets/app_logo.dart';
import '../../../data_management/domain/entities/export_format.dart';
import '../../../data_management/domain/entities/import_preview.dart';
import '../../../data_management/domain/entities/import_strategy.dart';
import '../../../data_management/domain/entities/import_summary.dart';
import '../../../data_management/presentation/bloc/data_management_bloc.dart';

/// Settings: data export & import (PRD §4.9–§4.10, DESIGN §9).
///
/// The bloc produces content / previews; this page owns file pickers,
/// share sheets, and confirmation dialogs.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _export(
    BuildContext context,
    ExportFormat format,
  ) async {
    context.read<DataManagementBloc>().add(ExportRequested(format: format));
  }

  Future<void> _saveOrShareExport(
    BuildContext context,
    DataManagementExportSuccess state,
  ) async {
    final Uint8List bytes = Uint8List.fromList(
      utf8.encode(state.result.content),
    );
    final String fileName = state.result.suggestedFileName;

    try {
      final Uri? savedUri = await FilePicker.saveFile(
        dialogTitle: 'Simpan ${state.result.format.label}',
        fileName: fileName,
        bytes: bytes,
      );
      if (!context.mounted) {
        return;
      }
      if (savedUri != null) {
        _showSnack(
          context,
          'Tersimpan (${state.result.recordCount} sesi).',
        );
        return;
      }
      // User cancelled the save dialog — fall through to share sheet.
    } on Exception {
      // saveFile unavailable on this platform; fall through to share.
    }

    if (!context.mounted) {
      return;
    }
    await SharePlus.instance.share(
      ShareParams(
        files: <XFile>[XFile.fromData(bytes, name: fileName)],
        text: 'Backup Frenooze (${state.result.recordCount} sesi)',
      ),
    );
  }

  Future<void> _pickAndPreviewImport(BuildContext context) async {
    final List<PlatformFile> files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: <String>['json'],
    );
    if (files.isEmpty) {
      return;
    }
    final PlatformFile file = files.first;
    final Uint8List bytes;
    try {
      bytes = await file.readAsBytes();
    } on Exception {
      if (context.mounted) {
        _showSnack(context, 'File tidak dapat dibaca.');
      }
      return;
    }

    String rawJson;
    try {
      rawJson = utf8.decode(bytes);
    } on FormatException {
      if (context.mounted) {
        _showSnack(context, 'File bukan teks UTF-8 yang valid.');
      }
      return;
    }

    if (!context.mounted) {
      return;
    }
    context
        .read<DataManagementBloc>()
        .add(PreviewImportRequested(rawJson));
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showPreviewDialog(
    BuildContext context,
    DataManagementImportPreviewReady state,
  ) {
    final ImportPreview preview = state.preview;
    final int willAdd = preview.newSessions.length;

    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return _ImportPreviewDialog(
          preview: preview,
          willAdd: willAdd,
          bloc: context.read<DataManagementBloc>(),
        );
      },
    );
  }

  void _showImportSuccess(
    BuildContext context,
    DataManagementImportSuccess state,
  ) {
    final ImportSummary summary = state.summary;
    final String message = switch (summary.strategy) {
      ImportStrategy.merge =>
        'Gabung selesai: ${summary.importedCount} sesi baru, '
            '${summary.skippedDuplicateCount} duplikat dilewati.',
      ImportStrategy.replace =>
        'Ganti selesai: ${summary.importedCount} sesi disimpan.',
    };
    _showSnack(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const LogoTitle('Pengaturan')),
      body: BlocConsumer<DataManagementBloc, DataManagementState>(
        listener: (BuildContext context, DataManagementState state) {
          switch (state) {
            case DataManagementExportSuccess():
              unawaited(_saveOrShareExport(context, state));
            case DataManagementExportFailure():
              _showSnack(context, state.message);
            case DataManagementImportPreviewReady():
              _showPreviewDialog(context, state);
            case DataManagementImportSuccess():
              _showImportSuccess(context, state);
            case DataManagementImportFailure():
              _showSnack(context, state.message);
            default:
              break;
          }
        },
        builder: (BuildContext context, DataManagementState state) {
          final bool busy =
              state is DataManagementExporting ||
              state is DataManagementImportPreviewLoading ||
              state is DataManagementImportApplying;

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Pengelolaan Data',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.data_object),
                title: const Text('Export JSON'),
                subtitle: const Text('Backup lengkap untuk restore'),
                enabled: !busy,
                onTap: busy
                    ? null
                    : () => unawaited(_export(context, ExportFormat.json)),
              ),
              ListTile(
                leading: const Icon(Icons.table_chart_outlined),
                title: const Text('Export CSV'),
                subtitle: const Text('Untuk analisis di spreadsheet'),
                enabled: !busy,
                onTap: busy
                    ? null
                    : () => unawaited(_export(context, ExportFormat.csv)),
              ),
              ListTile(
                leading: const Icon(Icons.upload_file_outlined),
                title: const Text('Import JSON'),
                subtitle: const Text(
                  'Pratinjau dulu — gabung atau ganti data',
                ),
                enabled: !busy,
                onTap: busy ? null : () => unawaited(_pickAndPreviewImport(context)),
              ),
              const Divider(),
              const ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('Tentang Frenooze'),
                subtitle: Text('Versi 1.0.0'),
              ),
              ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'doksli/images/kalyzet.png',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                title: const Text('Kalyzet Team'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ImportPreviewDialog extends StatefulWidget {
  const _ImportPreviewDialog({
    required this.preview,
    required this.willAdd,
    required this.bloc,
  });

  final ImportPreview preview;
  final int willAdd;
  final DataManagementBloc bloc;

  @override
  State<_ImportPreviewDialog> createState() => _ImportPreviewDialogState();
}

class _ImportPreviewDialogState extends State<_ImportPreviewDialog> {
  ImportStrategy _strategy = ImportStrategy.merge;

  @override
  Widget build(BuildContext context) {
    final ImportPreview preview = widget.preview;

    return AlertDialog(
      title: const Text('Pratinjau Import'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Total record: ${preview.totalInFile}'),
              Text('Valid: ${preview.validSessions.length}'),
              Text('Baru (belum ada): ${preview.newSessions.length}'),
              Text('Duplikat: ${preview.duplicateCount}'),
              if (preview.invalidCount > 0)
                Text(
                  'Tidak valid (dilewati): ${preview.invalidCount}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              if (preview.sampleErrors.isNotEmpty) ...<Widget>[
                const SizedBox(height: 8),
                for (final String error in preview.sampleErrors)
                  Text(
                    '• $error',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
              if (preview.hasActiveConflict) ...<Widget>[
                const SizedBox(height: 12),
                Text(
                  'Peringatan: file berisi sesi aktif berbeda dari sesi '
                  'aktif saat ini. Mode Gabung akan ditolak.',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Text(
                'Strategi',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              RadioGroup<ImportStrategy>(
                groupValue: _strategy,
                onChanged: (ImportStrategy? value) {
                  if (value != null) {
                    setState(() => _strategy = value);
                  }
                },
                child: Column(
                  children: <Widget>[
                    for (final ImportStrategy strategy
                        in ImportStrategy.values)
                      RadioListTile<ImportStrategy>(
                        value: strategy,
                        title: Text(strategy.label),
                        subtitle: Text(strategy.description),
                        dense: true,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: _canApply
              ? () {
                  Navigator.of(context).pop();
                  widget.bloc.add(ApplyImportRequested(_strategy));
                }
              : null,
          child: const Text('Terapkan'),
        ),
      ],
    );
  }

  bool get _canApply {
    if (_strategy == ImportStrategy.merge) {
      return widget.willAdd > 0 && !widget.preview.hasActiveConflict;
    }
    return widget.preview.validSessions.isNotEmpty;
  }
}
