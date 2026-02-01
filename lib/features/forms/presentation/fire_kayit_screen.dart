import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/sidebar_navigation.dart';
import '../../auth/presentation/login_screen.dart';
import '../../chat/presentation/shift_notes_screen.dart';

class FireKayitScreen extends StatefulWidget {
  final DateTime? initialDate;
  const FireKayitScreen({super.key, this.initialDate});

  @override
  State<FireKayitScreen> createState() => _FireKayitScreenState();
}

class _FireKayitScreenState extends State<FireKayitScreen> {
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
  String _productState = 'İşlenmiş'; // Default
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
    // Eğer geçmiş bir tarih seçildiyse onunla başlat
    final date = widget.initialDate ?? DateTime.now();
    _sarjYear = date.year % 100;

    // Yılın kaçıncı günü olduğunu hesapla
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

  // Image Picker Logic
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  String get _batchNo {
    final dayStr = _sarjDayController.text.padLeft(3, '0');
    final lineStr = _sarjLineController.text.isNotEmpty
        ? _sarjLineController.text.toUpperCase()
        : 'A';
    return '$_sarjYear$_sarjFoundry$dayStr$lineStr';
  }

  void _saveEntry() {
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

    // Success Simulation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Fire kaydı başarıyla oluşturuldu'),
        backgroundColor: AppColors.duzceGreen,
        duration: const Duration(seconds: 2),
      ),
    );

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
      // Keep Operator Name and Şarj No as they might be reused
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
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
              Expanded(
                child: SafeArea(
                  child: Column(
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
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
                                  border: Border.all(
                                    color: AppColors.glassBorder,
                                  ),
                                ),
                                child: const Icon(
                                  LucideIcons.arrowLeft,
                                  color: AppColors.textMain,
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
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
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Image.asset('assets/images/logo.png', height: 32),
                          ],
                        ),
                      ),

                      // Form Content
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
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
                                // Ürün Bilgileri Section
                                _buildSectionTitle('Giriş Bilgileri'),
                                const SizedBox(height: 16),

                                // First Row: Ürün Kodu, Adet
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: _buildInputField(
                                        label: 'Ürün Kodu',
                                        controller: _productCodeController,
                                        icon: LucideIcons.box,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildInputField(
                                        label: 'Adet',
                                        controller: _quantityController,
                                        icon: LucideIcons.layers,
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // Second Row: Ürün Adı, Ürün Türü
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildInputField(
                                        label: 'Ürün Adı',
                                        controller: _productNameController,
                                        icon: LucideIcons.tag,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildInputField(
                                        label: 'Ürün Türü',
                                        controller: _productTypeController,
                                        icon: LucideIcons.layoutGrid,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // Third Row: Tezgah, Bölge
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildDropdown(
                                        label: 'Tezgah S.',
                                        value: _selectedMachine,
                                        items: _machineOptions,
                                        icon: LucideIcons.monitor,
                                        onChanged: (val) => setState(
                                          () => _selectedMachine = val,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildDropdown(
                                        label: 'Bölge S.',
                                        value: _selectedZone,
                                        items: _zoneOptions,
                                        icon: LucideIcons.mapPin,
                                        onChanged: (val) =>
                                            setState(() => _selectedZone = val),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // Product State Radio Group
                                Text(
                                  'Ürün Durumu',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildRadioOption(
                                        val: 'Ham',
                                        groupVal: _productState,
                                        icon: LucideIcons.circle,
                                        onChanged: (val) => setState(
                                          () => _productState = val!,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildRadioOption(
                                        val: 'İşlenmiş',
                                        groupVal: _productState,
                                        icon: LucideIcons.checkCircle,
                                        onChanged: (val) => setState(
                                          () => _productState = val!,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),

                                // Hata Detayları Section
                                _buildSectionTitle('Hata Detayları'),
                                const SizedBox(height: 16),

                                // Şarj No
                                _buildSarjNoPicker(),
                                const SizedBox(height: 12),

                                // Hata Nedeni
                                _buildDropdown(
                                  label: 'Hata Nedeni',
                                  value: _selectedErrorReason,
                                  items: _errorReasons,
                                  icon: LucideIcons.alertCircle,
                                  onChanged: (val) => setState(
                                    () => _selectedErrorReason = val,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Operatör Adı (Moved above Description)
                                _buildInputField(
                                  label: 'Operatör Adı',
                                  controller: _operatorNameController,
                                  icon: LucideIcons.user,
                                ),
                                const SizedBox(height: 12),

                                // Açıklama (Optional)
                                _buildInputField(
                                  label: 'Açıklama (İsteğe Bağlı)',
                                  controller: _aciklamaController,
                                  icon: LucideIcons.fileText,
                                  maxLines: 2,
                                ),
                                const SizedBox(height: 24),

                                // Fotoğraf Ekleme Section
                                _buildSectionTitle(
                                  'Fotoğraf Ekle (İsteğe Bağlı)',
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () =>
                                            _pickImage(ImageSource.camera),
                                        icon: const Icon(
                                          LucideIcons.camera,
                                          size: 18,
                                        ),
                                        label: const Text('KAMERA'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: AppColors.textMain,
                                          side: BorderSide(
                                            color: AppColors.border,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () =>
                                            _pickImage(ImageSource.gallery),
                                        icon: const Icon(
                                          LucideIcons.image,
                                          size: 18,
                                        ),
                                        label: const Text('GALERİ'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: AppColors.textMain,
                                          side: BorderSide(
                                            color: AppColors.border,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (_selectedImage != null) ...[
                                  const SizedBox(height: 16),
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.file(
                                          File(_selectedImage!.path),
                                          height: 200,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: InkWell(
                                          onTap: () => setState(
                                            () => _selectedImage = null,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withValues(
                                                alpha: 0.6,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              LucideIcons.x,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                const SizedBox(height: 32),

                                // Kaydet Butonu
                                ElevatedButton.icon(
                                  onPressed: _saveEntry,
                                  icon: const Icon(LucideIcons.save, size: 20),
                                  label: const Text(
                                    'KAYDET',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.reworkOrange,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 18,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
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

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: AppColors.reworkOrange,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: AppColors.textMain,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceLight.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: TextStyle(color: AppColors.textMain, fontSize: 14),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 18),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Row(
                children: [
                  Icon(icon, color: AppColors.textSecondary, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Seçiniz',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              isExpanded: true,
              dropdownColor: AppColors.surface,
              style: TextStyle(color: AppColors.textMain, fontSize: 14),
              items: items
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Row(
                        children: [
                          Icon(icon, color: AppColors.textSecondary, size: 18),
                          const SizedBox(width: 8),
                          Text(item),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRadioOption({
    required String val,
    required String groupVal,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    bool isSelected = val == groupVal;
    return GestureDetector(
      onTap: () => onChanged(val),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.surfaceLight.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? LucideIcons.checkCircle : LucideIcons.circle,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              val,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSarjNoPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
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
              Icon(LucideIcons.hash, color: AppColors.textSecondary, size: 16),
              const SizedBox(width: 12),
              // Yıl (26)
              _buildStepperBox(
                value: _sarjYear.toString().padLeft(2, '0'),
                onDecrement: () =>
                    setState(() => _sarjYear = (_sarjYear - 1).clamp(0, 99)),
                onIncrement: () =>
                    setState(() => _sarjYear = (_sarjYear + 1).clamp(0, 99)),
              ),
              const SizedBox(width: 4),
              // Dökümhane (F)
              _buildStepperBox(
                value: _sarjFoundry,
                onDecrement: () {
                  final idx = _foundryOptions.indexOf(_sarjFoundry);
                  setState(
                    () => _sarjFoundry =
                        _foundryOptions[(idx - 1 + _foundryOptions.length) %
                            _foundryOptions.length],
                  );
                },
                onIncrement: () {
                  final idx = _foundryOptions.indexOf(_sarjFoundry);
                  setState(
                    () => _sarjFoundry =
                        _foundryOptions[(idx + 1) % _foundryOptions.length],
                  );
                },
              ),
              const SizedBox(width: 4),
              // Gün (025) - WIDE
              _buildStepperField(
                controller: _sarjDayController,
                width: 80,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(3),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onDecrement: () {
                  int current = int.tryParse(_sarjDayController.text) ?? 1;
                  current = (current - 1).clamp(1, 366);
                  _sarjDayController.text = current.toString().padLeft(3, '0');
                  setState(() {});
                },
                onIncrement: () {
                  int current = int.tryParse(_sarjDayController.text) ?? 1;
                  current = (current + 1).clamp(1, 366);
                  _sarjDayController.text = current.toString().padLeft(3, '0');
                  setState(() {});
                },
              ),
              const SizedBox(width: 4),
              // Hat (A) - WIDE
              _buildStepperField(
                controller: _sarjLineController,
                width: 60,
                isText: true,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                ],
                onDecrement: () {
                  String current = _sarjLineController.text.toUpperCase();
                  if (current.isEmpty) current = 'A';
                  int code = current.codeUnitAt(0);
                  if (code > 65) {
                    _sarjLineController.text = String.fromCharCode(code - 1);
                  } else {
                    _sarjLineController.text = 'Z';
                  }
                  setState(() {});
                },
                onIncrement: () {
                  String current = _sarjLineController.text.toUpperCase();
                  if (current.isEmpty) current = 'A';
                  int code = current.codeUnitAt(0);
                  if (code < 90) {
                    _sarjLineController.text = String.fromCharCode(code + 1);
                  } else {
                    _sarjLineController.text = 'A';
                  }
                  setState(() {});
                },
              ),
              const Spacer(),
              // Sonuç gösterimi
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
                  style: TextStyle(
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
              child: Icon(
                LucideIcons.chevronLeft,
                size: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              value,
              style: TextStyle(
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
              child: Icon(
                LucideIcons.chevronRight,
                size: 16,
                color: AppColors.textSecondary,
              ),
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
              LucideIcons.chevronLeft,
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
              style: TextStyle(
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
              LucideIcons.chevronRight,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
