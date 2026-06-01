import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

enum ParkingSpotStatus {
  available,
  occupied,
  reserved,
  offline,
  maintenance,
}

class StatusBadge extends StatelessWidget {
  final ParkingSpotStatus status;
  final bool showDot;

  const StatusBadge({
    Key? key,
    required this.status,
    this.showDot = true,
  }) : super(key: key);

  String get label {
    switch (status) {
      case ParkingSpotStatus.available:
        return 'Available';
      case ParkingSpotStatus.occupied:
        return 'Occupied';
      case ParkingSpotStatus.reserved:
        return 'Reserved';
      case ParkingSpotStatus.offline:
        return 'Offline';
      case ParkingSpotStatus.maintenance:
        return 'Under Maintenance';
    }
  }

  Color get color {
    switch (status) {
      case ParkingSpotStatus.available:
        return AppColors.iotAvailable;
      case ParkingSpotStatus.occupied:
        return AppColors.iotOccupied;
      case ParkingSpotStatus.reserved:
        return AppColors.iotReserved;
      case ParkingSpotStatus.offline:
        return AppColors.iotOffline;
      case ParkingSpotStatus.maintenance:
        return AppColors.iotMaintenance;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.24), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: statusColor == AppColors.iotReserved ? Colors.orange.shade800 : statusColor,
            ),
          ),
        ],
      ),
    );
  }
}
