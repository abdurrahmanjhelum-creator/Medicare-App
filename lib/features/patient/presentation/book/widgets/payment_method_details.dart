import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import 'payment_method_selection.dart';

class PaymentMethodDetails extends StatelessWidget {
  final PaymentMethod selectedMethod;

  const PaymentMethodDetails({super.key, required this.selectedMethod});

  @override
  Widget build(BuildContext context) {
    if (selectedMethod == PaymentMethod.cash) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
          Text(
            _getTitle(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          if (selectedMethod == PaymentMethod.card) _buildCardFields(),
          if (selectedMethod == PaymentMethod.easypaisa ||
              selectedMethod == PaymentMethod.jazzcash)
            _buildMobileWalletFields(),
        ],
      ),
    );
  }

  String _getTitle() {
    switch (selectedMethod) {
      case PaymentMethod.card:
        return "Card Details";
      case PaymentMethod.easypaisa:
        return "EasyPaisa Details";
      case PaymentMethod.jazzcash:
        return "JazzCash Details";
      default:
        return "";
    }
  }

  Widget _buildCardFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputField(label: "Card Number", hint: "1234 5678 9012 3456"),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildInputField(label: "Expiry Date", hint: "MM/YY"),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInputField(label: "CVV", hint: "123"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileWalletFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputField(label: "Phone Number", hint: "03xx xxxxxxx"),
        const SizedBox(height: 8),
        const Text(
          "Enter the phone number associated with your account.",
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildInputField({required String label, required String hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primaryGreen,
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
