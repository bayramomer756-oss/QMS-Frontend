import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/form_options.dart';
import '../../../../../core/widgets/forms/form_section_title.dart';
import '../../../../../core/widgets/forms/date_time_form_field.dart';
import '../../../../../core/widgets/forms/product_info_card.dart';
import '../../../../../core/widgets/forms/custom_text_field.dart';
import '../../../../../core/widgets/forms/custom_dropdown.dart';
import '../../../../../core/providers/user_permission_provider.dart';
import '../../providers/fire_kayit_providers.dart';
// Section Widgets
import '../widgets/machine_zone_selection.dart';
import '../widgets/operator_autocomplete.dart';
import '../widgets/photo_upload_section.dart';
import '../widgets/quantity_input.dart';
import '../widgets/sarj_no_section.dart';
import '../fire_kayit_screen.dart'; // For FireEntry class

class ProductionEntryTab extends ConsumerStatefulWidget {
  final DateTime? initialDate;
  const ProductionEntryTab({super.key, this.initialDate});

  @override
  ConsumerState<ProductionEntryTab> createState() => _ProductionEntryTabState();
}

class _ProductionEntryTabState extends ConsumerState<ProductionEntryTab> {
  // Form Controllers
  final _productCodeController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _aciklamaController = TextEditingController();

  // Batch number
  String _batchNo = '';

  // State Variables
  late DateTime _selectedDateTime;
  String? _productName;
  String? _productType;
  String? _selectedProcessedMachine;
  String? _selectedDetectedMachine;
  String? _selectedZone;
  String? _selectedOperation;
  String _productState = 'İşlenmiş';
  String?
  _selectedErrorReason; // Assuming error reason is still relevant? Or maybe not for production entry? keeping it as per "copy structure" instruction
  String? _selectedOperator;
  XFile? _selectedImage;
  File? _selectedExcelFile; // New: Excel file

