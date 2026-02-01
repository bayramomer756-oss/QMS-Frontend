import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/sidebar_navigation.dart';
import '../../auth/presentation/login_screen.dart';
import '../../chat/presentation/shift_notes_screen.dart';

/// Rework kayıt modeli
class ReworkEntry {
  final String id;
  final String productCode;
  final String batchNo;
  final String errorReason;
  final String result;
  final int quantity;
  final String? description;
  final DateTime timestamp;

  ReworkEntry({
    required this.id,
    required this.productCode,
    required this.batchNo,
    required this.errorReason,
    required this.result,
    required this.quantity,
    this.description,
    required this.timestamp,
  });
}

class ReworkScreen extends StatefulWidget {
  final DateTime? initialDate;
  const ReworkScreen({super.key, this.initialDate});

  @override
  State<ReworkScreen> createState() => _ReworkScreenState();
}

class _ReworkScreenState extends State<ReworkScreen> {
  final String _operatorName = 'Furkan Yılmaz';

  // Kayıtlar listesi
  final List<ReworkEntry> _entries = [];

  // Mevcut giriş için controller'lar
  final _productCodeController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _aciklamaController = TextEditingController();
  final _sarjDayController = TextEditingController();
  final _sarjLineController = TextEditingController();

  // Şarj No bileşenleri
  int _sarjYear = 26;
  String _sarjFoundry = 'F';

  // Dökümhane seçenekleri
  final List<String> _foundryOptions = ['F', 'A'];

  // Şarj No'yu birleştir
  String get _batchNo {
    final dayStr = _sarjDayController.text.padLeft(3, '0');
    final lineStr = _sarjLineController.text.isNotEmpty
        ? _sarjLineController.text.toUpperCase()
        : 'A';
    return '$_sarjYear$_sarjFoundry$dayStr$lineStr';
  }

  // Dropdown değerleri
  String? _selectedErrorReason;
  String? _selectedResult;

  // Dropdown seçenekleri
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

  final List<String> _results = ['Tamir Edildi', 'Hurda', 'İade', 'Beklemede'];

  @override
  void initState() {
    super.initState();
    final now = widget.initialDate ?? DateTime.now();
    _sarjYear = now.year % 100;
    final day = now.difference(DateTime(now.year, 1, 1)).inDays + 1;
    _sarjDayController.text = day.toString().padLeft(3, '0');
    _sarjLineController.text = 'A';
  }

  @override
  void dispose() {
    _productCodeController.dispose();
    _quantityController.dispose();
    _aciklamaController.dispose();
    _sarjDayController.dispose();
    _sarjLineController.dispose();
    super.dispose();
  }

