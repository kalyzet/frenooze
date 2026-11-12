import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/import_preview.dart';
import '../../domain/entities/import_summary.dart';
import '../../domain/exceptions/data_management_exception.dart';
import '../../domain/usecases/apply_sleep_data_import.dart';
import '../../domain/usecases/export_sleep_data.dart';
import '../../domain/usecases/preview_sleep_data_import.dart';
import 'data_management_event.dart';
import 'data_management_state.dart';

export 'data_management_event.dart';
export 'data_management_state.dart';

/// Export / import orchestration (PRD §4.9–§4.10, ARCHITECTURE §5.6).
///
/// Produces file content and previews; the UI owns file pickers and share
/// sheets. Import applies only after an explicit strategy confirmation.
class DataManagementBloc
    extends Bloc<DataManagementEvent, DataManagementState> {
  DataManagementBloc({
    required ExportSleepData exportSleepData,
    required PreviewSleepDataImport previewSleepDataImport,
    required ApplySleepDataImport applySleepDataImport,
  }) : _exportSleepData = exportSleepData,
       _previewSleepDataImport = previewSleepDataImport,
       _applySleepDataImport = applySleepDataImport,
       super(const DataManagementInitial()) {
    on<ExportRequested>(_onExport);
    on<PreviewImportRequested>(_onPreviewImport);
    on<ApplyImportRequested>(_onApplyImport);
    on<ResetDataManagementRequested>(_onReset);
  }

  final ExportSleepData _exportSleepData;
  final PreviewSleepDataImport _previewSleepDataImport;
  final ApplySleepDataImport _applySleepDataImport;

  ImportPreview? _preview;

  Future<void> _onExport(
    ExportRequested event,
    Emitter<DataManagementState> emit,
  ) async {
    emit(const DataManagementExporting());
    try {
      final result = await _exportSleepData(
        format: event.format,
        fromUtc: event.fromUtc,
        toUtc: event.toUtc,
      );
      emit(DataManagementExportSuccess(result));
    } on DataManagementException catch (error) {
      emit(DataManagementExportFailure(error.message));
    } on Exception {
      emit(
        const DataManagementExportFailure(
          'Gagal membuat file export. Coba lagi.',
        ),
      );
    }
  }

  Future<void> _onPreviewImport(
    PreviewImportRequested event,
    Emitter<DataManagementState> emit,
  ) async {
    emit(const DataManagementImportPreviewLoading());
    try {
      final preview = await _previewSleepDataImport(event.rawJson);
      _preview = preview;
      emit(DataManagementImportPreviewReady(preview));
    } on DataManagementException catch (error) {
      _preview = null;
      emit(DataManagementImportFailure(error.message));
    } on Exception {
      _preview = null;
      emit(
        const DataManagementImportFailure(
          'File tidak dapat dibaca. Coba file backup lain.',
        ),
      );
    }
  }

  Future<void> _onApplyImport(
    ApplyImportRequested event,
    Emitter<DataManagementState> emit,
  ) async {
    final ImportPreview? preview = _preview;
    if (preview == null) {
      emit(
        const DataManagementImportFailure(
          'Pratinjau import tidak tersedia. Pilih file lagi.',
        ),
      );
      return;
    }

    emit(const DataManagementImportApplying());
    try {
      final ImportSummary summary = await _applySleepDataImport(
        preview: preview,
        strategy: event.strategy,
      );
      _preview = null;
      emit(DataManagementImportSuccess(summary));
    } on DataManagementException catch (error) {
      emit(DataManagementImportFailure(error.message));
    } on Exception {
      emit(
        const DataManagementImportFailure(
          'Import gagal. Tidak ada perubahan yang diterapkan.',
        ),
      );
    }
  }

  Future<void> _onReset(
    ResetDataManagementRequested event,
    Emitter<DataManagementState> emit,
  ) async {
    _preview = null;
    emit(const DataManagementInitial());
  }
}
