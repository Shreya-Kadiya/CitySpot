import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/parking_spot.dart';
import '../../../providers/parking_provider.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/widgets/vehicle_icon.dart';

class SlotStatusScreen extends ConsumerWidget {
  final ParkingSpot spot;

  const SlotStatusScreen({
    Key? key,
    required this.spot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch parking spots to receive live status updates
    final spots = ref.watch(parkingProvider);
    final liveSpot = spots.firstWhere((s) => s.id == spot.id, orElse: () => spot);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('${liveSpot.name} Slots'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Telemetry Status Header
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
                    children: [
                      const Icon(Icons.wifi_tethering_rounded, color: AppColors.primary, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'IoT Telemetry & Gateway',
                        style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Simulate sensor events by clicking on slot status control below. Real-time updates will sync instantly across driver and administration panels.',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Live counters
            Text(
              'Configured Slots',
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Visual grid of slots
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: liveSpot.slots.length,
              itemBuilder: (context, index) {
                final slot = liveSpot.slots[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.bgDark : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: VehicleIcon(type: slot.supportedVehicle),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              slot.label,
                              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            const SizedBox(height: 4),
                            StatusBadge(status: slot.status, showDot: true),
                          ],
                        ),
                      ),
                      // IoT Simulator controllers
                      PopupMenuButton<ParkingSpotStatus>(
                        icon: const Icon(Icons.tune_rounded, color: AppColors.primary),
                        tooltip: 'Configure IoT status',
                        onSelected: (ParkingSpotStatus newStatus) {
                          ref.read(parkingProvider.notifier).updateSlotStatus(
                                liveSpot.id,
                                slot.id,
                                newStatus,
                              );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Sensor state modified to ${newStatus.toString().split('.').last.toUpperCase()}.'),
                              duration: const Duration(seconds: 1),
                              backgroundColor: AppColors.primary,
                            ),
                          );
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: ParkingSpotStatus.available,
                            child: Text('Simulate sensor: Available'),
                          ),
                          const PopupMenuItem(
                            value: ParkingSpotStatus.occupied,
                            child: Text('Simulate sensor: Occupied'),
                          ),
                          const PopupMenuItem(
                            value: ParkingSpotStatus.reserved,
                            child: Text('Simulate sensor: Reserved'),
                          ),
                          const PopupMenuItem(
                            value: ParkingSpotStatus.offline,
                            child: Text('Simulate sensor: Offline'),
                          ),
                          const PopupMenuItem(
                            value: ParkingSpotStatus.maintenance,
                            child: Text('Simulate sensor: Maintenance'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
