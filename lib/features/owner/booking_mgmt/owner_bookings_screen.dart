import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/booking_model.dart';
import '../../../providers/booking_provider.dart';
import '../../../core/widgets/vehicle_icon.dart';

class OwnerBookingsScreen extends ConsumerWidget {
  const OwnerBookingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookings = ref.watch(bookingProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Filter bookings belonging to Sarah's plazas (Spot 1 and Spot 4 are owned by her)
    final hostBookings = bookings
        .where((b) => b.spot.id == 'spot_1' || b.spot.id == 'spot_4')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Occupancy Monitoring'),
      ),
      body: hostBookings.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.format_list_bulleted_rounded, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No active bookings monitored',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: hostBookings.length,
              itemBuilder: (context, index) {
                final booking = hostBookings[index];
                final isCheckedIn = booking.isCheckedIn;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              booking.spot.name,
                              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isCheckedIn
                                    ? AppColors.iotAvailable.withOpacity(0.12)
                                    : AppColors.iotReserved.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                isCheckedIn ? 'Checked In' : 'Reserved',
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isCheckedIn ? AppColors.iotAvailable : Colors.orange.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          booking.slot.label,
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'License Plate',
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.bgDark : Colors.grey.shade100,
                                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                booking.vehicle.plateNumber,
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Duration schedule',
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                              ),
                            ),
                            Text(
                              '${DateFormat('hh:mm a').format(booking.startTime)} - ${DateFormat('hh:mm a').format(booking.endTime)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'User passcode',
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                              ),
                            ),
                            Text(
                              booking.passcode,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
