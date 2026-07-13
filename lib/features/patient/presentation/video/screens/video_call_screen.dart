import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medicare/core/services/token_service.dart';
import 'package:medicare/features/doctor/controllers/appointment_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/appointment_model.dart';
import 'appointment_completed_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VideoCallScreen extends ConsumerStatefulWidget {
  final AppointmentModel appointment;

  const VideoCallScreen({super.key, required this.appointment});

  @override
  ConsumerState<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends ConsumerState<VideoCallScreen> {
  Timer? _sessionTimer;
  Duration _remainingDuration = const Duration(minutes: 30);
  bool _isDoctor = false;
  bool _isEnding = false;
  bool _openedInBrowser = false;
  WebViewController? _webViewController;
  String? _roomUrl;

  @override
  void initState() {
    super.initState();
    // Requirement 10: Prevent joining cancelled or completed appointments
    final status = widget.appointment.status.toLowerCase();
    if (status == 'cancelled' || status == 'completed') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AppointmentCompletedScreen(appointment: widget.appointment),
          ),
        );
      });
      return;
    }
    _checkRole();
    _startSessionTimer();
    _initMeetingUrl();
  }

  Future<void> _checkRole() async {
    final role = await TokenService.getUserRole();
    if (mounted) {
      setState(() {
        _isDoctor = role == 'doctor';
      });
    }
  }

  Future<void> _initMeetingUrl() async {
    final appointmentId = widget.appointment.id;
    if (appointmentId == null || appointmentId.trim().isEmpty) {
      if (!mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Missing appointment id for consultation room.')),
        );
      });
      return;
    }

    final userName = await TokenService.getUserName();
    if (!mounted) return;

    final displayName = (userName ?? '').trim().isNotEmpty ? userName!.trim() : null;
    final url = _buildJitsiUrl(roomName: appointmentId, displayName: displayName);

    if (kIsWeb) {
      setState(() {
        _roomUrl = url;
        _webViewController = null;
      });
      await _openMeetingInBrowser();
      return;
    }

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url));

    setState(() {
      _roomUrl = url;
      _webViewController = controller;
    });
  }

  String _buildJitsiUrl({required String roomName, String? displayName}) {
    final safeRoomName = roomName.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
    final dn = (displayName ?? '').trim();
    if (dn.isEmpty) return 'https://meet.jit.si/$safeRoomName';

    final encodedDisplayName = Uri.encodeComponent(dn);
    return 'https://meet.jit.si/$safeRoomName#config.prejoinPageEnabled=false&config.userInfo.displayName=$encodedDisplayName';
  }

  Future<void> _openMeetingInBrowser() async {
    final url = _roomUrl;
    if (url == null) return;

    final uri = Uri.parse(url);
    if (!await launchUrl(uri, webOnlyWindowName: '_blank', mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open video consultation in browser.')),
      );
      return;
    }

    if (mounted) {
      setState(() => _openedInBrowser = true);
    }
  }

  void _startSessionTimer() {
    // Calculate remaining time based on appointment end time
    try {
      final now = DateTime.now();
      String timeStr = widget.appointment.time.toUpperCase()
          .replaceAll('AM', ' AM')
          .replaceAll('PM', ' PM')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
      
      List<String> parts = timeStr.split(RegExp(r'[-–—]'));
      DateTime endTime;
      
      DateTime parse(String s) {
        DateFormat format = s.contains('AM') || s.contains('PM') ? DateFormat("h:mm a") : DateFormat("HH:mm");
        DateTime p = format.parse(s.trim());
        return DateTime(now.year, now.month, now.day, p.hour, p.minute);
      }

      if (parts.length > 1) {
        endTime = parse(parts.last);
      } else {
        endTime = parse(parts.first).add(const Duration(minutes: 30));
      }

      final diff = endTime.difference(now);
      _remainingDuration = diff.isNegative ? Duration.zero : diff;
    } catch (_) {
      _remainingDuration = const Duration(minutes: 30);
    }

    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingDuration.inSeconds > 0) {
        if (mounted) {
          setState(() {
            _remainingDuration -= const Duration(seconds: 1);
          });
        }
      } else {
        _sessionTimer?.cancel();
        _endMeeting();
      }
    });
  }

  Future<void> _endMeeting() async {
    if (!mounted || _isEnding) return;
    _isEnding = true;

    final appointmentId = widget.appointment.id;
    try {
      // Ensure correct role even if _checkRole() hasn't completed yet.
      final role = await TokenService.getUserRole();
      final isDoctorNow = role == 'doctor';

      // Requirement 7: Change status to Completed automatically for the doctor.
      if (isDoctorNow && appointmentId != null && appointmentId.trim().isNotEmpty) {
        await ref.read(doctorAppointmentProvider.notifier).updateAppointmentStatus(
              appointmentId,
              'completed',
              silent: true,
            );
      }
    } catch (_) {
      // Status update failures shouldn't block navigation to completion screen.
    } finally {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AppointmentCompletedScreen(appointment: widget.appointment),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    return "${twoDigits(d.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _endMeeting();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        _endMeeting();
                      },
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isDoctor ? "Patient: ${widget.appointment.doctorName}" : widget.appointment.doctorName,
                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Time Remaining: ${_formatDuration(_remainingDuration)}",
                            style: const TextStyle(color: Colors.redAccent, fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(20)),
                      child: const Text(
                        "Live",
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              // Video area: embedded meeting (mobile) or browser launch (web)
              Expanded(
                child: kIsWeb
                    ? _buildWebMeetingPanel()
                    : _webViewController == null
                        ? const Center(child: CircularProgressIndicator(color: Colors.white))
                        : WebViewWidget(controller: _webViewController!),
              ),
              // Controls
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.grey[900]?.withOpacity(0.9),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildControlButton(Icons.mic, Colors.white, () {}),
                    _buildControlButton(Icons.videocam, Colors.white, () {}),
                    _buildControlButton(Icons.call_end, Colors.red, () {
                      _endMeeting();
                    }),
                    _buildControlButton(Icons.flip_camera_ios, Colors.white, () {}),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWebMeetingPanel() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.videocam, color: Colors.white, size: 72),
            const SizedBox(height: 24),
            Text(
              _openedInBrowser
                  ? 'Video consultation opened in a new browser tab.'
                  : 'Preparing your video consultation room...',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 24),
            if (_roomUrl != null)
              ElevatedButton.icon(
                onPressed: _openMeetingInBrowser,
                icon: const Icon(Icons.open_in_new),
                label: const Text('Open Video Call'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A67E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, color: color == Colors.white ? Colors.black : Colors.white, size: 28),
      ),
    );
  }
}
