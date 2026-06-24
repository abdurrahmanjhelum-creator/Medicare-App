import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/providers/providers.dart';
import '../../../../../core/widgets/common/header.dart';
import '../../../../../core/widgets/common/back_button.dart';
import '../../../../../core/constants/app_colors.dart';
import '../widgets/medicine_card.dart';

class PharmacyScreen extends ConsumerWidget {
  const PharmacyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pharmacyState = ref.watch(pharmacyProvider);
    final pharmacyNotifier = ref.read(pharmacyProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Column(
        children: [
          DoctorListHeader(
            title: "Pharmacy",
            shortText: "Order medicines online",
            showSearch: false,
            firstColor: AppColors.primaryGreen,
            secondColor: AppColors.secondaryGreen,
            leading: BackToLoginButton(
              onTap: () => Navigator.pop(context),
              text: "Back",
            ),
            trailing: Badge(
              label: Text(pharmacyState.cartCounter.toString()),
              isLabelVisible: pharmacyState.cartCounter > 0,
              backgroundColor: AppColors.error,
              child: const Icon(
                Icons.shopping_cart_outlined,
                color: AppColors.white,
                size: 28,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              itemCount: pharmacyState.medicineList.length,
              itemBuilder: (context, index) {
                final medicine = pharmacyState.medicineList[index];
                return MedicineCard(
                  title: medicine.title,
                  category: medicine.category,
                  price: medicine.price,
                  inStock: medicine.inStock,
                  onAddToCart: () {
                    pharmacyNotifier.addToCart();
                  },
                  onBuyNow: () {
                    // Navigate to checkout logic
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
