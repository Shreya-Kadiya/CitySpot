import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/booking_model.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/vehicle_icon.dart';
import '../../../providers/booking_provider.dart';

class ActiveBookingScreen extends ConsumerStatefulWidget {
  final BookingModel booking;

  const ActiveBookingScreen({
    Key? key,
    required this.booking,
  }) : super(key: key);

  @override
  ConsumerState<ActiveBookingScreen> createState() => _ActiveBookingScreenState();
}

class _ActiveBookingScreenState extends ConsumerState<ActiveBookingScreen> {
  late Timer _countdownTimer;
  late Duration _remainingDuration;
  bool _isCheckedIn = false;

  @override
  void initState() {
    super.initState();
    _isCheckedIn = widget.booking.isCheckedIn;
    // Calculate remaining duration
    final now = DateTime.now();
    if (widget.booking.endTime.isAfter(now)) {
      _remainingDuration = widget.booking.endTime.difference(now);
    } else {
      _remainingDuration = const Duration(hours: 1, minutes: 15); // Fallback mock countdown
    }

    _startCountdown();
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingDuration.inSeconds > 0) {
        setState(() {
          _remainingDuration = _remainingDuration - const Duration(seconds: 1);
        });
      } else {
        _countdownTimer.cancel();
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  void _handleCheckInToggle() {
    if (!_isCheckedIn) {
      setState(() {
        _isCheckedIn = true;
      });
      ref.read(bookingProvider.notifier).checkIn(widget.booking.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gate check-in successful! EV charging activated.'),
          backgroundColor: AppColors.iotAvailable,
        ),
      );
    } else {
      // Checkout
      _countdownTimer.cancel();
      ref.read(bookingProvider.notifier).completeBooking(widget.booking.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Checked out successfully. Platform invoice generated.'),
          backgroundColor: AppColors.secondary,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Reservation'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Timer Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _isCheckedIn ? AppColors.primary.withOpacity(0.1) : AppColors.iotReserved.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isCheckedIn ? Icons.hourglass_top_rounded : Icons.lock_clock,
                    color: _isCheckedIn ? AppColors.primary : AppColors.iotReserved,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isCheckedIn ? 'Time Remaining' : 'Pending Check-in',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _isCheckedIn ? AppColors.primary : Colors.orange.shade800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Live Countdown Timer Display
            Text(
              _formatDuration(_remainingDuration),
              style: GoogleFonts.outfit(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
              ),
            ),
            const SizedBox(height: 32),

            // Entrance code or QR Code simulator
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Assigned Slot',
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                            ),
                          ),
                          Text(
                            widget.booking.slot.label,
                            style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _isCheckedIn ? AppColors.iotAvailable.withOpacity(0.12) : AppColors.iotReserved.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _isCheckedIn ? 'Parked' : 'Reserved',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _isCheckedIn ? AppColors.iotAvailable : Colors.orange.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  // Passcode entry Code display
                  Text(
                    'Gate Verification Passcode',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.secondary.withOpacity(0.24)),
                    ),
                    child: Center(
                      child: Text(
                        widget.booking.passcode,
                        style: GoogleFonts.outfit(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                          letterSpacing: 3,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Key in this passcode at the entrance kiosk gate.',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Navigation shortcuts
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Redirecting to Google Maps...'),
                          backgroundColor: AppColors.secondary,
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? AppColors.borderDark : AppColors.borderLight,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.navigation_outlined, color: AppColors.secondary),
                          const SizedBox(width: 8),
                          Text(
                            'Navigate',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondary,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Calling Plaza Admin Helpdesk...'),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? AppColors.borderDark : AppColors.borderLight,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.help_outline_rounded, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Helpdesk',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Spot details summary card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    VehicleIcon(type: widget.booking.vehicle.type, size: 36),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.booking.spot.name,
                            style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Vehicle: ${widget.booking.vehicle.nickname} (${widget.booking.vehicle.plateNumber})',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 48),

            // Check In / Check Out main button
            CustomButton(
              text: _isCheckedIn ? 'Slide to Check Out' : 'Simulate Kiosk Check-In',
              onPressed: _handleCheckInToggle,
              isPrimary: !_isCheckedIn,
            ),
            const SizedBox(height: 12),
            if (!_isCheckedIn)
              TextButton(
                onPressed: () {
                  ref.read(bookingProvider.notifier).cancelBooking(widget.booking.id);
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel Reservation',
                  style: GoogleFonts.outfit(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
