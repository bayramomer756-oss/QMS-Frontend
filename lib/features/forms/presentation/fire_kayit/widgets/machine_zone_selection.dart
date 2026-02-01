import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/widgets/forms/custom_dropdown.dart';

/// Machine and zone selection section
class MachineZoneSelection extends StatelessWidget {
  final String? selectedMachine;
  final String? selectedZone;
  final List<String> machineOptions;
  final List<String> zoneOptions;
  final Function(String?) onMachineChanged;
  final Function(String?) onZoneChanged;

  const MachineZoneSelection({
    super.key,
    required this.selectedMachine,
    required this.selectedZone,
    required this.machineOptions,
    required this.zoneOptions,
    required this.onMachineChanged,
    required this.onZoneChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomDropdown(
            label: 'Tezgah',
            value: selectedMachine,
            items: machineOptions,
            icon: LucideIcons.monitor,
            onChanged: onMachineChanged,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: CustomDropdown(
            label: 'Bölge S.',
            value: selectedZone,
            items: zoneOptions,
            icon: LucideIcons.mapPin,
            onChanged: onZoneChanged,
          ),
        ),
      ],
    );
  }
}
