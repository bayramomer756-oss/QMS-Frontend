import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/widgets/forms/custom_text_field.dart';
import '../../../../../core/widgets/forms/stepper_field.dart';

/// Product information section for Fire Kayit form
class ProductInfoSection extends StatelessWidget {
  final TextEditingController productCodeController;
  final TextEditingController productNameController;
  final TextEditingController productTypeController;
  final TextEditingController quantityController;
  final VoidCallback onQuantityDecrement;
  final VoidCallback onQuantityIncrement;

  const ProductInfoSection({
    super.key,
    required this.productCodeController,
    required this.productNameController,
    required this.productTypeController,
    required this.quantityController,
    required this.onQuantityDecrement,
    required this.onQuantityIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // First Row: Ürün Kodu, Adet
        Row(
          children: [
            Expanded(
              flex: 2,
              child: CustomTextField(
                label: 'Ürün Kodu',
                controller: productCodeController,
                icon: LucideIcons.package,
              ),
            ),
            const SizedBox(width: 12),
            StepperField(
              label: 'Adet',
              controller: quantityController,
              width: 140,
              onDecrement: onQuantityDecrement,
              onIncrement: onQuantityIncrement,
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Second Row: Ürün Adı
        CustomTextField(
          label: 'Ürün Adı',
          controller: productNameController,
          icon: LucideIcons.tag,
        ),
        const SizedBox(height: 12),

        // Third Row: Ürün Tipi
        CustomTextField(
          label: 'Ürün Tipi (Enjeksiyon vb.)',
          controller: productTypeController,
          icon: LucideIcons.layers,
        ),
      ],
    );
  }
}
