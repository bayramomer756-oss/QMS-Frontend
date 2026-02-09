import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/sidebar_navigation.dart';
import '../../../core/widgets/dialogs/hurda_selection_dialog.dart';
import '../../../core/widgets/forms/product_info_card.dart';
import '../../../core/widgets/forms/modern_quick_button.dart';
import '../../auth/presentation/login_screen.dart';
import '../../chat/presentation/shift_notes_screen.dart';
import '../logic/cubits/production_counter_cubit.dart';
import '../logic/cubits/production_counter_state.dart';

class FinalKontrolScreen extends StatefulWidget {
  final DateTime? initialDate;
  const FinalKontrolScreen({super.key, this.initialDate});

  @override
  State<FinalKontrolScreen> createState() => _FinalKontrolScreenState();
}

class _FinalKontrolScreenState extends State<FinalKontrolScreen> {
  // Form Controllers (state artık Cubit'te)
  final _amountController = TextEditingController(text: '1');
  final _productCodeController = TextEditingController();
  final _customerNameController = TextEditingController();
  final _paletNoController = TextEditingController();
  final _aciklamaController = TextEditingController();

  // Ürün Bilgileri (sistemden otomatik gelecek)
  String _productName = '';
  String _productType = '';
  final String _operatorName = 'Furkan Yılmaz';

  @override
  void dispose() {
    _amountController.dispose();
    _productCodeController.dispose();
    _customerNameController.dispose();
    _paletNoController.dispose();
    _aciklamaController.dispose();
    super.dispose();
  }

  void _onProductCodeChanged(String code) {
    // Simüle edilmiş sistem yanıtı - gerçek uygulamada API çağrısı yapılır
    if (code.isNotEmpty) {
      setState(() {
        _productName = 'Ürün-$code';
        _productType = 'Disk';
      });
      context.read<ProductionCounterCubit>().setProductInfo(
        _productName,
        _productType,
      );
    } else {
      setState(() {
        _productName = '';
        _productType = '';
      });
      context.read<ProductionCounterCubit>().setProductInfo('', '');
    }
  }

  void _updateAmount(int change) {
    int current = int.tryParse(_amountController.text) ?? 1;
    int newValue = current + change;
    if (newValue < 1) newValue = 1;
    _amountController.text = newValue.toString();
  }

  int get _currentAmount => int.tryParse(_amountController.text) ?? 1;

  void _resetAmount() {
    setState(() {
      _amountController.text = '1';
    });
  }

  void _addToPaketlenen([BuildContext? ctx]) {
    final cubitContext = ctx ?? context;
    print('DEBUG: _addToPaketlenen called with amount: $_currentAmount');
    cubitContext.read<ProductionCounterCubit>().incrementPaketlenen(
      _currentAmount,
    );
    _resetAmount();
  }

  void _addToRework([BuildContext? ctx]) {
    final cubitContext = ctx ?? context;
    cubitContext.read<ProductionCounterCubit>().incrementRework(_currentAmount);
    _resetAmount();
  }

