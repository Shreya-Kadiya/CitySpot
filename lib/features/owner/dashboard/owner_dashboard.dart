import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/parking_provider.dart';
import '../../../providers/booking_provider.dart';
import '../../../core/constants/mock_data.dart';
import '../../../core/widgets/status_badge.dart';
import '../slot_mgmt/slot_status_screen.dart';

class OwnerDashboard extends ConsumerWidget {
  const OwnerDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spots = ref.watch(parkingProvider);
    final bookings = ref.watch(bookingProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Filter slots owned by Sarah Jenkins (e.g. Spot 1 and Spot 4 in our mock data represent her assets)
    final ownedSpots = spots.where((s) => s.id == 'spot_1' || s.id == 'spot_4').toList();

    // Calculate host statistics
    int totalSlots = 0;
    int occupiedSlots = 0;
    for (var spot in ownedSpots) {
      totalSlots += spot.totalSlotsCount;
      occupiedSlots += spot.slots.where((s) => s.status == ParkingSpotStatus.occupied).length;
    }
    final occupancyRate = totalSlots > 0 ? (occupiedSlots / totalSlots) * 100 : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              // Trigger simulator manually by forcing state update if needed
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hello banner
            Text(
              'Welcome back, Sarah',
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Here is the status of your listed parking locations.',
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
              ),
            ),
            const SizedBox(height: 24),

            // Top Quick Metrics Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.4,
              children: [
                _buildMetricCard(
                  context,
                  'Total Revenue',
                  '\$${MockData.mockEarnings.totalEarnings.toStringAsFixed(0)}',
                  Icons.account_balance_wallet_outlined,
                  AppColors.primary,
                  isDark,
                ),
                _buildMetricCard(
                  context,
                  'Live Occupancy',
                  '${occupancyRate.toStringAsFixed(0)}%',
                  Icons.bar_chart_rounded,
                  AppColors.secondary,
                  isDark,
                ),
                _buildMetricCard(
                  context,
                  'Total Bookings',
                  MockData.mockEarnings.totalBookingsCount.toString(),
                  Icons.book_online_outlined,
                  AppColors.iotAvailable,
                  isDark,
                ),
                _buildMetricCard(
                  context,
                  'Active Chargers',
                  '2 / 4',
                  Icons.bolt_rounded,
                  AppColors.iotReserved,
                  isDark,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Occupancy Analytics Section
            Text(
              'Real-Time Occupancy Analytics',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Active Slots Utilized',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                            ),
                          ),
                          Text(
                            '$occupiedSlots / $totalSlots Slots Occupied',
                            style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Live Feed',
                          style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Progress indicator representing occupancy bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: totalSlots > 0 ? (occupiedSlots / totalSlots) : 0,
                      minHeight: 12,
                      backgroundColor: isDark ? AppColors.bgDark : Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '0% (Empty)',
                        style: GoogleFonts.outfit(fontSize: 11, color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary),
                      ),
                      Text(
                        '100% (Full)',
                        style: GoogleFonts.outfit(fontSize: 11, color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Listed Parking spots
            Text(
              'My Listed Plazas',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ownedSpots.length,
              itemBuilder: (context, index) {
                final spot = ownedSpots[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        spot.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.image),
                      ),
                    ),
                    title: Text(
                      spot.name,
                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        '${spot.availableSlotsCount} / ${spot.totalSlotsCount} Slots Available',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: spot.availableSlotsCount > 0 ? AppColors.iotAvailable : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SlotStatusScreen(spot: spot),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color accentColor,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(icon, color: accentColor, size: 20),
            ],
          ),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
