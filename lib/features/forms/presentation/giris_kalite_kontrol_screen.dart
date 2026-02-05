import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/sidebar_navigation.dart';
import '../../auth/presentation/login_screen.dart';
import '../../chat/presentation/shift_notes_screen.dart';

class GirisKaliteKontrolScreen extends StatefulWidget {
  final DateTime? initialDate;
  const GirisKaliteKontrolScreen({super.key, this.initialDate});

  @override
  State<GirisKaliteKontrolScreen> createState() =>
      _GirisKaliteKontrolScreenState();
}

class _GirisKaliteKontrolScreenState extends State<GirisKaliteKontrolScreen> {
  // Form Controllers
  final _supplierController = TextEditingController();
  final _invoiceNoController = TextEditingController();
  final _productCodeController = TextEditingController();
  final _productNameController = TextEditingController();
  final _productTypeController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _aciklamaController = TextEditingController();

  // Şarj No Controllers
  final _sarjDayController = TextEditingController();
  final _sarjLineController = TextEditingController();
  int _sarjYear = 26;
  String _sarjFoundry = 'F';

  // State
  String? _selectedStatus; // Kabul, Red, Şartlı Kabul
  final List<String> _statusOptions = ['Kabul', 'Red', 'Şartlı Kabul'];

  final List<String> _foundryOptions = ['F', 'A'];

  @override
  void initState() {
    super.initState();
    final date = widget.initialDate ?? DateTime.now();
    _sarjYear = date.year % 100;

    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays + 1;
    _sarjDayController.text = dayOfYear.toString().padLeft(3, '0');

    _sarjLineController.text = 'A';
  }

  @override
  void dispose() {
    _supplierController.dispose();
    _invoiceNoController.dispose();
    _productCodeController.dispose();
    _productNameController.dispose();
    _productTypeController.dispose();
    _quantityController.dispose();
    _aciklamaController.dispose();
    _sarjDayController.dispose();
    _sarjLineController.dispose();
    super.dispose();
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
    if (_supplierController.text.isEmpty ||
        _productCodeController.text.isEmpty ||
        _productNameController.text.isEmpty ||
        _selectedStatus == null) {
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
        content: const Text('Giriş Kalite Kontrol kaydı oluşturuldu'),
        backgroundColor: AppColors.duzceGreen,
        duration: const Duration(seconds: 2),
      ),
    );

    // Reset Form
    setState(() {
      _supplierController.clear();
      _invoiceNoController.clear();
      _productCodeController.clear();
      _productNameController.clear();
      _productTypeController.clear();
      _quantityController.text = '1';
      _aciklamaController.clear();
      _selectedStatus = null;
      // Keep Operator and date/batch info
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
                operatorInitial: 'O',
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
                                  'Giriş Kalite Kontrol',
                                  style: TextStyle(
                                    color: AppColors.textMain,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  'Malzeme/Hammadde giriş kontrolleri',
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
                                _buildSectionTitle('Giriş Bilgileri'),
                                const SizedBox(height: 16),

                                // Tedarikçi, İrsaliye
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildInputField(
                                        label: 'Tedarikçi Firma',
                                        controller: _supplierController,
                                        icon: LucideIcons.truck,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildInputField(
                                        label: 'İrsaliye / Fatura No',
                                        controller: _invoiceNoController,
                                        icon: LucideIcons.fileText,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // Ürün Kodu, Adet
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: _buildInputField(
                                        label: 'Ürün Kodu',
                                        controller: _productCodeController,
                                        icon: LucideIcons.box,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildInputField(
                                        label: 'Gelen Miktar',
                                        controller: _quantityController,
                                        icon: LucideIcons.layers,
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // Ürün Adı, Türü
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildInputField(
                                        label: 'Ürün Adı',
                                        controller: _productNameController,
                                        icon: LucideIcons.tag,
                                        enabled: false,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildInputField(
                                        label: 'Ürün Türü',
                                        controller: _productTypeController,
                                        icon: LucideIcons.layoutGrid,
                                        enabled: false,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),

                                _buildSectionTitle('Kontrol Detayları'),
                                const SizedBox(height: 16),

                                // Şarj No
                                _buildSarjNoPicker(),
                                const SizedBox(height: 12),

                                // Kontrol Sonucu (Status)
                                Text(
                                  'Kontrol Sonucu',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: _statusOptions.map((status) {
                                    return Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 8.0,
                                        ),
                                        child: _buildRadioOption(
                                          val: status,
                                          groupVal: _selectedStatus,
                                          onChanged: (val) => setState(
                                            () => _selectedStatus = val,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 12),

                                // Açıklama
                                _buildInputField(
                                  label: 'Açıklama / Notlar',
                                  controller: _aciklamaController,
                                  icon: LucideIcons.fileText,
                                  maxLines: 2,
                                ),
                                const SizedBox(height: 32),

                                // Save Button
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
                                    backgroundColor: AppColors.duzceGreen,
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
            color: AppColors.duzceGreen,
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

  Widget _buildRadioOption({
    required String val,
    required String? groupVal,
    required Function(String?) onChanged,
  }) {
    bool isSelected = val == groupVal;

    // Custom color logic based on status
    Color activeColor = AppColors.primary;
    if (val == 'Kabul') activeColor = AppColors.duzceGreen;
    if (val == 'Red') activeColor = AppColors.error;
    if (val == 'Şartlı Kabul') activeColor = AppColors.reworkOrange;

    return GestureDetector(
      onTap: () => onChanged(val),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withValues(alpha: 0.1)
              : AppColors.surfaceLight.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? activeColor : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? LucideIcons.checkCircle : LucideIcons.circle,
              color: isSelected ? activeColor : AppColors.textSecondary,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              val,
              style: TextStyle(
                color: isSelected ? activeColor : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
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
              // Gün (025)
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
              // Hat (A)
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
