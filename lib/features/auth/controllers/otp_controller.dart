// ============================================================
// otp_controller.dart — OTP Verification (Backend)
// Backend ke /auth/verify-otp endpoint se OTP verify karta hai
// Timer bhi hai — 60 seconds countdown
// ============================================================

import 'dart:async';                   // Timer ke liye
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart'; // API calls ke liye

// ---- State ----
class OtpState {
  final int secondsRemaining;  // Timer countdown
  final bool isTimerActive;    // Timer chal raha hai ya band
  final bool isLoading;        // API call chal rahi hai

  OtpState({
    this.secondsRemaining = 60,
    this.isTimerActive = true,
    this.isLoading = false,
  });

  OtpState copyWith({int? secondsRemaining, bool? isTimerActive, bool? isLoading}) {
    return OtpState(
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      isTimerActive: isTimerActive ?? this.isTimerActive,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// ---- Notifier ----
class OtpNotifier extends StateNotifier<OtpState> {
  OtpNotifier() : super(OtpState()) {
    startTimer(); // Screen khulte hi timer shuru karo
  }

  // 4 alag text fields (har digit ke liye ek)
  final TextEditingController otp1Controller = TextEditingController();
  final TextEditingController otp2Controller = TextEditingController();
  final TextEditingController otp3Controller = TextEditingController();
  final TextEditingController otp4Controller = TextEditingController();

  // Focus nodes — ek digit type karne ke baad agla field focus ho
  final FocusNode otp1Focus = FocusNode();
  final FocusNode otp2Focus = FocusNode();
  final FocusNode otp3Focus = FocusNode();
  final FocusNode otp4Focus = FocusNode();

  Timer? _timer; // Timer object

  // ---- Countdown timer shuru karo ----
  void startTimer() {
    state = state.copyWith(secondsRemaining: 60, isTimerActive: true);
    _timer?.cancel(); // Pehle wala timer band karo
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (state.secondsRemaining > 0) {
        // Har second ek kam karo
        state = state.copyWith(secondsRemaining: state.secondsRemaining - 1);
      } else {
        // Timer khatam
        state = state.copyWith(isTimerActive: false);
        t.cancel();
      }
    });
  }

  // ---- 4 digits milakar OTP string banao ----
  String getOtp() {
    return otp1Controller.text +
        otp2Controller.text +
        otp3Controller.text +
        otp4Controller.text;
  }

  // ---- Validation ----
  String? validateOtp() {
    if (getOtp().length != 4) return "Poora OTP daalen (4 digits)";
    return null;
  }

  // ============================================================
  // verifyOtp() — Backend se OTP verify karo
  // email — forget password screen se aata hai
  // ============================================================
  Future<bool> verifyOtp(String email) async {
    state = state.copyWith(isLoading: true);

    try {
      // POST /api/auth/verify-otp
      await ApiService.post(
        endpoint: '/auth/verify-otp',
        body: {
          'email': email,    // Jis email par OTP bheja tha
          'otp': getOtp(),   // 4-digit OTP
        },
      );

      state = state.copyWith(isLoading: false);
      return true; // OTP verify ho gaya

    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  // ---- Controllers dispose karo ----
  void disposeControllers() {
    _timer?.cancel(); // Timer band karo
    otp1Controller.dispose();
    otp2Controller.dispose();
    otp3Controller.dispose();
    otp4Controller.dispose();
    otp1Focus.dispose();
    otp2Focus.dispose();
    otp3Focus.dispose();
    otp4Focus.dispose();
  }
}
