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
            shortText: "Order medicines online with ease",
            showSearch: true,
            hintText: "Search Medicines...",
            onSearchChanged: (value) => pharmacyNotifier.searchMedicines(value),
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
            child: RefreshIndicator(
              onRefresh: () => pharmacyNotifier.fetchMedicines(),
              child: pharmacyState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : pharmacyState.error != null && pharmacyState.medicineList.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                                const SizedBox(height: 12),
                                Text(
                                  pharmacyState.error!.replaceAll('Exception: ', ''),
                                  style: TextStyle(color: Colors.grey[600]),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () => pharmacyNotifier.fetchMedicines(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryGreen,
                                  ),
                                  child: const Text("Retry"),
                                ),
                              ],
                            ),
                          ),
                        )
                      : pharmacyState.medicineList.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.medication_outlined, size: 64, color: Colors.grey.shade300),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'No medicines found',
                                    style: TextStyle(color: Colors.grey, fontSize: 16),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
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
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("${medicine.title} added to cart"),
                                        duration: const Duration(seconds: 1),
                                        backgroundColor: AppColors.primaryGreen,
                                      ),
                                    );
                                  },
                                  onBuyNow: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Checkout feature is being integrated'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
            ),
          ),
        ],
      ),
    );
  }
}
