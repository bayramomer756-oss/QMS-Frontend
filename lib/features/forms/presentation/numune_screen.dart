import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/sidebar_navigation.dart';
import '../../auth/presentation/login_screen.dart';
import '../../chat/presentation/shift_notes_screen.dart';

/// Numune/Deneme kayıt modeli
class NumuneEntry {
  final String id;
  final String productCode;
  final String batchNo;
  final String title;
  final String? generalResult;
  final int quantity;
  final List<String> imagePaths;
  final DateTime timestamp;

  NumuneEntry({
    required this.id,
    required this.productCode,
    required this.batchNo,
    required this.title,
    this.generalResult,
    required this.quantity,
    required this.imagePaths,
    required this.timestamp,
  });
}

class NumuneScreen extends StatefulWidget {
  const NumuneScreen({super.key});

  @override
  State<NumuneScreen> createState() => _NumuneScreenState();
}

class _NumuneScreenState extends State<NumuneScreen> {
  final String _operatorName = 'Furkan Yılmaz';
  final ImagePicker _imagePicker = ImagePicker();

  // Kayıtlar listesi
  final List<NumuneEntry> _entries = [];

  // Mevcut giriş için controller'lar
  final _productCodeController = TextEditingController();
  final _productNameController = TextEditingController();
  final _productTypeController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _titleController = TextEditingController();
  final _generalResultController = TextEditingController();

  // Şarj No bileşenleri
  int _sarjYear = 26;
  String _sarjFoundry = 'F';
  final _sarjDayController = TextEditingController();
  final _sarjLineController = TextEditingController(text: 'A');
  final List<String> _foundryOptions = ['F', 'A'];

  // Seçilen görseller
  final List<String> _currentImages = [];

  String get _batchNo {
    final dayStr = _sarjDayController.text.padLeft(3, '0');
    return '$_sarjYear$_sarjFoundry$dayStr${_sarjLineController.text}';
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _sarjYear = now.year % 100;
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays + 1;
    _sarjDayController.text = dayOfYear.toString();
  }

  @override
  void dispose() {
    _productCodeController.dispose();
    _productNameController.dispose();
    _productTypeController.dispose();
    _quantityController.dispose();
    _titleController.dispose();
    _generalResultController.dispose();
    _sarjDayController.dispose();
    _sarjLineController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromCamera() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.camera,
    );
    if (image != null) {
      setState(() => _currentImages.add(image.path));
    }
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      setState(() => _currentImages.add(image.path));
    }
  }

  void _removeImage(int index) {
    setState(() => _currentImages.removeAt(index));
  }

  void _addEntry() {
    if (_productCodeController.text.isEmpty || _titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ürün kodu ve Deneme/Numune Başlığı zorunludur'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _entries.insert(
        0,
        NumuneEntry(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          productCode: _productCodeController.text,
          batchNo: _batchNo,
          title: _titleController.text,
          generalResult: _generalResultController.text.isNotEmpty
              ? _generalResultController.text
              : null,
          quantity: int.tryParse(_quantityController.text) ?? 1,
          imagePaths: List.from(_currentImages),
          timestamp: DateTime.now(),
        ),
      );
      _quantityController.text = '1';
      _titleController.clear();
      _generalResultController.clear();
      _currentImages.clear();
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
    setState(() => _entries.removeWhere((e) => e.id == id));
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
      _titleController.clear();
      _generalResultController.clear();
      _currentImages.clear();

      _sarjYear = 26;
      _sarjDayController.text = '025';
      _sarjFoundry = 'F';
      _sarjLineController.text = 'A';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Tüm kayıtlar kaydedildi'),
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
                                  'Deneme / Numune Formu',
                                  style: TextStyle(
                                    color: AppColors.textMain,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  'Numune ve deneme kayıtları',
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
                                        'Yeni Numune Kaydı',
                                        style: TextStyle(
                                          color: AppColors.textMain,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      // Ürün Kodu, Adet
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
                                            child: _buildQuantityField(
                                              label: 'Adet',
                                              controller: _quantityController,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      // Ürün Adı, Ürün Türü (NEW - Read-only)
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: _buildInputField(
                                              label: 'Ürün Adı',
                                              controller:
                                                  _productNameController,
                                              icon: LucideIcons.tag,
                                              enabled: false,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: _buildInputField(
                                              label: 'Ürün Türü',
                                              controller:
                                                  _productTypeController,
                                              icon: LucideIcons.package,
                                              enabled: false,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      // Şarj No
                                      _buildSarjNoPicker(),
                                      const SizedBox(height: 12),
                                      // Deneme/Numune Başlığı
                                      _buildInputField(
                                        label: 'Deneme / Numune Başlığı',
                                        controller: _titleController,
                                        icon: LucideIcons.tag,
                                      ),
                                      const SizedBox(height: 12),
                                      // Genel Sonuç
                                      _buildInputField(
                                        label: 'Genel Sonuç',
                                        controller: _generalResultController,
                                        icon: LucideIcons.fileText,
                                        maxLines: 3,
                                      ),
                                      const SizedBox(height: 16),
                                      // Görsel Ekleme
                                      _buildImageSection(),
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
                                              AppColors.almanyaBlue,
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

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Görseller',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // Kamera butonu
            InkWell(
              onTap: _pickImageFromCamera,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.camera,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Kamera',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Galeri butonu
            InkWell(
              onTap: _pickImageFromGallery,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.image,
                      color: AppColors.almanyaBlue,
                      size: 20,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Galeri',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Seçilen görseller
            Expanded(
              child: SizedBox(
                height: 60,
                child: _currentImages.isEmpty
                    ? Center(
                        child: Text(
                          'Görsel eklenmedi',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _currentImages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(_currentImages[index]),
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 2,
                                  right: 2,
                                  child: InkWell(
                                    onTap: () => _removeImage(index),
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: AppColors.error,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        LucideIcons.x,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ],
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
              // Gün (025)
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
              // Hat (A)
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

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool enabled = true,
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
            enabled: enabled,
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

  Widget _buildEntryCard(NumuneEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                        color: AppColors.almanyaBlue.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${entry.quantity} adet',
                        style: TextStyle(
                          color: AppColors.almanyaBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  entry.title,
                  style: TextStyle(
                    color: AppColors.textMain,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (entry.generalResult != null &&
                    entry.generalResult!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    entry.generalResult!,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
                if (entry.imagePaths.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: entry.imagePaths.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.file(
                              File(entry.imagePaths[index]),
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
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

  Widget _buildQuantityField({
    required String label,
    required TextEditingController controller,
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
          child: Row(
            children: [
              // Decrease button
              InkWell(
                onTap: () {
                  int current = int.tryParse(controller.text) ?? 1;
                  if (current > 1) {
                    setState(() => controller.text = (current - 1).toString());
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    LucideIcons.minus,
                    color: AppColors.textSecondary,
                    size: 18,
                  ),
                ),
              ),
              // Text field
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textMain,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              // Increase button
              InkWell(
                onTap: () {
                  int current = int.tryParse(controller.text) ?? 1;
                  setState(() => controller.text = (current + 1).toString());
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    LucideIcons.plus,
                    color: AppColors.textSecondary,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
