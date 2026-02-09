import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class SampleTestFormCard extends StatelessWidget {
  const SampleTestFormCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock sample/test form data
    final sampleData = [
      {
        'product': 'P001 - Fren Diski',
        'testDate': '01.02.2026',
        'result': 'BAŞARILI',
        'tester': 'Furkan Yılmaz',
      },
      {
        'product': 'P002 - Fren Kampanası',
        'testDate': '02.02.2026',
        'result': 'BAŞARILI',
        'tester': 'Ahmet Demir',
      },
      {
        'product': 'P003 - Fren Balatası',
        'testDate': '03.02.2026',
        'result': 'REDDEDİLDİ',
        'tester': 'Mehmet Yılmaz',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Expanded(flex: 2, child: _buildHeaderCell('Ürün')),
                Expanded(child: _buildHeaderCell('Test Tarihi')),
                Expanded(child: _buildHeaderCell('Sonuç')),
                Expanded(flex: 2, child: _buildHeaderCell('Test Eden')),
              ],
            ),
          ),
          // Data rows
          ...sampleData.map((data) {
            final isSuccess = data['result'] == 'BAŞARILI';
            return InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: AppColors.surface,
                    title: Text(
                      'Test Sonuç Detayı',
                      style: const TextStyle(color: AppColors.textMain),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow('Ürün:', data['product'] as String),
                        _buildDetailRow('Tarih:', data['testDate'] as String),
                        _buildDetailRow('Sonuç:', data['result'] as String),
                        _buildDetailRow('Test Eden:', data['tester'] as String),
                        const SizedBox(height: 16),
                        const Text(
                          'Ölçüm Değerleri:',
                          style: TextStyle(
                            color: AppColors.textMain,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Mock detaylar
                        const Text(
                          '- Çap: 250mm (Referans: 250mm)\n- Kalınlık: 24mm (Referans: 24mm)\n- Yüzey: OK',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Kapat'),
                      ),
                    ],
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.border.withValues(alpha: 0.5),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        data['product'] as String,
                        style: const TextStyle(
                          color: AppColors.textMain,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        data['testDate'] as String,
                        style: const TextStyle(color: AppColors.textMain),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        data['result'] as String,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: isSuccess
                              ? AppColors.duzceGreen
                              : AppColors.error,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.only(left: 20),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          data['tester'] as String,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label ',
            style: const TextStyle(
              color: AppColors.textMain,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(value, style: const TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
    );
  }
}
