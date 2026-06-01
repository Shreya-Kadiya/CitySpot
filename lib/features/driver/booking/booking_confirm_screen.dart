import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/parking_spot.dart';
import '../../../models/vehicle_model.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/vehicle_icon.dart';

class BookingConfirmScreen extends StatelessWidget {
  final ParkingSpot spot;
  final ParkingSlot slot;
  final VehicleModel vehicle;
  final DateTime startTime;
  final DateTime endTime;
  final double total;

  const BookingConfirmScreen({
    Key? key,
    required this.spot,
    required this.slot,
    required this.vehicle,
    required this.startTime,
    required this.endTime,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Animated Success Ring
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.iotAvailable.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    size: 80,
                    color: AppColors.iotAvailable,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Reservation Confirmed!',
                  style: GoogleFonts.outfit(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your smart parking space has been successfully reserved.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.textDarkSecondary
                        : AppColors.textLightSecondary,
                  ),
                ),
                const SizedBox(height: 40),

                // Booking Details summary card
                Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color:
                        isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      spot.name,
                      style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      slot.label,
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),
                    const Divider(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Vehicle',
                          style: GoogleFonts.outfit(
                            color: isDark
                                ? AppColors.textDarkSecondary
                                : AppColors.textLightSecondary,
                            fontSize: 13,
                          ),
                        ),
                        Row(
                          children: [
                            VehicleIcon(type: vehicle.type, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              vehicle.nickname,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Start Time',
                          style: GoogleFonts.outfit(
                            color: isDark
                                ? AppColors.textDarkSecondary
                                : AppColors.textLightSecondary,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          DateFormat('MMM dd • hh:mm a').format(startTime),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'End Time',
                          style: GoogleFonts.outfit(
                            color: isDark
                                ? AppColors.textDarkSecondary
                                : AppColors.textLightSecondary,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          DateFormat('MMM dd • hh:mm a').format(endTime),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Paid Amount',
                          style: GoogleFonts.outfit(
                            color: isDark
                                ? AppColors.textDarkSecondary
                                : AppColors.textLightSecondary,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          '\$${total.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    Text(
                      'Automated Entry Code',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textDarkSecondary
                            : AppColors.textLightSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppColors.primary.withOpacity(0.24)),
                      ),
                      child: Text(
                        'CITY-9921',
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              CustomButton(
                text: 'Done & Back to Home',
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      ));
  }
}
