import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

enum PaymentMethod { card, easypaisa, jazzcash, cash }

class PaymentMethodSelection extends StatelessWidget {
  final PaymentMethod selectedMethod;
  final ValueChanged<PaymentMethod> onMethodSelected;

  const PaymentMethodSelection({
    super.key,
    required this.selectedMethod,
    required this.onMethodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Payment Method",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildMethodItem(
            method: PaymentMethod.card,
            title: "Credit/Debit Card",
            icon: Icons.credit_card,
          ),
          _buildMethodItem(
            method: PaymentMethod.easypaisa,
            title: "EasyPaisa",
            icon: Icons.account_balance_wallet_outlined,
          ),
          _buildMethodItem(
            method: PaymentMethod.jazzcash,
            title: "JazzCash",
            icon: Icons.account_balance_wallet_outlined,
          ),
          _buildMethodItem(
            method: PaymentMethod.cash,
            title: "Cash on Arrival",
            icon: Icons.attach_money,
          ),
        ],
      ),
    );
  }

  Widget _buildMethodItem({
    required PaymentMethod method,
    required String title,
    required IconData icon,
  }) {
    final isSelected = selectedMethod == method;
    return GestureDetector(
      onTap: () => onMethodSelected(method),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryGreen.withValues(alpha: 0.05)
              : const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryGreen
                    : Colors.grey.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primaryGreen,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
