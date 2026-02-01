import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/sidebar_navigation.dart';
import '../../../../core/widgets/forms/form_section_title.dart';
import '../../../auth/presentation/login_screen.dart';
import '../../../chat/presentation/shift_notes_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/fire_kayit_providers.dart';

// Section Widgets
import 'widgets/product_info_section.dart';
import 'widgets/machine_zone_selection.dart';
import 'widgets/product_state_radio.dart';
import 'widgets/error_details_section.dart';
import 'widgets/operator_description_section.dart';
import 'widgets/photo_upload_section.dart';
import 'widgets/submit_button.dart';

class FireKayitScreen extends ConsumerStatefulWidget {
  final DateTime? initialDate;
  const FireKayitScreen({super.key, this.initialDate});

  @override
  ConsumerState<FireKayitScreen> createState() => _FireKayitScreenState();
}

class _FireKayitScreenState extends ConsumerState<FireKayitScreen> {
  // Form Controllers
  final _productCodeController = TextEditingController();
  final _productNameController = TextEditingController();
  final _productTypeController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _aciklamaController = TextEditingController();
  final _operatorNameController = TextEditingController();

  // Şarj No Controllers
  final _sarjDayController = TextEditingController();
  final _sarjLineController = TextEditingController();
  int _sarjYear = 26;
  String _sarjFoundry = 'F';

  // State Variables
  String? _selectedMachine;
  String? _selectedZone;
  String _productState = 'İşlenmiş';
  String? _selectedErrorReason;
  XFile? _selectedImage;

  // Options
  final List<String> _foundryOptions = ['F', 'A'];
  final List<String> _machineOptions = [
    'T01',
    'T02',
    'T03',
    'T04',
    'T05',
    'CNC-A',
    'CNC-B',
    'CNC-C',
    'M21',
    'M22',
  ];
  final List<String> _zoneOptions = [
    'Z1 (Giriş)',
    'Z2 (İşleme)',
    'Z3 (Montaj)',
    'Z4 (Paketleme)',
    'Z5 (Depo)',
  ];
  final List<String> _errorReasons = [
    'İç Çap Hatası',
    'Dış Çap Hatası',
    'Profil Hatası',
    'Yüzey Kalitesi',
    'Çapak',
    'Darbe/Çizik',
    'Boyut Hatası',
    'Montaj Uyumsuzluğu',
    'Diğer',
  ];

  @override
  void initState() {
    super.initState();
    final date = widget.initialDate ?? DateTime.now();
    _sarjYear = date.year % 100;

    final dayOfYear =
        int.parse(List.filled(3, '0').join('')) +
        date.difference(DateTime(date.year, 1, 1)).inDays +
        1;
    _sarjDayController.text = dayOfYear.toString().padLeft(3, '0');
    _sarjLineController.text = 'A';
  }