  void _addEntry() {
    if (_productCodeController.text.isEmpty ||
        _selectedErrorReason == null ||
        _selectedResult == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen tüm alanları doldurun'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _entries.insert(
        0,
        ReworkEntry(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          productCode: _productCodeController.text,
          batchNo: _batchNo,
          errorReason: _selectedErrorReason!,
          result: _selectedResult!,
          quantity: int.tryParse(_quantityController.text) ?? 1,
          description: _aciklamaController.text.isNotEmpty
              ? _aciklamaController.text
              : null,
          timestamp: widget.initialDate ?? DateTime.now(),
        ),
      );
      _quantityController.text = '1';
      _selectedErrorReason = null;
      _selectedResult = null;
      _aciklamaController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Kayıt eklendi'),
        backgroundColor: AppColors.duzceGreen,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _removeEntry(String id) {
    setState(() {
      _entries.removeWhere((e) => e.id == id);
    });
  }

  void _saveAll() {
    if (_entries.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kaydedilecek giriş yok'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _entries.clear();
      _productCodeController.clear();
      _quantityController.text = '1';
      _aciklamaController.clear();
      _selectedErrorReason = null;
      _selectedResult = null;

      _sarjYear = 26; // Default to 26
      _sarjDayController.text = '025'; // Default to 025
      _sarjFoundry = 'F';
      _sarjLineController.text = 'A';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Tüm kayıtlar kaydedildi ve sıfırlandı'),
        backgroundColor: AppColors.duzceGreen,
        duration: const Duration(seconds: 2),
      ),
    );
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
                operatorInitial: _operatorName.isNotEmpty
                    ? _operatorName[0]
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
                                  'Rework Kayıt Ekranı',
                                  style: TextStyle(
                                    color: AppColors.textMain,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  'Rework işlem kayıtları',
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
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.only(bottom: 32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Giriş Formu
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppColors.glassBorder,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        'Yeni Rework Kaydı',
                                        style: TextStyle(
                                          color: AppColors.textMain,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 16),

                                      // First Row: Ürün Kodu, Adet
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: _buildInputField(
                                              label: 'Ürün Kodu',
                                              controller:
                                                  _productCodeController,
                                              icon: LucideIcons.box,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: _buildInputField(
                                              label: 'Adet',
                                              controller: _quantityController,
                                              icon: LucideIcons.layers,
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),

                                      // Şarj No - Minimal Picker
                                      _buildSarjNoPicker(),
                                      const SizedBox(height: 12),

                                      // Hata Nedeni, Sonuç
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _buildDropdown(
                                              label: 'Hata Nedeni',
                                              value: _selectedErrorReason,
                                              items: _errorReasons,
                                              icon: LucideIcons.alertCircle,
                                              onChanged: (val) => setState(
                                                () =>
                                                    _selectedErrorReason = val,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: _buildDropdown(
                                              label: 'Sonuç',
                                              value: _selectedResult,
                                              items: _results,
                                              icon: LucideIcons.checkCircle,
                                              onChanged: (val) => setState(
                                                () => _selectedResult = val,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),

                                      // Açıklama
                                      _buildInputField(
                                        label: 'Açıklama',
                                        controller: _aciklamaController,
                                        icon: LucideIcons.fileText,
                                        maxLines: 2,
                                      ),
                                      const SizedBox(height: 16),

                                      // Add Button
                                      ElevatedButton.icon(
                                        onPressed: _addEntry,
                                        icon: const Icon(
                                          LucideIcons.plus,
                                          size: 18,
                                        ),
                                        label: const Text('KAYIT EKLE'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.reworkOrange,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          elevation: 0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // Eklenen Kayıtlar
                                if (_entries.isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: AppColors.glassBorder,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              LucideIcons.clipboardList,
                                              color: AppColors.textSecondary,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Eklenen Kayıtlar (${_entries.length})',
                                              style: TextStyle(
                                                color: AppColors.textMain,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        ...(_entries.map(
                                          (entry) => _buildEntryCard(entry),
                                        )),
                                        const SizedBox(height: 16),
                                        ElevatedButton.icon(
                                          onPressed: _saveAll,
                                          icon: const Icon(
                                            LucideIcons.save,
                                            size: 18,
                                          ),
                                          label: const Text('TÜMÜNÜ KAYDET'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.duzceGreen,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 16,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            elevation: 0,
                                          ),
                                        ),
                                      ],
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
              // Gün (025) - TextField ile Stepper
              _buildStepperField(
                controller: _sarjDayController,
                width: 80, // Increased from 70
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
              // Hat (A) - TextField ile Stepper
              _buildStepperField(
                controller: _sarjLineController,
                width: 60, // Increased from 50
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
                contentPadding: EdgeInsets.zero, // Centers text vertically
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

  Widget _buildEntryCard(ReworkEntry entry) {
    Color resultColor;
    switch (entry.result) {
      case 'Tamir Edildi':
        resultColor = AppColors.duzceGreen;
        break;
      case 'Hurda':
        resultColor = AppColors.error;
        break;
      case 'İade':
        resultColor = AppColors.almanyaBlue;
        break;
      default:
        resultColor = AppColors.reworkOrange;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        entry.productCode,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.textSecondary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Şarj: ${entry.batchNo}',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.reworkOrange.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${entry.quantity} adet',
                        style: TextStyle(
                          color: AppColors.reworkOrange,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      LucideIcons.alertCircle,
                      size: 14,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      entry.errorReason,
                      style: TextStyle(color: AppColors.textMain, fontSize: 13),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      LucideIcons.arrowRight,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: resultColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        entry.result,
                        style: TextStyle(
                          color: resultColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                if (entry.description != null &&
                    entry.description!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    entry.description!,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
          InkWell(
            onTap: () => _removeEntry(entry.id),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(LucideIcons.trash2, size: 18, color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
