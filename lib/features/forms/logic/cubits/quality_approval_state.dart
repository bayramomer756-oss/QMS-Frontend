import 'package:freezed_annotation/freezed_annotation.dart';

part 'quality_approval_state.freezed.dart';

@freezed
abstract class QualityApprovalState with _$QualityApprovalState {
  const QualityApprovalState._();

  const factory QualityApprovalState({
    @Default('') String productCode,
    String? productName,
    String? productType,
    @Default(1) int amount,
    @Default('Uygun') String complianceStatus,
    String? rejectCode,
    @Default('') String description,
    required DateTime selectedDateTime,
    @Default(false) bool isSubmitting,
    String? errorMessage,
  }) = _QualityApprovalState;

  factory QualityApprovalState.initial() =>
      QualityApprovalState(selectedDateTime: DateTime.now());
}
