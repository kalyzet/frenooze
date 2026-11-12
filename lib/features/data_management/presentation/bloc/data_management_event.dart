import 'package:equatable/equatable.dart';

import '../../domain/entities/export_format.dart';
import '../../domain/entities/import_strategy.dart';

/// Events for [DataManagementBloc] (PRD §4.9–§4.10).
sealed class DataManagementEvent extends Equatable {
  const DataManagementEvent();

  @override
  List<Object?> get props => <Object?>[];
}

final class ExportRequested extends DataManagementEvent {
  const ExportRequested({
    required this.format,
    this.fromUtc,
    this.toUtc,
  });

  final ExportFormat format;
  final DateTime? fromUtc;
  final DateTime? toUtc;

  @override
  List<Object?> get props => <Object?>[format, fromUtc, toUtc];
}

final class PreviewImportRequested extends DataManagementEvent {
  const PreviewImportRequested(this.rawJson);

  final String rawJson;

  @override
  List<Object?> get props => <Object?>[rawJson];
}

final class ApplyImportRequested extends DataManagementEvent {
  const ApplyImportRequested(this.strategy);

  final ImportStrategy strategy;

  @override
  List<Object?> get props => <Object?>[strategy];
}

final class ResetDataManagementRequested extends DataManagementEvent {
  const ResetDataManagementRequested();
}
