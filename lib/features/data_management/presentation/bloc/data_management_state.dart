import 'package:equatable/equatable.dart';

import '../../domain/entities/export_result.dart';
import '../../domain/entities/import_preview.dart';
import '../../domain/entities/import_summary.dart';

/// States for [DataManagementBloc] (PRD §4.9–§4.10).
sealed class DataManagementState extends Equatable {
  const DataManagementState();

  @override
  List<Object?> get props => <Object?>[];
}

final class DataManagementInitial extends DataManagementState {
  const DataManagementInitial();
}

final class DataManagementExporting extends DataManagementState {
  const DataManagementExporting();
}

final class DataManagementExportSuccess extends DataManagementState {
  const DataManagementExportSuccess(this.result);

  final ExportResult result;

  @override
  List<Object?> get props => <Object?>[result];
}

final class DataManagementExportFailure extends DataManagementState {
  const DataManagementExportFailure(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}

final class DataManagementImportPreviewLoading extends DataManagementState {
  const DataManagementImportPreviewLoading();
}

final class DataManagementImportPreviewReady extends DataManagementState {
  const DataManagementImportPreviewReady(this.preview);

  final ImportPreview preview;

  @override
  List<Object?> get props => <Object?>[preview];
}

final class DataManagementImportApplying extends DataManagementState {
  const DataManagementImportApplying();
}

final class DataManagementImportSuccess extends DataManagementState {
  const DataManagementImportSuccess(this.summary);

  final ImportSummary summary;

  @override
  List<Object?> get props => <Object?>[summary];
}

final class DataManagementImportFailure extends DataManagementState {
  const DataManagementImportFailure(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