  void _showHurdaPopup([BuildContext? ctx]) {
    final cubitContext = ctx ?? context;
    showDialog(
      context: cubitContext,
      builder: (context) => HurdaSelectionDialog(
        onReasonSelected: (reason) {
          cubitContext.read<ProductionCounterCubit>().incrementHurda(
            _currentAmount,
            reason,
          );
          _resetAmount();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductionCounterCubit(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            // Arka Plan Görseli
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/frenbu_bg.jpg',
                    ), // Updated BG
                    fit: BoxFit.cover,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(color: Colors.black.withValues(alpha: 0.6)),
                ),
              ),
            ),
            // Ön Plan İçerik
            Row(
              children: [
                // Sidebar
                SidebarNavigation(
                  selectedIndex: 1, // Formlar altındayız
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
                // Ana İçerik
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
                                    'Final Kontrol',
                                    style: TextStyle(
                                      color: AppColors.textMain,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    'Son Kontrol Aşaması',
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
                                // Main Column inside Scroll
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
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
                                        // Product Info Card (full width with dropdown)
                                        ProductInfoCard(
                                          productCodeController:
                                              _productCodeController,
                                          productName: _productName.isEmpty
                                              ? null
                                              : _productName,
                                          productType: _productType.isEmpty
                                              ? null
                                              : _productType,
                                          onProductCodeChanged:
                                              _onProductCodeChanged,
                                          onProductSelected: (product) {
                                            setState(() {
                                              _productName = product.urunAdi;
                                              _productType = product.urunTuru;
                                            });
                                            context
                                                .read<ProductionCounterCubit>()
                                                .setProductInfo(
                                                  product.urunAdi,
                                                  product.urunTuru,
                                                );
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        // Customer Name + Palet İzlenebilirlik (side by side)
                                        Row(
                                          children: [
                                            Expanded(
                                              child: _buildInputField(
                                                label: 'Müşteri Adı',
                                                controller:
                                                    _customerNameController,
                                                icon: LucideIcons.user,
                                                keyboardType:
                                                    TextInputType.text,
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: _buildInputField(
                                                label:
                                                    'Palet İzlenebilirlik No',
                                                controller: _paletNoController,
                                                icon: LucideIcons.tag,
                                                keyboardType:
                                                    TextInputType.text,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 24),
                                        Divider(color: AppColors.border),
                                        const SizedBox(height: 24),

                                        // Input & Counters
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Left: Current Totals
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Mevcut Üretim',
                                                    style: TextStyle(
                                                      color: AppColors
                                                          .textSecondary,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  // First row: TOPLAM, PAKETLENEN (2 equal boxes)
                                                  BlocBuilder<
                                                    ProductionCounterCubit,
                                                    ProductionCounterState
                                                  >(
                                                    builder: (context, state) {
                                                      return Row(
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                _buildCounterDisplay(
                                                                  'TOPLAM',
                                                                  state.total,
                                                                  AppColors
                                                                      .primary,
                                                                ),
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Expanded(
                                                            child: _buildCounterDisplay(
                                                              'PAKETLENEN',
                                                              state.paketlenen,
                                                              AppColors
                                                                  .almanyaBlue,
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                  const SizedBox(height: 8),
                                                  // Second row: HURDA, REWORK (2 equal boxes)
                                                  BlocBuilder<
                                                    ProductionCounterCubit,
                                                    ProductionCounterState
                                                  >(
                                                    builder: (context, state) {
                                                      return Row(
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                _buildCounterDisplay(
                                                                  'HURDA',
                                                                  state.hurda,
                                                                  AppColors
                                                                      .error,
                                                                ),
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Expanded(
                                                            child: _buildCounterDisplay(
                                                              'REWORK',
                                                              state.rework,
                                                              AppColors
                                                                  .reworkOrange,
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 24),
                                            // Right: Input
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Giriş Miktarı',
                                                    style: TextStyle(
                                                      color: AppColors
                                                          .textSecondary,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    children: [
                                                      _buildAmountButton(
                                                        LucideIcons.minus,
                                                        () => _updateAmount(-1),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: TextFormField(
                                                          controller:
                                                              _amountController,
                                                          style: TextStyle(
                                                            color: AppColors
                                                                .textMain,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          decoration: InputDecoration(
                                                            filled: true,
                                                            fillColor: AppColors
                                                                .surfaceLight,
                                                            contentPadding:
                                                                const EdgeInsets.symmetric(
                                                                  vertical: 12,
                                                                ),
                                                            border: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    10,
                                                                  ),
                                                              borderSide:
                                                                  BorderSide(
                                                                    color: AppColors
                                                                        .border,
                                                                  ),
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    10,
                                                                  ),
                                                              borderSide:
                                                                  BorderSide(
                                                                    color: AppColors
                                                                        .border,
                                                                  ),
                                                            ),
                                                            focusedBorder: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    10,
                                                                  ),
                                                              borderSide: BorderSide(
                                                                color: AppColors
                                                                    .primary,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      _buildAmountButton(
                                                        LucideIcons.plus,
                                                        () => _updateAmount(1),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  // Quick Add/Subtract with modern buttons
                                                  Row(
                                                    children: [
                                                      ModernQuickButton(
                                                        label: '+5',
                                                        onPressed: () =>
                                                            _updateAmount(5),
                                                        color: AppColors
                                                            .duzceGreen,
                                                        icon: LucideIcons.plus,
                                                      ),
                                                      const SizedBox(width: 8),
                                                      ModernQuickButton(
                                                        label: '+10',
                                                        onPressed: () =>
                                                            _updateAmount(10),
                                                        color: AppColors
                                                            .duzceGreen,
                                                        icon: LucideIcons
                                                            .chevronsUp,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    children: [
                                                      ModernQuickButton(
                                                        label: '-5',
                                                        onPressed: () =>
                                                            _updateAmount(-5),
                                                        color: AppColors.error,
                                                        icon: LucideIcons.minus,
                                                      ),
                                                      const SizedBox(width: 8),
                                                      ModernQuickButton(
                                                        label: '-10',
                                                        onPressed: () =>
                                                            _updateAmount(-10),
                                                        color: AppColors.error,
                                                        icon: LucideIcons
                                                            .chevronsDown,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 32),
                                        Text(
                                          'İşlem Tamamla',
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 12),

                                        // Action Buttons - Wrapped in Builder for correct context
                                        Builder(
                                          builder: (btnContext) {
                                            return Row(
                                              children: [
                                                Expanded(
                                                  child: _buildActionButton(
                                                    'PAKETLENEN EKLE',
                                                    AppColors.almanyaBlue,
                                                    LucideIcons.package,
                                                    () => _addToPaketlenen(
                                                      btnContext,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: _buildActionButton(
                                                    'REWORK EKLE',
                                                    AppColors.reworkOrange,
                                                    LucideIcons.wrench,
                                                    () => _addToRework(
                                                      btnContext,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: _buildActionButton(
                                                    'HURDA EKLE',
                                                    AppColors.error,
                                                    LucideIcons.trash2,
                                                    () => _showHurdaPopup(
                                                      btnContext,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        // Açıklama
                                        _buildInputField(
                                          label: 'Açıklama',
                                          controller: _aciklamaController,
                                          icon: LucideIcons.messageSquare,
                                          keyboardType: TextInputType.text,
                                        ),
                                        const SizedBox(height: 24),
                                        // Summary Section - Eklenen Adetler
                                        BlocBuilder<
                                          ProductionCounterCubit,
                                          ProductionCounterState
                                        >(
                                          builder: (context, state) {
                                            if (state.paketlenen > 0 ||
                                                state.rework > 0 ||
                                                state.hurda > 0) {
                                              return Container(
                                                padding: const EdgeInsets.all(
                                                  16,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.surfaceLight
                                                      .withValues(alpha: 0.5),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: AppColors.border,
                                                  ),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          LucideIcons
                                                              .clipboardList,
                                                          color: AppColors
                                                              .textSecondary,
                                                          size: 18,
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Text(
                                                          'Eklenen Adetler',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 12),
                                                    Wrap(
                                                      spacing: 8,
                                                      runSpacing: 8,
                                                      children: [
                                                        if (state.paketlenen >
                                                            0)
                                                          _buildSummaryChip(
                                                            '${state.paketlenen} Paketlenen',
                                                            AppColors
                                                                .almanyaBlue,
                                                          ),
                                                        if (state.rework > 0)
                                                          _buildSummaryChip(
                                                            '${state.rework} Rework',
                                                            AppColors
                                                                .reworkOrange,
                                                          ),
                                                        if (state.hurda > 0)
                                                          ..._buildHurdaSummary(
                                                            state,
                                                          ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                            return const SizedBox.shrink();
                                          },
                                        ),
                                        const SizedBox(height: 24),
                                        // Conditional spacing removed - handled by BlocBuilder
                                        // Save Button - Wrapped for correct context
                                        Builder(
                                          builder: (btnContext) {
                                            return SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton.icon(
                                                onPressed: () {
                                                  // Reset all fields
                                                  btnContext
                                                      .read<
                                                        ProductionCounterCubit
                                                      >()
                                                      .clearAll();
                                                  setState(() {
                                                    _amountController.text =
                                                        '1';
                                                    _productCodeController
                                                        .clear();
                                                    _customerNameController
                                                        .clear();
                                                    _paletNoController.clear();
                                                    _aciklamaController.clear();
                                                    _productName = '';
                                                    _productType = '';
                                                  });
                                                  ScaffoldMessenger.of(
                                                    btnContext,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: const Text(
                                                        'Veriler kaydedildi ve sıfırlandı',
                                                      ),
                                                      backgroundColor:
                                                          AppColors.duzceGreen,
                                                      duration: const Duration(
                                                        seconds: 2,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(
                                                  LucideIcons.save,
                                                  size: 18,
                                                ),
                                                label: const Text('KAYDET'),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      AppColors.duzceGreen,
                                                  foregroundColor: Colors.white,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 16,
                                                      ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                  elevation: 0,
                                                ),
                                              ),
                                            );
                                          },
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
      ),
    );
  }

  // --- Helpers ---

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    Function(String)? onChanged,
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
            onChanged: onChanged,
            style: TextStyle(
              color: AppColors.textMain,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              border: InputBorder.none,
              prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 18),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, color: AppColors.textMain, size: 20),
      ),
    );
  }

  Widget _buildCounterDisplay(String label, int value, Color color) {
    // TOPLAM gets white background, others use their color
    final bgColor = label == 'TOPLAM'
        ? Colors.white.withValues(alpha: 0.1)
        : color.withValues(alpha: 0.1);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$value',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    Color color,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
    );
  }

  Widget _buildSummaryChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  List<Widget> _buildHurdaSummary(ProductionCounterState state) {
    // Log girdilerinden hurda hatalarını grupla
    final hurdaLogs = state.logs.where((e) => e.actionType == 'hurda').toList();

    if (hurdaLogs.isEmpty) {
      return [_buildSummaryChip('${state.hurda} Hurda', AppColors.error)];
    }

    // Hata nedenlerine göre grupla
    final Map<String, int> errorCounts = {};
    for (final log in hurdaLogs) {
      final reason = log.scrapReason ?? 'Bilinmeyen';
      errorCounts[reason] = (errorCounts[reason] ?? 0) + log.quantity;
    }

    final List<Widget> chips = [];
    errorCounts.forEach((reason, count) {
      chips.add(_buildSummaryChip('$count adet $reason', AppColors.error));
    });

    return chips;
  }
}
