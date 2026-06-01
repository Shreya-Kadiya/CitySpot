import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/parking_provider.dart';
import '../../../providers/booking_provider.dart';
import '../../notifications/notifications_screen.dart';
import '../details/spot_details_screen.dart';
import '../active_booking/active_booking_screen.dart';
import '../../../core/widgets/status_badge.dart';

class HomeDashboard extends ConsumerWidget {
  const HomeDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spots = ref.watch(parkingProvider);
    final bookings = ref.watch(bookingProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Get active booking if any
    final activeBooking = ref.read(bookingProvider.notifier).activeBooking;

    // Calculate live counter
    int totalAvailable = 0;
    for (var spot in spots) {
      totalAvailable += spot.availableSlotsCount;
    }

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Simulator already updates state, just add a brief delay to simulate API reload
            await Future.delayed(const Duration(seconds: 1));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Profile + Notifications)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Find Parking',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Hello, Sarah!',
                          style: GoogleFonts.outfit(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Badge(
                        label: Text('3'),
                        child: Icon(Icons.notifications_outlined, size: 28),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Search Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: 'Search destination, landmarks...',
                            hintStyle: GoogleFonts.outfit(
                              color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onTap: () {
                            // Can jump to map or search tab
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.tune, size: 20),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Active Booking Alert Banner
                if (activeBooking != null) ...[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ActiveBookingScreen(booking: activeBooking),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, Color(0xFFFF5E7D)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.drive_eta_rounded, color: Colors.white),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ACTIVE RESERVATION',
                                  style: GoogleFonts.outfit(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white.withOpacity(0.8),
                                    letterSpacing: 1,
                                  ),
                                ),
                                Text(
                                  activeBooking.spot.name,
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Passcode: ${activeBooking.passcode} • Tap to view',
                                  style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Live Availability Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppColors.iotAvailable,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'IoT Live Occupancy Feed',
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    color: AppColors.iotAvailable,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$totalAvailable Open Spots',
                              style: GoogleFonts.outfit(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Available near your current area.',
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.radar_rounded,
                          color: AppColors.secondary,
                          size: 36,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Popular Locations Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Nearby Spot recommendations',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'See All',
                        style: GoogleFonts.outfit(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Spot Recommendation Cards Horizontal Scroller
                SizedBox(
                  height: 240,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: spots.length,
                    itemBuilder: (context, index) {
                      final spot = spots[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SpotDetailsScreen(spot: spot),
                            ),
                          );
                        },
                        child: Container(
                          width: 220,
                          margin: const EdgeInsets.only(right: 16, bottom: 8),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.cardDark : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark ? AppColors.borderDark : AppColors.borderLight,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                                child: Image.network(
                                  spot.imageUrl,
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(child: Icon(Icons.image));
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      spot.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.outfit(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${spot.distanceKm} km away • \$${spot.pricePerHour.toStringAsFixed(2)}/hr',
                                      style: GoogleFonts.outfit(
                                        fontSize: 13,
                                        color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        StatusBadge(
                                          status: spot.availableSlotsCount > 0
                                              ? ParkingSpotStatus.available
                                              : ParkingSpotStatus.occupied,
                                          showDot: false,
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.star, color: Colors.amber, size: 14),
                                            const SizedBox(width: 4),
                                            Text(
                                              spot.rating.toString(),
                                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
