import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/booking_model.dart';
import '../../../providers/booking_provider.dart';
import '../../../core/widgets/vehicle_icon.dart';
import '../active_booking/active_booking_screen.dart';

class BookingHistoryScreen extends ConsumerStatefulWidget {
  const BookingHistoryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends ConsumerState<BookingHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookings = ref.watch(bookingProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final upcomingBookings = bookings
        .where((b) => b.status == BookingStatus.upcoming || b.status == BookingStatus.active)
        .toList();
    final pastBookings = bookings
        .where((b) => b.status == BookingStatus.completed || b.status == BookingStatus.cancelled)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingList(upcomingBookings, isDark, true),
          _buildBookingList(pastBookings, isDark, false),
        ],
      ),
    );
  }

  Widget _buildBookingList(List<BookingModel> list, bool isDark, bool isUpcoming) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isUpcoming ? Icons.calendar_today_outlined : Icons.history_rounded,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              isUpcoming ? 'No upcoming reservations' : 'No booking history found',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final booking = list[index];
        final isActive = booking.status == BookingStatus.active;
        final isCancelled = booking.status == BookingStatus.cancelled;

        return GestureDetector(
          onTap: () {
            if (booking.status == BookingStatus.active || booking.status == BookingStatus.upcoming) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ActiveBookingScreen(booking: booking),
                ),
              );
            }
          },
          child: Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('EEE, MMM dd, yyyy').format(booking.startTime),
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.primary.withOpacity(0.12)
                              : (isCancelled
                                  ? Colors.redAccent.withOpacity(0.12)
                                  : (booking.status == BookingStatus.completed
                                      ? AppColors.iotAvailable.withOpacity(0.12)
                                      : AppColors.iotReserved.withOpacity(0.12))),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isActive
                              ? 'Active Now'
                              : (isCancelled
                                  ? 'Cancelled'
                                  : (booking.status == BookingStatus.completed ? 'Completed' : 'Upcoming')),
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isActive
                                ? AppColors.primary
                                : (isCancelled
                                    ? Colors.redAccent
                                    : (booking.status == BookingStatus.completed ? AppColors.iotAvailable : Colors.orange.shade800)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          booking.spot.imageUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.image),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking.spot.name,
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              booking.slot.label,
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                color: AppColors.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                VehicleIcon(type: booking.vehicle.type, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  booking.vehicle.nickname,
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${booking.totalAmount.toStringAsFixed(2)}',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            '${booking.endTime.difference(booking.startTime).inHours} hours',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