  // Multi-entry list
  final List<FireEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.initialDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _productCodeController.dispose();
    _quantityController.dispose();
    _aciklamaController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() => _selectedImage = image);
    }
  }

  Future<void> _pickExcelFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xls', 'xlsx'],
    );

    if (result != null) {
      if (!mounted) return;
      setState(() {
        _selectedExcelFile = File(result.files.single.path!);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Excel dosyası seçildi'),
          backgroundColor: AppColors.duzceGreen,
        ),
      );
    }
  }

  void _addEntry() {
    // If this is strictly "Production Entry", maybe error reason IS NOT mandatory?
    // But copying the structure implies similar validation. Assuming "Üretim Adet Giriş" might not need error reason?
    // User said "copy page structure". I'll keep it as is, maybe user wants to log errors related to production?
    // Or maybe they want to log production counts? If so, "Hata Nedeni" might be misleading.
    // However, I will stick to the structure as requested.

    if (_selectedErrorReason == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen hata nedeni seçin'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final quantity = int.tryParse(_quantityController.text) ?? 0;
    if (quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Geçerli bir adet girin'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _entries.add(
        FireEntry(
          errorReason: _selectedErrorReason!,
          quantity: quantity,
          description: _aciklamaController.text.isNotEmpty
              ? _aciklamaController.text
              : null,
          image: _selectedImage,
        ),
      );
      _quantityController.text = '1';
      _selectedErrorReason = null;
      _aciklamaController.clear();
      _selectedImage = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kayıt eklendi'),
        backgroundColor: AppColors.duzceGreen,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _removeEntry(int index) {
    setState(() {
      _entries.removeAt(index);
    });
  }

  Future<void> _submitAllEntries() async {
    if (_entries.isEmpty) return;

    if (_productCodeController.text.isEmpty ||
        _selectedProcessedMachine == null ||
        _selectedZone == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen ürün, tezgah ve bölge bilgilerini doldurun'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const Center(child: CircularProgressIndicator()),
      );

      final tezgahId =
          FormOptions.machines.indexOf(_selectedProcessedMachine!) + 1;
      final bolgeId = FormOptions.zones.indexOf(_selectedZone!) + 1;
      final operasyonId = _selectedOperation != null
          ? FormOptions.operations.indexOf(_selectedOperation!) + 1
          : 1;

      for (final entry in _entries) {
        final retKoduId =
            FormOptions.errorReasons.indexOf(entry.errorReason) + 1;

        final data = {
          'vardiyaId': 1,
          'urunKodu': _productCodeController.text,
          'sarjNo': _batchNo,
          'tezgahId': tezgahId,
          'operasyonId': operasyonId,
          'bolgeId': bolgeId,
          'retKoduId': retKoduId,
          'operatorAdi': _selectedOperator ?? '',
          'aciklama': entry.description ?? '',
          'tespitEdilenTezgah': _selectedDetectedMachine,
        };

        final id = await ref
            .read(createFireKayitFormUseCaseProvider)
            .call(data);

        if (entry.image != null) {
          await ref
              .read(fireKayitRepositoryProvider)
              .uploadPhoto(id, File(entry.image!.path));
        }
      }

      if (mounted) Navigator.of(context).pop();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_entries.length} kayıt başarıyla oluşturuldu'),
            backgroundColor: AppColors.duzceGreen,
            duration: const Duration(seconds: 2),
          ),
        );
      }

      setState(() {
        _entries.clear();
        _quantityController.text = '1';
        _selectedErrorReason = null;
        _aciklamaController.clear();
        _selectedImage = null;
        _selectedExcelFile = null; // Clear excel
      });
    } catch (e) {
      if (mounted) Navigator.of(context).pop();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Excel Upload Button - Added at the top or where appropriate
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _pickExcelFile,
                icon: const Icon(Icons.table_chart, size: 20),
                label: Text(
                  _selectedExcelFile != null
                      ? 'Excel Seçildi: ${_selectedExcelFile!.path.split(Platform.pathSeparator).last}'
                      : 'EXCEL YÜKLE',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.duzceGreen, // Or any distinct color
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 24),

            const FormSectionTitle(
              title: 'Giriş Bilgileri',
              icon: Icons.inventory_2_outlined,
            ),
            const SizedBox(height: 16),
            DateTimeFormField(
              initialDateTime: _selectedDateTime,
              onChanged: (newDateTime) {
                setState(() => _selectedDateTime = newDateTime);
              },
              isEnabled: ref
                  .watch(userPermissionProvider.notifier)
                  .canEditForms(),
              label: 'Tarih ve Saat',
            ),
            const SizedBox(height: 16),
            ProductInfoCard(
              productCodeController: _productCodeController,
              productName: _productName,
              productType: _productType,
              onProductCodeChanged: (code) {
                setState(() {
                  if (code.isEmpty) {
                    _productName = null;
                    _productType = null;
                  }
                });
              },
              onProductSelected: (product) {
                setState(() {
                  _productName = product.urunAdi;
                  _productType = product.urunTuru;
                });
              },
            ),
            const SizedBox(height: 16),
            MachineZoneSelection(
              selectedProcessedMachine: _selectedProcessedMachine,
              selectedDetectedMachine: _selectedDetectedMachine,
              selectedZone: _selectedZone,
              selectedOperation: _selectedOperation,
              machineOptions: FormOptions.machines,
              zoneOptions: FormOptions.zones,
              operationOptions: FormOptions.operations,
              productState: _productState,
              onProcessedMachineChanged: (val) =>
                  setState(() => _selectedProcessedMachine = val),
              onDetectedMachineChanged: (val) =>
                  setState(() => _selectedDetectedMachine = val),
              onZoneChanged: (val) => setState(() => _selectedZone = val),
              onOperationChanged: (val) =>
                  setState(() => _selectedOperation = val),
              onProductStateChanged: (val) =>
                  setState(() => _productState = val!),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 6,
                  child: SarjNoSection(
                    initialDate: widget.initialDate,
                    onBatchNoChanged: (batchNo) {
                      setState(() => _batchNo = batchNo);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 4,
                  child: QuantityInput(
                    controller: _quantityController,
                    onIncrement: () {
                      final current =
                          int.tryParse(_quantityController.text) ?? 1;
                      _quantityController.text = (current + 1).toString();
                    },
                    onDecrement: () {
                      final current =
                          int.tryParse(_quantityController.text) ?? 1;
                      if (current > 1) {
                        _quantityController.text = (current - 1).toString();
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OperatorAutocomplete(
                    selectedOperator: _selectedOperator,
                    onOperatorChanged: (val) =>
                        setState(() => _selectedOperator = val),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomDropdown(
                    label: 'Hata Nedeni',
                    value: _selectedErrorReason,
                    items: FormOptions.errorReasons,
                    icon: Icons.error_outline,
                    onChanged: (val) =>
                        setState(() => _selectedErrorReason = val),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Açıklama (İsteğe Bağlı)',
              controller: _aciklamaController,
              icon: Icons.description_outlined,
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            const FormSectionTitle(
              title: 'Fotoğraf Ekle (İsteğe Bağlı)',
              icon: Icons.photo_camera_outlined,
            ),
            const SizedBox(height: 16),
            PhotoUploadSection(
              selectedImage: _selectedImage,
              onPickImage: _pickImage,
              onRemoveImage: () => setState(() => _selectedImage = null),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _addEntry,
                icon: const Icon(Icons.add_circle_outline, size: 20),
                label: const Text('LİSTEYE EKLE'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.almanyaBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            if (_entries.isNotEmpty) ...[
              const SizedBox(height: 32),
              Row(
                children: [
                  const Icon(
                    Icons.list_alt,
                    color: AppColors.textSecondary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Eklenen Kayıtlar (${_entries.length})',
                    style: const TextStyle(
                      color: AppColors.textMain,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ..._entries.asMap().entries.map((entry) {
                final index = entry.key;
                final fireEntry = entry.value;
                return _buildEntryCard(fireEntry, index);
              }),
            ],
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _entries.isNotEmpty ? _submitAllEntries : null,
                icon: const Icon(Icons.save, size: 20),
                label: Text(
                  _entries.isNotEmpty
                      ? 'TÜMÜNÜ KAYDET (${_entries.length})'
                      : 'KAYIT EKLE',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _entries.isNotEmpty
                      ? AppColors.primary
                      : AppColors.border,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntryCard(FireEntry entry, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${entry.errorReason} - ${entry.quantity} adet',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (entry.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    entry.description!,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
                if (entry.image != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.image,
                        color: AppColors.primary,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Fotoğraf eklendi',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: () => _removeEntry(index),
            icon: const Icon(
              Icons.delete_outline,
              color: AppColors.error,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
