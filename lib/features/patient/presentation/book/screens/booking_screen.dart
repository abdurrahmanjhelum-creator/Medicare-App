import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/providers/providers.dart';
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
  DateTime? _selectedDate;
  final TextEditingController _notesController = TextEditingController();
  DoctorModel? _latestDoctor;
  bool _isLoadingLatestDoctor = true;

  @override
  void initState() {
    super.initState();
    // Default to today
    _selectedDate = DateTime.now();
    Future.microtask(_loadLatestDoctor);
  }

  Future<void> _loadLatestDoctor() async {
    try {
      final freshDoctor = await ref
          .read(doctorProvider.notifier)
          .fetchDoctorById(widget.doctor.id);
      if (!mounted) return;
      setState(() {
        _latestDoctor = freshDoctor ?? widget.doctor;
        _isLoadingLatestDoctor = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _latestDoctor = widget.doctor;
        _isLoadingLatestDoctor = false;
      });
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _handleBooking() {
    final doctor = _latestDoctor ?? widget.doctor;

    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a time slot')),
      );
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          doctor: doctor,
          selectedTime: _selectedTime!,
          selectedDate: _selectedDate!,
          notes: _notesController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final doctor = _latestDoctor ?? widget.doctor;
    final timeSlots = doctor.availableSlots;

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

            DoctorInfoCard(doctor: doctor),

            // Date Selection
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Date',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff1a1a1a),
                    ),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                      );
                      if (picked != null) {
                        setState(() {
                          _selectedDate = picked;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xffe0e0e0)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              color: Color(0xff089B73)),
                          const SizedBox(width: 12),
                          Text(
                            _selectedDate != null
                                ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                : 'Select Date',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xff1a1a1a),
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_drop_down,
                              color: Color(0xff999999)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            if (_isLoadingLatestDoctor)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: CircularProgressIndicator(),
              )
            else
              TimeSelectionWidget(
                timeSlots: timeSlots,
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
        onTap: () {
          if (_isLoadingLatestDoctor) return;
          _handleBooking();
        },
      ),
    );
  }
}
