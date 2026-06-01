import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/parking_spot.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/widgets/vehicle_icon.dart';
import '../booking/booking_flow_screen.dart';
import '../../../providers/parking_provider.dart';

class SpotDetailsScreen extends ConsumerWidget {
  final ParkingSpot spot;

  const SpotDetailsScreen({
    Key? key,
    required this.spot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch parking provider to get real-time IoT slot status changes on this specific spot
    final spots = ref.watch(parkingProvider);
    final liveSpot = spots.firstWhere((s) => s.id == spot.id, orElse: () => spot);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Collapsible Image Header
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            leading: CircleAvatar(
              backgroundColor: isDark ? AppColors.cardDark.withOpacity(0.8) : Colors.white.withOpacity(0.8),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            actions: [
              CircleAvatar(
                backgroundColor: isDark ? AppColors.cardDark.withOpacity(0.8) : Colors.white.withOpacity(0.8),
                child: IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 16),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                liveSpot.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.image)),
              ),
            ),
          ),

          // Content body
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Rating Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          liveSpot.typeLabel,
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            liveSpot.rating.toString(),
                            style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' (${liveSpot.reviewsCount} reviews)',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    liveSpot.name,
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16, color: AppColors.secondary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          liveSpot.address,
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 32),

                  // Real-time IoT Slots Monitor
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Live Slot Occupancy',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.iotAvailable,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'IoT Live',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.iotAvailable,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Slots auto-update when parking hardware detects status changes.',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Slot listings
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: liveSpot.slots.length,
                    itemBuilder: (context, index) {
                      final slot = liveSpot.slots[index];
                      final isAvailable = slot.status == ParkingSpotStatus.available;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.cardDark : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? AppColors.borderDark : AppColors.borderLight,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.bgDark : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: VehicleIcon(type: slot.supportedVehicle, size: 20),
                                ),
                                const SizedBox(width: 14),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      slot.label,
                                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      slot.supportedVehicle == VehicleType.ev
                                          ? 'EV charger equipped'
                                          : '${slot.supportedVehicle.toString().split('.').last.toUpperCase()} Spot',
                                      style: GoogleFonts.outfit(
                                        fontSize: 11,
                                        color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            StatusBadge(status: slot.status),
                          ],
                        ),
                      );
                    },
                  ),
                  const Divider(height: 32),

                  // Description
                  Text(
                    'About this Location',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    liveSpot.description,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                      height: 1.5,
                    ),
                  ),
                  const Divider(height: 32),

                  // Amenities Grid List
                  Text(
                    'Plaza Amenities',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3.5,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: liveSpot.amenities.length,
                    itemBuilder: (context, index) {
                      final amenity = liveSpot.amenities[index];
                      // Choose icon based on text
                      IconData iconData = Icons.done;
                      if (amenity.contains('24/7')) iconData = Icons.security_rounded;
                      if (amenity.contains('EV')) iconData = Icons.bolt;
                      if (amenity.contains('Wheelchair')) iconData = Icons.accessible_rounded;
                      if (amenity.contains('CCTV')) iconData = Icons.videocam_outlined;
                      if (amenity.contains('Covered')) iconData = Icons.umbrella_rounded;

                      return Row(
                        children: [
                          Icon(iconData, size: 20, color: AppColors.secondary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              amenity,
                              style: GoogleFonts.outfit(fontSize: 13),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const Divider(height: 32),

                  // Rules
                  Text(
                    'Rules & Regulations',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...liveSpot.rules.map((rule) => Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                            Expanded(
                              child: Text(
                                rule,
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 100), // padding for floating footer
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price Rate',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                  ),
                ),
                Text(
                  '\$${liveSpot.pricePerHour.toStringAsFixed(2)}/hr',
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: SizedBox(
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: liveSpot.availableSlotsCount > 0
                      ? () {
                          // Route to booking flow passing selected spot
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BookingFlowScreen(spot: liveSpot),
                            ),
                          );
                        }
                      : null,
                  child: Text(
                    liveSpot.availableSlotsCount > 0 ? 'Reserve Slot' : 'Fully Occupied',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