  @override
  void dispose() {
    _productCodeController.dispose();
    _productNameController.dispose();
    _productTypeController.dispose();
    _quantityController.dispose();
    _aciklamaController.dispose();
    _operatorNameController.dispose();
    _sarjDayController.dispose();
    _sarjLineController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() => _selectedImage = image);
    }
  }

  String get _batchNo {
    final dayStr = _sarjDayController.text.padLeft(3, '0');
    final lineStr = _sarjLineController.text.isNotEmpty
        ? _sarjLineController.text.toUpperCase()
        : 'A';
    return '$_sarjYear$_sarjFoundry$dayStr$lineStr';
  }

  Future<void> _saveEntry() async {
    // Validation
    if (_productCodeController.text.isEmpty ||
        _productNameController.text.isEmpty ||
        _productTypeController.text.isEmpty ||
        _selectedMachine == null ||
        _selectedZone == null ||
        _operatorNameController.text.isEmpty ||
        _selectedErrorReason == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen gerekli alanları doldurun'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      // Show Loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const Center(child: CircularProgressIndicator()),
      );

      // Map UI values to IDs
      final tezgahId = _machineOptions.indexOf(_selectedMachine!) + 1;
      final bolgeId = _zoneOptions.indexOf(_selectedZone!) + 1;
      final retKoduId = _errorReasons.indexOf(_selectedErrorReason!) + 1;

      // Prepare DTO Map
      final data = {
        'vardiyaId': 1,
        'urunKodu': _productCodeController.text,
        'sarjNo': _batchNo,
        'tezgahId': tezgahId,
        'operasyonId': 1,
        'bolgeId': bolgeId,
        'retKoduId': retKoduId,
        'operatorAdi': _operatorNameController.text,
        'aciklama': _aciklamaController.text,
      };

      // Create Form
      final id = await ref.read(createFireKayitFormUseCaseProvider).call(data);

      // Upload Photo (if exists)
      if (_selectedImage != null) {
        await ref
            .read(fireKayitRepositoryProvider)
            .uploadPhoto(id, File(_selectedImage!.path));
      }

      // Hide Loading
      if (mounted) Navigator.of(context).pop();

      // Success Message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Fire kaydı başarıyla oluşturuldu'),
            backgroundColor: AppColors.duzceGreen,
            duration: const Duration(seconds: 2),
          ),
        );
      }

      // Reset Form
      setState(() {
        _productCodeController.clear();
        _productNameController.clear();
        _productTypeController.clear();
        _selectedMachine = null;
        _selectedZone = null;
        _quantityController.text = '1';
        _selectedErrorReason = null;
        _aciklamaController.clear();
        _selectedImage = null;
      });
    } catch (e) {
      // Hide Loading
      if (mounted) Navigator.of(context).pop();

      // Error Message
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background with blur
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/frenbu_bg.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(color: Colors.black.withValues(alpha: 0.6)),
              ),
            ),
          ),
          Row(
            children: [
              // Sidebar
              SidebarNavigation(
                selectedIndex: 1,
                onItemSelected: (index) {
                  if (index == 0) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  } else if (index == 3) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ShiftNotesScreen(),
                      ),
                    );
                  } else if (index == 1) {
                    Navigator.of(context).pop();
                  }
                },
                operatorInitial: _operatorNameController.text.isNotEmpty
                    ? _operatorNameController.text[0].toUpperCase()
                    : 'O',
                onLogout: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                ),
              ),
              // Main Content
              Expanded(
                child: SafeArea(
                  child: Column(
                    children: [
                      // Header
                      _buildHeader(),
                      // Form Content
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          child: _buildFormCard(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: const Icon(
                LucideIcons.arrowLeft,
                color: AppColors.textMain,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fire Kayıt Ekranı',
                style: TextStyle(
                  color: AppColors.textMain,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Fire işlem kaydı oluşturma',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
            ],
          ),
          const Spacer(),
          Image.asset('assets/images/logo.png', height: 32),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Product Info Section
          const FormSectionTitle(
            title: 'Giriş Bilgileri',
            icon: LucideIcons.package,
          ),
          const SizedBox(height: 16),
          ProductInfoSection(
            productCodeController: _productCodeController,
            productNameController: _productNameController,
            productTypeController: _productTypeController,
            quantityController: _quantityController,
            onQuantityDecrement: () {
              int val = int.tryParse(_quantityController.text) ?? 1;
              _quantityController.text = (val - 1).clamp(1, 9999).toString();
            },
            onQuantityIncrement: () {
              int val = int.tryParse(_quantityController.text) ?? 1;
              _quantityController.text = (val + 1).clamp(1, 9999).toString();
            },
          ),
          const SizedBox(height: 16),

          // Machine & Zone Selection
          MachineZoneSelection(
            selectedMachine: _selectedMachine,
            selectedZone: _selectedZone,
            machineOptions: _machineOptions,
            zoneOptions: _zoneOptions,
            onMachineChanged: (val) => setState(() => _selectedMachine = val),
            onZoneChanged: (val) => setState(() => _selectedZone = val),
          ),
          const SizedBox(height: 16),

          // Product State Radio
          ProductStateRadio(
            productState: _productState,
            onChanged: (val) => setState(() => _productState = val!),
          ),
          const SizedBox(height: 24),

          // Error Details Section
          const FormSectionTitle(
            title: 'Hata Detayları',
            icon: LucideIcons.alertTriangle,
          ),
          const SizedBox(height: 16),
          ErrorDetailsSection(
            sarjDayController: _sarjDayController,
            sarjLineController: _sarjLineController,
            sarjYear: _sarjYear,
            sarjFoundry: _sarjFoundry,
            foundryOptions: _foundryOptions,
            selectedErrorReason: _selectedErrorReason,
            errorReasons: _errorReasons,
            onYearChanged: (val) => setState(() => _sarjYear = val),
            onFoundryChanged: (val) => setState(() => _sarjFoundry = val),
            onErrorReasonChanged: (val) =>
                setState(() => _selectedErrorReason = val),
          ),
          const SizedBox(height: 16),

          // Operator & Description
          OperatorDescriptionSection(
            operatorNameController: _operatorNameController,
            aciklamaController: _aciklamaController,
          ),
          const SizedBox(height: 24),

          // Photo Upload Section
          const FormSectionTitle(
            title: 'Fotoğraf Ekle (İsteğe Bağlı)',
            icon: LucideIcons.camera,
          ),
          const SizedBox(height: 16),
          PhotoUploadSection(
            selectedImage: _selectedImage,
            onPickImage: _pickImage,
            onRemoveImage: () => setState(() => _selectedImage = null),
          ),
          const SizedBox(height: 32),

          // Submit Button
          SubmitButton(onPressed: _saveEntry),
        ],
      ),
    );
  }
}
