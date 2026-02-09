import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/constants/app_colors.dart';

/// Şarj No picker section (without error reason)
class SarjNoSection extends StatefulWidget {
  final TextEditingController sarjDayController;
  final TextEditingController sarjLineController;
  final int sarjYear;
  final String sarjFoundry;
  final List<String> foundryOptions;
  final Function(int) onYearChanged;
  final Function(String) onFoundryChanged;

  const SarjNoSection({
    super.key,
    required this.sarjDayController,
    required this.sarjLineController,
    required this.sarjYear,
    required this.sarjFoundry,
    required this.foundryOptions,
    required this.onYearChanged,
    required this.onFoundryChanged,
  });

  @override
  State<SarjNoSection> createState() => _SarjNoSectionState();
}

class _SarjNoSectionState extends State<SarjNoSection> {
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
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: Icon(Icons.numbers, color: Colors.white, size: 18),
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
                  _buildStepperField(
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
                  _buildStepperField(
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
                        color: Colors.white,
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
      ],
    );
  }

  Widget _buildStepperBox({
    required String value,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onDecrement,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Icon(Icons.chevron_left, size: 16, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textMain,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          InkWell(
            onTap: onIncrement,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Icon(Icons.chevron_right, size: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepperField({
    required TextEditingController controller,
    required double width,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
    bool isText = false,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      width: width,
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onDecrement,
            child: Icon(
              Icons.chevron_left,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: isText ? TextInputType.text : TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: inputFormatters,
              style: const TextStyle(
                color: AppColors.textMain,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
          InkWell(
            onTap: onIncrement,
            child: Icon(
              Icons.chevron_right,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
