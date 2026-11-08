import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/clinical_report_model.dart';

class ClinicalReportState {
  final ClinicalReportModel currentReport;
  final bool isProcessing;
  final int processingStage; // 1: Audio upload, 2: Faster-Whisper STT, 3: Structuring SOAP
  final bool isTranscriptExpanded;

  const ClinicalReportState({
    required this.currentReport,
    this.isProcessing = false,
    this.processingStage = 1,
    this.isTranscriptExpanded = true,
  });

  ClinicalReportState copyWith({
    ClinicalReportModel? currentReport,
    bool? isProcessing,
    int? processingStage,
    bool? isTranscriptExpanded,
  }) {
    return ClinicalReportState(
      currentReport: currentReport ?? this.currentReport,
      isProcessing: isProcessing ?? this.isProcessing,
      processingStage: processingStage ?? this.processingStage,
      isTranscriptExpanded: isTranscriptExpanded ?? this.isTranscriptExpanded,
    );
  }
}

class ClinicalReportNotifier extends Notifier<ClinicalReportState> {
  @override
  ClinicalReportState build() {
    return ClinicalReportState(
      currentReport: ClinicalReportModel.sampleHamzali(),
    );
  }

  void toggleTranscript() {
    state = state.copyWith(isTranscriptExpanded: !state.isTranscriptExpanded);
  }

  void setReport(ClinicalReportModel report) {
    state = state.copyWith(currentReport: report);
  }

  void setProcessingStage(int stage) {
    state = state.copyWith(processingStage: stage, isProcessing: stage < 4);
  }

  void resetProcessing() {
    state = state.copyWith(isProcessing: true, processingStage: 1);
  }
}

final clinicalReportProvider = NotifierProvider<ClinicalReportNotifier, ClinicalReportState>(
  ClinicalReportNotifier.new,
);
