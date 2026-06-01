import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/parking_provider.dart';
import 'add_parking_screen.dart';
import '../slot_mgmt/slot_status_screen.dart';

class ParkingListScreen extends ConsumerWidget {
  const ParkingListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spots = ref.watch(parkingProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Filter spots owned by Sarah Jenkins (Spot 1 and Spot 4 in our mock data represent her listings)
    final ownedSpots = spots.where((s) => s.id == 'spot_1' || s.id == 'spot_4').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Parking Listings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, size: 28),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddParkingScreen()),
              );
            },
          )
        ],
      ),
      body: ownedSpots.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_parking_rounded, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No listings created yet.',
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
              itemCount: ownedSpots.length,
              itemBuilder: (context, index) {
                final spot = ownedSpots[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        child: Image.network(
                          spot.imageUrl,
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.image),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  spot.typeLabel,
                                  style: GoogleFonts.outfit(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                Text(
                                  '\$${spot.pricePerHour.toStringAsFixed(2)}/hr',
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              spot.name,
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              spot.address,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                              ),
                            ),
                            const Divider(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.sensor_window_rounded, size: 16, color: AppColors.secondary),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${spot.availableSlotsCount} / ${spot.totalSlotsCount} Slots Free',
                                      style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => SlotStatusScreen(spot: spot),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Manage Slots',
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
