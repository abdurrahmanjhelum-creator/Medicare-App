import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/providers/providers.dart';
import '../../../../../core/widgets/common/success_dialog.dart';
import '../../../models/doctor_model.dart';
import '../widgets/header.dart';
import '../widgets/bottom_confirm_button.dart';
import '../widgets/doctor_info_card.dart';
import '../widgets/fee_breakdown_card.dart';
import '../widgets/payment_method_selection.dart';
import '../widgets/payment_method_details.dart';
import 'recipt_screen.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final DoctorModel doctor;
  final String selectedTime;
  final DateTime selectedDate;
  final String notes;

  const PaymentScreen({
    super.key,
    required this.doctor,
    required this.selectedTime,
    required this.selectedDate,
    required this.notes,
  });

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  PaymentMethod _selectedMethod = PaymentMethod.card;
  bool _isProcessing = false;

  void _handlePayment() async {
    setState(() {
      _isProcessing = true;
    });

    // Prepare booking data for backend
    final bookingData = {
      'doctorId': widget.doctor.userId,
      'date': widget.selectedDate.toIso8601String().split('T')[0], // Use selected date
      'time': widget.selectedTime,
      'type': 'consultation',
      'patientNotes': widget.notes,
    };

    // Call backend API to book appointment
    final success = await ref.read(appointmentProvider.notifier).bookAppointment(bookingData);

    setState(() {
      _isProcessing = false;
    });

    if (success) {
      SuccessDialog.show(
        context: context,
        icon: Icons.check_circle,
        title: "Appointment Confirmed",
        subtitle: "Your appointment and payment have been successful!",
        onPressed: () {
          Navigator.pop(context); // Close dialog

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ReceiptScreen(
                doctorName: widget.doctor.name,
                specialization: widget.doctor.specialization,
                time: widget.selectedTime,
                fee: "\$${widget.doctor.doctorFee}",
                paymentMethod: _selectedMethod.name.toUpperCase(),
              ),
            ),
          );
        },
      );
    } else {
      // Get the error message from provider
      final error = ref.read(appointmentProvider).error ?? 'Booking failed';
      String displayError = error.replaceAll('Exception: ', '');
      
      // If doctor is not available, show clear message
      if (displayError.toLowerCase().contains('not available')) {
        displayError = 'Doctor is not available today. Please choose another day.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(displayError),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const BookingHeader(
              title: "Payment",
              subtitle: "Complete your booking",
            ),
            const SizedBox(height: 20),

            DoctorInfoCard(doctor: widget.doctor),

            FeeBreakdownCard(
              doctorFee: widget.doctor.doctorFee,
              serviceFee: 5.0,
            ),

            const SizedBox(height: 10),

            PaymentMethodSelection(
              selectedMethod: _selectedMethod,
              onMethodSelected: (method) {
                setState(() {
                  _selectedMethod = method;
                });
              },
            ),

            PaymentMethodDetails(selectedMethod: _selectedMethod),

            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomBookButton(
        onTap: _isProcessing ? () {} : _handlePayment,
      ),
    );
  }
}
