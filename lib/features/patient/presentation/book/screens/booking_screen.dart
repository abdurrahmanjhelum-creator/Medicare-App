import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../models/doctor_model.dart';
import '../widgets/header.dart';
import '../widgets/time_selection_widget.dart';
import '../widgets/bottom_confirm_button.dart';
import '../widgets/patient_notes_widget.dart';
import '../widgets/doctor_info_card.dart';
import 'payment.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final DoctorModel doctor;

  const BookingScreen({
    super.key,
    required this.doctor,
  });

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  String? _selectedTime;
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _handleBooking() {
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a time slot')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          doctor: widget.doctor,
          selectedTime: _selectedTime!,
          notes: _notesController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const BookingHeader(
              title: "Book Appointment",
              subtitle: "Schedule your visit",
            ),
            const SizedBox(height: 20),

            DoctorInfoCard(doctor: widget.doctor),

            TimeSelectionWidget(
              timeSlots: widget.doctor.availableSlots,
              selectedTime: _selectedTime,
              onTimeSelected: (time) {
                setState(() {
                  _selectedTime = time;
                });
              },
            ),

            const SizedBox(height: 10),

            PatientNotesWidget(
              controller: _notesController,
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomBookButton(
        onTap: _handleBooking,
      ),
    );
  }
}
