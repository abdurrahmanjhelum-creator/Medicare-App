// Manage Time Slots Screen - Doctor apne available time slots set karega
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/services/api_service.dart';

class ManageSlotsScreen extends ConsumerStatefulWidget {
  const ManageSlotsScreen({super.key});

  @override
  ConsumerState<ManageSlotsScreen> createState() => _ManageSlotsScreenState();
}

class _ManageSlotsScreenState extends ConsumerState<ManageSlotsScreen> {
  List<String> _currentSlots = [];
  bool _isLoading = true;
  bool _isSaving = false;

  // Pre-defined time slot suggestions (09:00 AM to 09:30 PM)
  static const List<String> _suggestedSlots = [
    '09:00 AM', '09:30 AM',
    '10:00 AM', '10:30 AM',
    '11:00 AM', '11:30 AM',
    '12:00 PM', '12:30 PM',
    '01:00 PM', '01:30 PM',
    '02:00 PM', '02:30 PM',
    '03:00 PM', '03:30 PM',
    '04:00 PM', '04:30 PM',
    '05:00 PM', '05:30 PM',
    '06:00 PM', '06:30 PM',
    '07:00 PM', '07:30 PM',
    '08:00 PM', '08:30 PM',
    '09:00 PM', '09:30 PM',
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentSlots();
  }

  Future<void> _loadCurrentSlots() async {
    try {
      final resp = await ApiService.get(
        endpoint: '/doctor-dashboard/profile',
        auth: true,
      );
      final profileData = ApiService.unwrapMap(resp);
      final doctor = profileData['doctor'] as Map<String, dynamic>?;
      final slots = doctor?['availableSlots'];
      setState(() {
        _currentSlots = slots != null ? List<String>.from(slots) : [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Load error: $e')),
        );
      }
    }
  }

  void _toggleSlot(String slot) {
    setState(() {
      if (_currentSlots.contains(slot)) {
        _currentSlots.remove(slot);
      } else {
        _currentSlots.add(slot);
        _currentSlots.sort(); // Keep sorted
      }
    });
  }

  Future<void> _saveSlots() async {
    setState(() => _isSaving = true);
    try {
      await ApiService.put(
        endpoint: '/doctor-dashboard/schedule',
        body: {'availableSlots': _currentSlots},
        auth: true,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Time slots save ho gaye!'),
            backgroundColor: AppColors.primaryGreen,
          ),
        );
        Navigator.pop(context, true); // Signal parent to refresh
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Save fail: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        title: const Text(
          'Manage Time Slots',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveSlots,
            child: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.screenPaddingHorizontal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info card
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.spacing16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withAlpha(20),
                      borderRadius: BorderRadius.circular(AppDimensions.borderRadius12),
                      border: Border.all(color: AppColors.primaryGreen.withAlpha(60)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: AppColors.primaryGreen),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Jo time slots aap select karenge, wo patients ko booking screen par dikhenge.',
                            style: TextStyle(
                              color: AppColors.primaryGreen.withAlpha(200),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacing16),

                  // Selected count
                  Text(
                    '${_currentSlots.length} slots selected',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacing16),

                  // Slots grid
                  const Text(
                    'Available Time Slots',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacing12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _suggestedSlots.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2.0,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      final slot = _suggestedSlots[index];
                      final isSelected = _currentSlots.contains(slot);
                      return GestureDetector(
                        onTap: () => _toggleSlot(slot),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryGreen
                                : AppColors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryGreen
                                  : AppColors.border,
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.primaryGreen.withAlpha(80),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                : [],
                          ),
                          child: Text(
                            slot,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: AppDimensions.spacing24),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveSlots,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        padding: const EdgeInsets.symmetric(
                            vertical: AppDimensions.spacing16),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppDimensions.borderRadius12),
                        ),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                            )
                          : const Text(
                              'Save Time Slots',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacing24),
                ],
              ),
            ),
    );
  }
}
