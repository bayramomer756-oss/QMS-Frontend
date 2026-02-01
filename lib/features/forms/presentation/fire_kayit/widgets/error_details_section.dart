import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/forms/custom_dropdown.dart';
import '../../../../../core/widgets/forms/stepper_field.dart';

/// Error details section with Şarj No picker and error reason
class ErrorDetailsSection extends StatefulWidget {
  final TextEditingController sarjDayController;
  final TextEditingController sarjLineController;
  final int sarjYear;
  final String sarjFoundry;
  final List<String> foundryOptions;
  final String? selectedErrorReason;
  final List<String> errorReasons;
  final Function(int) onYearChanged;
  final Function(String) onFoundryChanged;
  final Function(String?) onErrorReasonChanged;

  const ErrorDetailsSection({
    super.key,
    required this.sarjDayController,
    required this.sarjLineController,
    required this.sarjYear,
    required this.sarjFoundry,
    required this.foundryOptions,
    required this.selectedErrorReason,
    required this.errorReasons,
    required this.onYearChanged,
    required this.onFoundryChanged,
    required this.onErrorReasonChanged,
  });

  @override
  State<ErrorDetailsSection> createState() => _ErrorDetailsSectionState();
}

class _ErrorDetailsSectionState extends State<ErrorDetailsSection> {
  String get _batchNo {
    final dayStr = widget.sarjDayController.text.padLeft(3, '0');
    final lineStr = widget.sarjLineController.text.isNotEmpty
        ? widget.sarjLineController.text.toUpperCase()
        : 'A';
    return '${widget.sarjYear}${widget.sarjFoundry}$dayStr$lineStr';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Şarj No Picker
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Şarj No',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(
                    LucideIcons.hash,
                    color: AppColors.textSecondary,
                    size: 16,
                  ),
                  const SizedBox(width: 12),
                  // Year
                  _buildStepperBox(
                    value: widget.sarjYear.toString().padLeft(2, '0'),
                    onDecrement: () => widget.onYearChanged(
                      (widget.sarjYear - 1).clamp(0, 99),
                    ),
                    onIncrement: () => widget.onYearChanged(
                      (widget.sarjYear + 1).clamp(0, 99),
                    ),
                  ),
                  const SizedBox(width: 4),
                  // Foundry
                  _buildStepperBox(
                    value: widget.sarjFoundry,
                    onDecrement: () {
                      final idx = widget.foundryOptions.indexOf(
                        widget.sarjFoundry,
                      );
                      widget.onFoundryChanged(
                        widget.foundryOptions[(idx -
                                1 +
                                widget.foundryOptions.length) %
                            widget.foundryOptions.length],
                      );
                    },
                    onIncrement: () {
                      final idx = widget.foundryOptions.indexOf(
                        widget.sarjFoundry,
                      );
                      widget.onFoundryChanged(
                        widget.foundryOptions[(idx + 1) %
                            widget.foundryOptions.length],
                      );
                    },
                  ),
                  const SizedBox(width: 4),
                  // Day
                  StepperField(
                    controller: widget.sarjDayController,
                    width: 80,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(3),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onDecrement: () {
                      int current =
                          int.tryParse(widget.sarjDayController.text) ?? 1;
                      current = (current - 1).clamp(1, 366);
                      widget.sarjDayController.text = current
                          .toString()
                          .padLeft(3, '0');
                      setState(() {});
                    },
                    onIncrement: () {
                      int current =
                          int.tryParse(widget.sarjDayController.text) ?? 1;
                      current = (current + 1).clamp(1, 366);
                      widget.sarjDayController.text = current
                          .toString()
                          .padLeft(3, '0');
                      setState(() {});
                    },
                  ),
                  const SizedBox(width: 4),
                  // Line
                  StepperField(
                    controller: widget.sarjLineController,
                    width: 60,
                    isText: true,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                    ],
                    onDecrement: () {
                      String current = widget.sarjLineController.text
                          .toUpperCase();
                      if (current.isEmpty) current = 'A';
                      int code = current.codeUnitAt(0);
                      if (code > 65) {
                        widget.sarjLineController.text = String.fromCharCode(
                          code - 1,
                        );
                      } else {
                        widget.sarjLineController.text = 'Z';
                      }
                      setState(() {});
                    },
                    onIncrement: () {
                      String current = widget.sarjLineController.text
                          .toUpperCase();
                      if (current.isEmpty) current = 'A';
                      int code = current.codeUnitAt(0);
                      if (code < 90) {
                        widget.sarjLineController.text = String.fromCharCode(
                          code + 1,
                        );
                      } else {
                        widget.sarjLineController.text = 'A';
                      }
                      setState(() {});
                    },
                  ),
                  const Spacer(),
                  // Result Display
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      _batchNo,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Error Reason Dropdown
        CustomDropdown(
          label: 'Hata Nedeni',
          value: widget.selectedErrorReason,
          items: widget.errorReasons,
          icon: LucideIcons.alertCircle,
          onChanged: widget.onErrorReasonChanged,
        ),
      ],
    );
  }

  Widget _buildStepperBox({
    required String value,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Container(
      width: 50,
      height: 38,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onIncrement,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: const Icon(
                    LucideIcons.chevronUp,
                    size: 12,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
          Container(height: 1, color: AppColors.glassBorder),
          Container(
            height: 16,
            alignment: Alignment.center,
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textMain,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(height: 1, color: AppColors.glassBorder),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onDecrement,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: const Icon(
                    LucideIcons.chevronDown,
                    size: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
